USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWIPPostingDetailGetTransactionList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWIPPostingDetailGetTransactionList]
	(
		@TransactionKey INT
		,@Entity VARCHAR(100)
	)
AS --Encrypt

	SET NOCOUNT ON 
	
/*
|| When     Who Rel     What
|| 08/22/07 GHL 8.5     Added ProjectKey, etc for drill downs 
*/

	IF @Entity = 'tTime'
	
		SELECT wpd.* 
			,v.*
			,ISNULL(v.FirstName, '') + ' ' + ISNULL(v.LastName, '') AS UserName
		FROM   tWIPPostingDetail wpd (NOLOCK)
			INNER JOIN vTimeDetail v (NOLOCK) ON wpd.UIDEntityKey = v.TimeKey
		WHERE  wpd.TransactionKey = @TransactionKey
		AND	   Entity = @Entity
		
	ELSE IF @Entity = 'tExpenseReceipt'
	
		SELECT wpd.* 
			,v.*
			,ISNULL(v.FirstName, '') + ' ' + ISNULL(v.LastName, '') AS UserName
		FROM   tWIPPostingDetail wpd (NOLOCK)
			INNER JOIN vExpenseReport v (NOLOCK) ON wpd.EntityKey = v.ExpenseReceiptKey	
		WHERE  wpd.TransactionKey = @TransactionKey
		AND	   Entity = @Entity

	ELSE IF @Entity = 'tVoucherDetail'
	
		SELECT wpd.* 
			,v.*
		FROM   tWIPPostingDetail wpd (NOLOCK)
			INNER JOIN vVoucherDetail v (NOLOCK) ON wpd.EntityKey = v.VoucherDetailKey
		WHERE  wpd.TransactionKey = @TransactionKey
		AND	   Entity = @Entity


	ELSE IF @Entity = 'tMiscCost'
	
		SELECT wpd.* 
			   ,p.ProjectKey
			   ,p.ProjectNumber
			   ,i.ItemName
			   ,mc.ExpenseDate
			   ,mc.TotalCost   
			   ,mc.TotalCost as ActualCost 	
			   ,mc.ShortDescription as Description		
		FROM   tWIPPostingDetail wpd (NOLOCK)
			INNER JOIN tMiscCost mc (NOLOCK) ON wpd.EntityKey = mc.MiscCostKey  
			INNER JOIN tProject p (NOLOCK) ON mc.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tItem i (NOLOCK) ON mc.ItemKey = i.ItemKey
		WHERE  wpd.TransactionKey = @TransactionKey
		AND	   Entity = @Entity    
		
	
		
	RETURN 1
GO
