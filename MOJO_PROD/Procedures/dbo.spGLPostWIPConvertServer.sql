USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIPConvertServer]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostWIPConvertServer]
AS --Encrypt
	
/* GHL Creation for wip conversion
   Modif to increase perfo
*/
	DECLARE @CompanyKey INT
	
	CREATE TABLE #tComp (CompanyKey INT NULL)
	INSERT #tComp 
	SELECT DISTINCT t.CompanyKey
	FROM   tTransaction t (NOLOCK) 
		INNER JOIN tCompany c (NOLOCK) ON t.CompanyKey = c.CompanyKey
	WHERE c.Locked = 0
	AND   c.Active = 1
	AND t.Entity = 'WIP'
		
	if not exists (select 1 from sysobjects 
		where xtype='U' 
		and name = 'tWIPConvertDetail')
	begin
		CREATE TABLE tWIPConvertDetail(Entity VARCHAR(50) NULL, EntityKey INT NULL, UIDEntityKey UNIQUEIDENTIFIER NULL,
				CompanyKey INT NULL, ProjectKey INT NULL, Amount MONEY NULL,
				TransactionKey INT NULL, TranAmount money NULL ,
				NewTransactionKey INT NULL, NewTranAmount money NULL, GPFlag int null )
				
		 CREATE CLUSTERED INDEX [IX_tWIPConvertDetail] ON [tWIPConvertDetail]([CompanyKey], [TransactionKey])
		
	 	end
 	
 	if not exists (select 1 from sysobjects 
		where xtype='U' 
		and name = 'tWIPConvert')
	begin
		CREATE TABLE tWIPConvert(CompanyKey INT NULL, TransactionKey INT NULL, Status INT,
			  TranAmount money NULL ,NewTranAmount money NULL) 
				
		CREATE CLUSTERED INDEX [IX_tWIPConvert] ON [tWIPConvert]([CompanyKey], [TransactionKey])	
	 end	
		
		
	IF NOT EXISTS (SELECT 1 FROM tWIPConvertDetail)
	BEGIN
		INSERT tWIPConvertDetail (Entity, EntityKey, UIDEntityKey, CompanyKey, TransactionKey, TranAmount, ProjectKey, 
			NewTransactionKey, NewTranAmount, GPFlag)
		SELECT wpd.Entity, wpd.EntityKey, wpd.UIDEntityKey, wp.CompanyKey, wpd.TransactionKey, t.Debit + t.Credit, 0,
			wpd.TransactionKey, t.Debit + t.Credit, 0
		FROM   tWIPPostingDetail wpd (NOLOCK)
			INNER JOIN tWIPPosting wp (NOLOCK) ON wpd.WIPPostingKey = wp.WIPPostingKey
			INNER JOIN #tComp c (NOLOCK) ON wp.CompanyKey = c.CompanyKey
			INNER JOIN tTransaction t (NOLOCK) ON wpd.TransactionKey = t.TransactionKey 

		IF @@ERROR <> 0
			RETURN -1

		UPDATE tWIPConvertDetail
		SET    tWIPConvertDetail.ProjectKey = ISNULL(t.ProjectKey, 0)
				,tWIPConvertDetail.Amount = ISNULL(ROUND(t.ActualHours * t.ActualRate, 2), 0)
		FROM   tTime t (NOLOCK)
		WHERE  tWIPConvertDetail.Entity = 'tTime'
		AND    tWIPConvertDetail.UIDEntityKey = t.TimeKey
		
		IF @@ERROR <> 0
			RETURN -1
				
		UPDATE tWIPConvertDetail
		SET    tWIPConvertDetail.ProjectKey = ISNULL(t.ProjectKey, 0)
				,tWIPConvertDetail.Amount = ISNULL(t.ActualCost, 0)
		FROM   tExpenseReceipt t (NOLOCK)
		WHERE  tWIPConvertDetail.Entity = 'tExpenseReceipt'
		AND    tWIPConvertDetail.EntityKey = t.ExpenseReceiptKey
		
		IF @@ERROR <> 0
			RETURN -1
		
		UPDATE tWIPConvertDetail
		SET    tWIPConvertDetail.ProjectKey = ISNULL(t.ProjectKey, 0)
				,tWIPConvertDetail.Amount = ISNULL(t.TotalCost, 0)
		FROM   tMiscCost t (NOLOCK)
		WHERE  tWIPConvertDetail.Entity = 'tMiscCost'
		AND    tWIPConvertDetail.EntityKey = t.MiscCostKey
		
		IF @@ERROR <> 0
			RETURN -1
			
		UPDATE tWIPConvertDetail
		SET    tWIPConvertDetail.ProjectKey = ISNULL(t.ProjectKey, 0)
				,tWIPConvertDetail.Amount = ISNULL(t.TotalCost, 0)
		FROM   tVoucherDetail t (NOLOCK)
		WHERE  tWIPConvertDetail.Entity = 'tVoucherDetail'
		AND    tWIPConvertDetail.EntityKey = t.VoucherDetailKey
		
		IF @@ERROR <> 0
			RETURN -1
	
	END


		
	IF NOT EXISTS (SELECT 1 FROM tWIPConvert)
	BEGIN
		INSERT tWIPConvert (CompanyKey, TransactionKey, Status, TranAmount, NewTranAmount)
		SELECT c.CompanyKey, t.TransactionKey, -999, t.Debit + t.Credit, 0
		FROM #tComp c (NOLOCK)
			INNER JOIN tTransaction t (NOLOCK) ON c.CompanyKey = t.CompanyKey 
		WHERE t.Entity = 'WIP'
		
		IF @@ERROR <> 0
			RETURN -1
	END
		
	SELECT @CompanyKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @CompanyKey = MIN(CompanyKey)
		FROM   #tComp
		WHERE  CompanyKey > @CompanyKey
		
		IF @CompanyKey IS NULL
			BREAK
			
		EXEC spGLPostWIPConvertCompany @CompanyKey	  
	
	END	
	
	RETURN 1
GO
