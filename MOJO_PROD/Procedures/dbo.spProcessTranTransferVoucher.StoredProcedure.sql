USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessTranTransferVoucher]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessTranTransferVoucher]
	(
	    @UserKey int
		,@CompanyKey int
		,@ToProjectKey int 
		,@ToTaskKey int
		,@CheckBillingDetail int = 1 -- Set to 0 to allow for transfers between billing worksheets 
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 08/10/07 GHL 8.5   Creation for new voucher transfer requirements
  ||                    After moving vouchers, we must unpost and repost vouchers
  ||                    we must reverse wip entries  
  || 08/17/07 GHL 8.5   Using now spGLUnPostVoucher to unpost voucher (Cleared flag is checked)
  || 11/20/07 GHL 8.5   Added Overhead to temp
  || 12/17/07 GHL 8.5   Added check of prebilled orders
  || 03/24/08 GHL 8.506 (23206) Added better error returns, users complained that errors not specific enough
  || 04/01/08 GHL 8.507 (23951) When transferring a voucher associated to a expense receipt, move it too
  || 04/17/08 GHL 8.508 Made transfer message more explicit  
  || 07/17/08 GHL 8.516 (30265) When transferring to a new project, reset the client on the voucher line 
  ||                    Also checking posting status before unposting/posting
  || 03/24/09 GHL 10.021 (49682) Added TempTranLineKey to #tTransaction. This is used by cash basis
  || 11/16/09 GHL 10.513 (68471) When creating the new transaction, use OfficeKey/ClassKey from new project
  || 11/17/09 GHL 10.513 (68471) Also error out if the projects have a different GLCompanyKey  
  || 07/03/12 GHL 10.557  Added tTransaction.ICTGLCompanyKey  
  || 08/05/13 GHL 10.571 Added Multi Currency stuff
  || 09/26/13 WDF 10.573 (188654) Added UserKey
  */  

	SET NOCOUNT ON

	/* Assume done

	CREATE TABLE #tTransfer
		(
		VoucherDetailKey INT null
		,VoucherKey INT NULL
		,Status INT NULL
		,InvoiceLineKey INT NULL
		,WriteOff INT NULL
		,WIPPostingInKey INT NULL
		,WIPPostingOutKey INT NULL
		,OrigTransferComment VARCHAR(500) NULL
		,OrigProjectKey INT NULL
		,OrigProjectNumber varchar(50) NULL
		,OrigTaskID varchar(50) NULL
		,NewTransferComment VARCHAR(500) NULL
		,ClientKey INT NULL
		,ErrorNum INT NULL)

	*/


Declare @ExpenseActive int
Declare @WIPPostingInKey int
Declare @WIPPostingOutKey int
Declare @VoucherKey int 
Declare @VoucherDetailKey int 
Declare @OrigProjectKey int 
Declare @Posted int
Declare @Ret int

-- Register all constants
DECLARE @kErrInvalidGLCompany INT				SELECT @kErrInvalidGLCompany =  -90 
DECLARE @kErrInvalidExpInactive INT				SELECT @kErrInvalidExpInactive = -101 
DECLARE @kErrInvalidWritenOff INT				SELECT @kErrInvalidWritenOff = -7
DECLARE @kErrInvalidBilled INT					SELECT @kErrInvalidBilled = -8
DECLARE @kErrInvalidMarkBilled INT				SELECT @kErrInvalidMarkBilled = -13
DECLARE @kErrInvalidPOPreBilled INT				SELECT @kErrInvalidPOPreBilled = -14
DECLARE @kErrInvalidOnBillingWS INT				SELECT @kErrInvalidOnBillingWS = -999
DECLARE @kErrVoucherDetail INT					SELECT @kErrVoucherDetail = -1000 
DECLARE @kErrUnpostVoucher INT					SELECT @kErrUnpostVoucher = -1100

DECLARE @kErrPostVoucher INT					SELECT @kErrPostVoucher = -1200
DECLARE @kErrPostVoucherAccts INT				SELECT @kErrPostVoucherAccts = -1201
DECLARE @kErrPostVoucherBalance INT				SELECT @kErrPostVoucherBalance = -1202
DECLARE @kErrPostVoucherMissComp INT			SELECT @kErrPostVoucherMissComp = -1203
DECLARE @kErrPostVoucherMissOffice INT			SELECT @kErrPostVoucherMissOffice = -1204
DECLARE @kErrPostVoucherMissDept INT			SELECT @kErrPostVoucherMissDept = -1205
DECLARE @kErrPostVoucherMissClass INT			SELECT @kErrPostVoucherMissClass = -1206

DECLARE @kErrWIPAdjustment INT					SELECT @kErrWIPAdjustment = -1300
 
Declare @NewProjectNumber as varchar(100)
Declare @NewTaskID as varchar(100)
Declare @ToGLCompanyKey int
Declare @ToOfficeKey int
Declare @ToClassKey int
Declare @DefaultClassKey int
Declare @Initiator varchar(201)

    select @Initiator = FirstName + ' ' + LastName from tUser (nolock) where UserKey = @UserKey

	Select @NewProjectNumber = ProjectNumber, @ToGLCompanyKey = GLCompanyKey, @ToOfficeKey = OfficeKey, @ToClassKey = ClassKey 
	from tProject (nolock) Where ProjectKey = @ToProjectKey

	if @ToOfficeKey = 0 select @ToOfficeKey = null
	if @ToClassKey = 0 select @ToClassKey = null
	
	Select @NewTaskID = TaskID from tTask (nolock) Where TaskKey = @ToTaskKey
	
	Select @ExpenseActive = isnull(ps.ExpenseActive, 1) 
	From   tProject p (nolock)
		left join tProjectStatus ps (nolock) on ps.ProjectStatusKey = p.ProjectStatusKey
	Where  p.ProjectKey = @ToProjectKey

	if @ExpenseActive = 0
	BEGIN
		UPDATE #tTransfer
		SET	   #tTransfer.ErrorNum = @kErrInvalidExpInactive	
		return @kErrInvalidExpInactive 
	END
	
	UPDATE #tTransfer
	SET	   #tTransfer.ErrorNum = 1 -- success	

	-- Try to find appropriate client on the lines
	Declare @UseGLCompany int, @IOClientLink int, @BCClientLink int, @LineItemKey int, @LineClientKey int,  @PurchaseOrderDetailKey int
	Select
		@UseGLCompany = ISNULL(UseGLCompany, 0)
		,@IOClientLink = ISNULL(IOClientLink, 1)
		,@BCClientLink = ISNULL(BCClientLink, 1)
		,@DefaultClassKey = DefaultClassKey
	From
		tPreference (nolock)
	Where
		CompanyKey = @CompanyKey
		 
	If isnull(@ToClassKey, 0) = 0
		select @ToClassKey, @DefaultClassKey
		 
	if @ToClassKey = 0 select @ToClassKey = null
	 
	Select @VoucherDetailKey = -1
	While 1=1
	BEGIN
		Select @VoucherDetailKey = Min(VoucherDetailKey) 
		from #tTransfer (nolock) 
		Where VoucherDetailKey > @VoucherDetailKey
		
		if @VoucherDetailKey is null
			break
			
		Select @LineItemKey = ItemKey, @PurchaseOrderDetailKey = ISNULL(PurchaseOrderDetailKey, 0)	
		From tVoucherDetail (nolock)
		Where VoucherDetailKey = @VoucherDetailKey
			 	
		select @LineClientKey = null
			 	
		EXEC sptVoucherDetailFindClient @ToProjectKey, @LineItemKey, @PurchaseOrderDetailKey, @IOClientLink ,@BCClientLink 
			,@LineClientKey output	

		Update #tTransfer Set ClientKey = @LineClientKey Where VoucherDetailKey = @VoucherDetailKey 
	end
            
	UPDATE #tTransfer
	SET    #tTransfer.VoucherKey = vd.VoucherKey
		  ,#tTransfer.Status = v.Status
		  ,#tTransfer.WriteOff = vd.WriteOff
		  ,#tTransfer.InvoiceLineKey = vd.InvoiceLineKey
		  ,#tTransfer.WIPPostingInKey = ISNULL(vd.WIPPostingInKey, 0)
		  ,#tTransfer.WIPPostingOutKey = ISNULL(vd.WIPPostingOutKey, 0)
		  ,#tTransfer.OrigTransferComment = ISNULL(vd.TransferComment, '')
		  ,#tTransfer.OrigProjectKey =  vd.ProjectKey
		  ,#tTransfer.OrigProjectNumber =  p.ProjectNumber
		  ,#tTransfer.OrigTaskID =  t.TaskID
	FROM   tVoucherDetail vd (NOLOCK)
		INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = vd.VoucherKey
		LEFT OUTER JOIN tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tTask t (NOLOCK) ON vd.TaskKey = t.TaskKey
		LEFT OUTER JOIN tItem i (NOLOCK) ON vd.ItemKey = i.ItemKey
	WHERE  #tTransfer.VoucherDetailKey = vd.VoucherDetailKey   
	
	If @CheckBillingDetail = 1
		UPDATE #tTransfer
		SET	   #tTransfer.ErrorNum = @kErrInvalidOnBillingWS
		FROM   tBillingDetail bd (nolock)
			INNER JOIN tBilling b (NOLOCK) ON b.BillingKey = bd.BillingKey
		WHERE  #tTransfer.VoucherDetailKey = bd.EntityKey
		AND    bd.Entity = 'tVoucherDetail'
		AND    b.Status < 5	

	-- error if we have different GLCompanies
	IF @UseGLCompany = 1
	UPDATE #tTransfer
	SET	   #tTransfer.ErrorNum = @kErrInvalidGLCompany
	FROM   tVoucher v (NOLOCK)
	WHERE  #tTransfer.VoucherKey = v.VoucherKey
	AND    isnull(v.GLCompanyKey, 0) <> @ToGLCompanyKey 


	UPDATE #tTransfer
	SET	   ErrorNum = @kErrInvalidWritenOff 
	WHERE  Status = 4 and WriteOff = 1

	UPDATE #tTransfer
	SET	   ErrorNum = @kErrInvalidBilled 
	WHERE  Status = 4 and InvoiceLineKey > 0

	UPDATE #tTransfer
	SET	   ErrorNum = @kErrInvalidMarkBilled 
	WHERE  Status = 4 and InvoiceLineKey = 0 and WIPPostingOutKey > 0

	UPDATE #tTransfer
	SET	   #tTransfer.ErrorNum = @kErrInvalidPOPreBilled
	FROM   tVoucherDetail vd (nolock)
		   ,tPurchaseOrderDetail pod (NOLOCK) 
	WHERE  #tTransfer.VoucherDetailKey = vd.VoucherDetailKey
	AND    vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	AND    pod.InvoiceLineKey > 0 

	UPDATE #tTransfer
	SET    NewTransferComment = @Initiator + ': From Project ' + ISNULL(OrigProjectNumber, 'NONE') 
							  + ' and Task ' + ISNULL(OrigTaskID, 'NONE')
							  + ' To Project ' + ISNULL(@NewProjectNumber, 'NONE') 
							  + ' and Task ' + ISNULL(@NewTaskID, 'NONE')
	UPDATE #tTransfer
	SET    NewTransferComment = NewTransferComment + '<br>' + left(OrigTransferComment, 500 - Len(NewTransferComment))

	-- we can use this for spGLPostVoucher so that it is not created in a sql tran, that would lock tempdb 
	CREATE TABLE #tTransaction (
			-- Copied from tTransaction
			CompanyKey int NULL ,
			DateCreated smalldatetime NULL ,
			TransactionDate smalldatetime NULL ,
			Entity varchar (50) NULL ,
			EntityKey int NULL ,
			Reference varchar (100) NULL ,
			GLAccountKey int NULL ,
			Debit money NULL ,
			Credit money NULL ,
			ClassKey int NULL ,
			Memo varchar (500) NULL ,
			PostMonth int NULL,
			PostYear int NULL,
			PostSide char (1) NULL ,
			ClientKey int NULL ,
			ProjectKey int NULL ,
			SourceCompanyKey int NULL ,
			DepositKey int NULL ,
			GLCompanyKey int NULL ,
			OfficeKey int NULL ,
			DepartmentKey int NULL ,
			DetailLineKey int NULL ,
			Section int NULL, 
			Overhead tinyint NULL,
			ICTGLCompanyKey int null, 

			CurrencyID varchar(10) null,	-- 4 lines added for multicurrency
			ExchangeRate decimal(24,7) null,
			HDebit money null,
			HCredit money null

			-- our work space
			,GLValid int null
			,GLAccountErrRet int null
			,GPFlag int null -- General purpose flag
			
			,TempTranLineKey int IDENTITY(1,1) NOT NULL
			)	 

	SELECT @VoucherKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @VoucherKey = MIN(VoucherKey)
		FROM   #tTransfer
		WHERE  VoucherKey > @VoucherKey 		
		AND    ErrorNum = 1

		IF @VoucherKey IS NULL
			BREAK

		SELECT @Posted = Posted
		FROM   tVoucher (NOLOCK)
		WHERE  VoucherKey = @VoucherKey
		
		BEGIN TRAN

		Update tVoucherDetail
		Set    tVoucherDetail.TransferComment = #tTransfer.NewTransferComment
		      ,tVoucherDetail.ProjectKey = @ToProjectKey
		      ,tVoucherDetail.TaskKey = @ToTaskKey
		      ,tVoucherDetail.OfficeKey = @ToOfficeKey
		      ,tVoucherDetail.ClassKey = @ToClassKey
			  ,tVoucherDetail.DateBilled = CASE 
				WHEN #tTransfer.InvoiceLineKey = 0 AND #tTransfer.WIPPostingOutKey = 0 THEN NULL
				ELSE tVoucherDetail.DateBilled END 
			  ,tVoucherDetail.InvoiceLineKey = CASE 
				WHEN #tTransfer.InvoiceLineKey = 0 AND #tTransfer.WIPPostingOutKey = 0 THEN NULL
				ELSE tVoucherDetail.InvoiceLineKey END
			  ,tVoucherDetail.WriteOff = CASE 
				WHEN #tTransfer.InvoiceLineKey = 0 AND #tTransfer.WIPPostingOutKey = 0 THEN 0
				ELSE tVoucherDetail.WriteOff END
			  ,tVoucherDetail.ClientKey = #tTransfer.ClientKey	
		From  #tTransfer
		Where #tTransfer.VoucherDetailKey = tVoucherDetail.VoucherDetailKey	
		And   #tTransfer.VoucherKey = @VoucherKey
		And   #tTransfer.ErrorNum = 1

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			UPDATE #tTransfer SET ErrorNum = @kErrVoucherDetail  WHERE VoucherKey = @VoucherKey
			RETURN @kErrVoucherDetail 
		END

		-- move the associated expense receipts
		UPDATE tExpenseReceipt
		SET	   tExpenseReceipt.TransferComment = #tTransfer.NewTransferComment
		      ,tExpenseReceipt.ProjectKey = @ToProjectKey
		      ,tExpenseReceipt.TaskKey = @ToTaskKey	
		From  #tTransfer
		Where #tTransfer.VoucherDetailKey = tExpenseReceipt.VoucherDetailKey	
		And   #tTransfer.VoucherKey = @VoucherKey
		And   #tTransfer.ErrorNum = 1
 
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			UPDATE #tTransfer SET ErrorNum = @kErrVoucherDetail  WHERE VoucherKey = @VoucherKey
			RETURN @kErrVoucherDetail 
		END
		
		IF @Posted = 1
		BEGIN		
			-- we should be able to use nested sql transactions	
			-- do not check closed date
			EXEC @Ret = spGLUnPostVoucher @VoucherKey, 0

			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN
				UPDATE #tTransfer SET ErrorNum = @kErrUnpostVoucher  WHERE VoucherKey = @VoucherKey
				RETURN @kErrUnpostVoucher
			END

			IF @Ret <> 1
			BEGIN
				ROLLBACK TRAN
				UPDATE #tTransfer SET ErrorNum = @kErrUnpostVoucher WHERE VoucherKey = @VoucherKey
				RETURN @kErrUnpostVoucher
			END
			TRUNCATE TABLE #tTransaction

			-- we should be able to use nested sql transactions	
			-- No preposting, do not create temp, do not check closed date
			EXEC @Ret = spGLPostVoucher @CompanyKey, @VoucherKey, 0, 0, 0

			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN
				UPDATE #tTransfer SET ErrorNum = @kErrPostVoucher  WHERE VoucherKey = @VoucherKey
				RETURN @kErrPostVoucher
			END

			IF @Ret <> 1
			BEGIN
				IF (@Ret < 0 AND @Ret > -20)
				BEGIN
					-- Bad accounts
					ROLLBACK TRAN
					UPDATE #tTransfer SET ErrorNum = @kErrPostVoucherAccts  WHERE VoucherKey = @VoucherKey
					RETURN @kErrPostVoucherAccts			
				END

				IF (@Ret = -1000)
				BEGIN
					-- Unexpected
					ROLLBACK TRAN
					UPDATE #tTransfer SET ErrorNum = @kErrPostVoucher  WHERE VoucherKey = @VoucherKey
					RETURN @kErrPostVoucher			
				END

				IF (@Ret = -102)
				BEGIN
					-- Bad balance
					ROLLBACK TRAN
					UPDATE #tTransfer SET ErrorNum = @kErrPostVoucherBalance  WHERE VoucherKey = @VoucherKey
					RETURN @kErrPostVoucherBalance			
				END
				
				IF (@Ret = -200)
				BEGIN
					-- Company missing
					ROLLBACK TRAN
					UPDATE #tTransfer SET ErrorNum = @kErrPostVoucherMissComp  WHERE VoucherKey = @VoucherKey
					RETURN @kErrPostVoucherMissComp			
				END
				
				IF (@Ret = -201)
				BEGIN
					-- Office missing
					ROLLBACK TRAN
					UPDATE #tTransfer SET ErrorNum = @kErrPostVoucherMissOffice  WHERE VoucherKey = @VoucherKey
					RETURN @kErrPostVoucherMissOffice			
				END
				
				IF (@Ret = -202)
				BEGIN
					-- Department missing
					ROLLBACK TRAN
					UPDATE #tTransfer SET ErrorNum = @kErrPostVoucherMissDept  WHERE VoucherKey = @VoucherKey
					RETURN @kErrPostVoucherMissDept			
				END
				
				IF (@Ret = -203)
				BEGIN
					-- Class missing
					ROLLBACK TRAN
					UPDATE #tTransfer SET ErrorNum = @kErrPostVoucherMissClass  WHERE VoucherKey = @VoucherKey
					RETURN @kErrPostVoucherMissClass			
				END

				ROLLBACK TRAN
				UPDATE #tTransfer SET ErrorNum = @kErrPostVoucher  WHERE VoucherKey = @VoucherKey
				RETURN @kErrPostVoucher			
				
			END -- Err <> 0

		END -- @Posted = 1
		
		-- Now reverse the wip entry if WIPPostingInKey > 0 and WIPPostingOutKey = 0
		SELECT @VoucherDetailKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @VoucherDetailKey = MIN(VoucherDetailKey)
			FROM #tTransfer
			WHERE  ErrorNum = 1
			AND    VoucherKey = @VoucherKey
			AND    VoucherDetailKey > @VoucherDetailKey
			AND    WIPPostingInKey > 0 and WIPPostingOutKey = 0

			IF @VoucherDetailKey IS NULL
				BREAK

			SELECT @OrigProjectKey = OrigProjectKey FROM #tTransfer WHERE VoucherDetailKey = @VoucherDetailKey
			 
			EXEC @Ret = spGLPostWIPAdjustment 'tVoucherDetail', @VoucherDetailKey, NULL, @OrigProjectKey, @ToProjectKey

			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN
				UPDATE #tTransfer SET ErrorNum = @kErrWIPAdjustment  WHERE VoucherKey = @VoucherKey
				RETURN @kErrWIPAdjustment
			END

			IF @Ret <> 1
			BEGIN
				ROLLBACK TRAN
				UPDATE #tTransfer SET ErrorNum = @kErrWIPAdjustment  WHERE VoucherKey = @VoucherKey
				RETURN @kErrWIPAdjustment
			END

		END -- VoucherDetail loop

		-- commit the sql transaction for this voucher			
		COMMIT TRAN

	END -- Voucher loop

	-- Report non fatal errors for UI
	DECLARE @ErrorNum int
	SELECT @ErrorNum = ErrorNum FROM #tTransfer WHERE ErrorNum <> 1
	RETURN ISNULL(@ErrorNum, 1)
GO
