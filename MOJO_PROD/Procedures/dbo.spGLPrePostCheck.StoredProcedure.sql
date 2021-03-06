USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPrePostCheck]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPrePostCheck]

	(
		@CompanyKey int,
		@CheckKey int
	)

AS --Encrypt

Declare @CurKey int
Declare @RetVal int
Declare @HeaderType char(1)
Declare @DetailType char(1)

Declare @ClientKey int
Declare @CheckAmount money
Declare @CheckDate smalldatetime
Declare @ReferenceNumber varchar(100)
Declare @CashAccountKey int
Declare @AppliedAmount money
Declare @CheckType smallint
Declare @CheckID varchar(20)
Declare @SalesAccountKey int
Declare @ClassKey int
Declare @Description varchar(500)
Declare @Amount money
Declare @Memo varchar(500)
Declare @PrepayAccountKey int
Declare @PrepayAmount money
Declare @DepositKey int

Select
	 @ClientKey = ClientKey
	,@CheckAmount = ISNULL(CheckAmount, 0)
	,@CheckDate = PostingDate
	,@ReferenceNumber = ReferenceNumber
	,@CashAccountKey = CashAccountKey
	,@PrepayAccountKey = PrepayAccountKey
	,@ClassKey = ClassKey
	,@DepositKey = DepositKey
from tCheck (nolock)
Where CheckKey = @CheckKey

Select @HeaderType = 'D', @DetailType = 'C', @CheckID = 'Check # '
select @Memo = @CheckID + @ReferenceNumber


-- Post the header
exec spGLPrePostInsertTran @CompanyKey, @HeaderType, @CheckDate, 'RECEIPT', @CheckKey, @ReferenceNumber, @CashAccountKey, @CheckAmount, @ClassKey, @Memo, NULL, @ClientKey

-- Check that the whole check amount has been applied, if not make sure we have a prepay account key if going to the gl
Select @AppliedAmount = ISNULL(sum(Amount), 0) from tCheckAppl (nolock) where CheckKey = @CheckKey and Prepay = 0
Select @PrepayAmount = @CheckAmount - @AppliedAmount

-- Insert the prepay amoun if there is one
if ISNULL(@PrepayAmount, 0) <> 0
	exec spGLPrePostInsertTran @CompanyKey, @DetailType, @CheckDate, 'RECEIPT', @CheckKey, @ReferenceNumber, @PrepayAccountKey, @PrepayAmount, @ClassKey, @Memo, NULL, @ClientKey

Select @CurKey = -1
while 1=1
begin
	Select @CurKey = min(CheckApplKey) from tCheckAppl (nolock) Where CheckKey = @CheckKey and CheckApplKey > @CurKey and Prepay = 0
	if @CurKey is null
		Break

	Select
		@SalesAccountKey = SalesAccountKey
		,@ClassKey = ClassKey
		,@Description = Description
		,@Amount = Amount
	from tCheckAppl (nolock) Where CheckApplKey = @CurKey
		
	exec spGLPrePostInsertTran @CompanyKey, @DetailType, @CheckDate, 'RECEIPT', @CheckKey, @ReferenceNumber, @SalesAccountKey, @Amount, @ClassKey, @Memo, NULL, @ClientKey
end
GO
