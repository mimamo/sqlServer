USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDeleteCC]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherDeleteCC]
	@VoucherKey int

AS --Encrypt
  /*
  || When     Who Rel   What
  || 02/15/07 GHL 8.4   Added project rollup section
  || 11/6/07  CRG 8.5   Now checking the Expense Receipts to see if the lines are linked to any other vouchers.
  ||                    If so, it will set the VoucherKey to the MIN VoucherKey that they're linked to.
  || 09/24/09 GHL 10.5  Added deletion of tVoucherTax
  || 03/01/10 GHL 10.519  Added deletion of tRecurTran
  || 08/22/11 GHL 10.457  Preventing deletion if tVoucherCC exists
  || 10/13/11 GHL 10.459 Added new entity CREDITCARD
  || 10/26/11 GHL 10.459 Cloned sptVoucherDelete for credit cards
  ||                     Added deletion of tVoucherCC and tVoucherCCDetail
  || 03/15/12 GHL 10.554 Added nulling of voucher key in CCEntry
  || 07/31/15 WDF 10.582 (215641) Remove delete of tActionLog Voucher records
  */

	declare @CCEntryKey int

	select @CCEntryKey = CCEntryKey from tVoucher (nolock) WHERE VoucherKey = @VoucherKey
	IF @@ROWCOUNT = 0
		Return 1

	IF EXISTS(SELECT 1 FROM tVoucher (NOLOCK) WHERE VoucherKey = @VoucherKey and Posted = 1)
		Return -1
	IF EXISTS(SELECT 1 FROM tPaymentDetail (NOLOCK) WHERE VoucherKey = @VoucherKey)
		Return -2
	IF EXISTS(SELECT 1 FROM tVoucherCredit (NOLOCK) WHERE VoucherKey = @VoucherKey)
		Return -2
	IF EXISTS(SELECT 1 FROM tVoucherCredit (NOLOCK) WHERE CreditVoucherKey = @VoucherKey)
		Return -2
	

 CREATE TABLE #ProjectRollup (ProjectKey INT NULL)
 
 INSERT #ProjectRollup (ProjectKey)
 SELECT DISTINCT ProjectKey
 FROM   tVoucherDetail (NOLOCK)
 WHERE  VoucherKey = @VoucherKey
 AND    ProjectKey IS NOT NULL
 		
-- Need to relieve applied cost on all pos  check other transactions
begin transaction

Declare @CurKey int
Declare @RetVal int
Declare @ProjectRollup int

Select @ProjectRollup = 0 -- Do not recalc rollup when deleting voucher details since we recalc at the end

Select @CurKey = -1
While 1 = 1
BEGIN

	if @CurKey is null
		break
	Select @CurKey = Min(VoucherDetailKey) from tVoucherDetail (NOLOCK) Where VoucherKey = @VoucherKey and VoucherDetailKey > @CurKey
	Exec @RetVal = sptVoucherDetailDeleteCC @CurKey, @ProjectRollup
	if ISNULL(@RetVal , 0) < 0
	BEGIN
		Rollback Transaction
		Return -3
	end

END

Select @CurKey = -1
While 1 = 1
BEGIN

	if @CurKey is null
		break
	Select @CurKey = Min(VoucherKey) from tVoucherCC (NOLOCK) Where VoucherCCKey = @VoucherKey and VoucherKey > @CurKey
	Exec @RetVal = sptVoucherCCDelete @VoucherKey, @CurKey
	if ISNULL(@RetVal , 0) <= 0
	BEGIN
		Rollback Transaction
		Return -3
	end

END

Declare @RecurringParentKey int

Select @RecurringParentKey = RecurringParentKey 
 from tVoucher (NOLOCK) Where VoucherKey = @VoucherKey

--Clear out this VoucherKey, and set it to the minimum remaining VoucherKey on the Expense Receipt, or set it to 0 if it's not linked to any other vouchers.
DECLARE @ExpenseEnvelopeKey int

SELECT	@ExpenseEnvelopeKey = ExpenseEnvelopeKey
FROM	tExpenseEnvelope (nolock)
WHERE	VoucherKey = @VoucherKey

IF @ExpenseEnvelopeKey IS NOT NULL
BEGIN
	DECLARE	@NewVoucherKey int,
			@VoucherDetailKey int
	
	SELECT	@VoucherDetailKey = MIN(VoucherDetailKey)
	FROM	tExpenseReceipt (nolock)
	WHERE	ExpenseEnvelopeKey = @ExpenseEnvelopeKey
	
	IF @VoucherDetailKey IS NOT NULL
		SELECT	@NewVoucherKey = MIN(VoucherKey)
		FROM	tVoucherDetail (nolock)
		WHERE	VoucherDetailKey = @VoucherDetailKey
	
	IF @NewVoucherKey IS NULL	
		UPDATE	tExpenseEnvelope
		SET		Paid = 0, 
				VoucherKey = 0
		WHERE	ExpenseEnvelopeKey = @ExpenseEnvelopeKey
	ELSE
		UPDATE	tExpenseEnvelope
		SET		VoucherKey = @NewVoucherKey
		WHERE	ExpenseEnvelopeKey = @ExpenseEnvelopeKey
END

Delete tRecurTran Where Entity in ('VOUCHER', 'CREDITCARD') and EntityKey = @VoucherKey

DELETE
FROM tVoucherTax
WHERE
	VoucherKey = @VoucherKey 

DELETE
FROM tVoucher
WHERE
	VoucherKey = @VoucherKey 

if @RecurringParentKey <> 0 and @RecurringParentKey <> @VoucherKey
	if not exists(Select 1 from tVoucher (NOLOCK) Where RecurringParentKey = @RecurringParentKey and VoucherKey <> @RecurringParentKey)
		Update tVoucher
		Set RecurringParentKey = 0 
		Where VoucherKey = @RecurringParentKey
		
if isnull(@CCEntryKey,0) > 0
update tCCEntry
set    CCVoucherKey = null
where  CCEntryKey = @CCEntryKey

commit transaction

 DECLARE @ProjectKey INT
 SELECT @ProjectKey = -1
 WHILE (1=1)
 BEGIN
	SELECT @ProjectKey = MIN(ProjectKey)
	FROM   #ProjectRollup
	WHERE  ProjectKey > @ProjectKey
	
	IF @ProjectKey IS NULL
		BREAK
		
	-- Rollup project, TranType = Voucher or 4	
	EXEC sptProjectRollupUpdate @ProjectKey, 4, 1, 1, 1, 1
 END

RETURN 1
GO
