USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseEnvelopeUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExpenseEnvelopeUpdate]
 @UserKey int,
 @CompanyKey int,
 @ExpenseEnvelopeKey int,
 @EnvelopeNumber varchar(100),
 @StartDate smalldatetime,
 @EndDate smalldatetime,
 @Comments varchar(4000),
 @VendorKey int,
 @SalesTaxKey int,
 @SalesTax2Key int,
 @SalesTax1Amount money,
 @SalesTax2Amount money,
 @SalesTaxAmount money,
 @CurrencyID varchar(10),
 @ExchangeRate decimal(24,7),
 @NextTranNo varchar(100) OUTPUT,
 @oIdentity INT OUTPUT
AS --Encrypt

/*
|| When			Who Rel			What
|| 8/23/07		CRG 8.5			(9833) Added VendorKey.
|| 2/09/11		RLB 10.542		(100772) Added Sales Tax Fields
|| 10/30/12		RLB 105.6.1		Changed EnvelopeNumber to a 100 chars up from 30
|| 11/26/13		GHL 10.574		Added currency info. make sure exchange rate >0 
|| 06/09/14		MAS 15.5.8.1	Combined sptExpenseEnvelopeInsert & sptExpenseEnvelopeUpdate for Platinum
*/

IF ISNULL(@ExpenseEnvelopeKey, 0) > 0
	BEGIN
		if exists(Select 1 from tExpenseEnvelope (nolock) Where CompanyKey = @CompanyKey and EnvelopeNumber = @EnvelopeNumber and ExpenseEnvelopeKey <> @ExpenseEnvelopeKey)
			return -1

		if isnull(@ExchangeRate,0) <= 0
			select @ExchangeRate = 1		
				
		 UPDATE
		  tExpenseEnvelope
		 SET
		  EnvelopeNumber = @EnvelopeNumber,
		  StartDate = @StartDate,
		  EndDate = @EndDate,
		  Comments = @Comments,
		  VendorKey = @VendorKey,
		  SalesTaxKey = @SalesTaxKey,
		  SalesTax2Key = @SalesTax2Key,
		  SalesTax1Amount = @SalesTax1Amount,
		  SalesTax2Amount = @SalesTax2Amount,
		  SalesTaxAmount = @SalesTaxAmount,
		  CurrencyID = @CurrencyID,
		  ExchangeRate = @ExchangeRate
		 WHERE
		  ExpenseEnvelopeKey = @ExpenseEnvelopeKey 
		  
		   SELECT @oIdentity = @ExpenseEnvelopeKey
		 RETURN 1
	END	 
ELSE
BEGIN
	IF EXISTS(SELECT * FROM tExpenseEnvelope (nolock)WHERE CompanyKey = @CompanyKey AND EnvelopeNumber = @EnvelopeNumber)
	 BEGIN
	  SELECT @oIdentity = 0
	  RETURN 0
	 END
	 
	DECLARE @RetVal	INTEGER
					
	 -- Get the next number
	 IF @EnvelopeNumber IS NULL OR @EnvelopeNumber = ''
	 BEGIN
			EXEC spGetNextTranNo
				@CompanyKey,
				'Expense',		-- TranType
				@RetVal		    OUTPUT,
				@NextTranNo 	OUTPUT
		
			IF @RetVal <> 1
				RETURN -1
		END
		ELSE
			SELECT @NextTranNo = @EnvelopeNumber

	if isnull(@ExchangeRate,0) <= 0
		select @ExchangeRate = 1

	 INSERT tExpenseEnvelope
	  (
	  UserKey,
	  CompanyKey,
	  EnvelopeNumber,
	  StartDate,
	  EndDate,
	  Comments,
	  Status,
	  DateCreated,
	  DateSubmitted,
	  DateApproved,
	  ApprovalComments,
	  VendorKey,
	  SalesTaxKey,
	  SalesTax2Key,
	  SalesTax1Amount,
	  SalesTax2Amount,
	  SalesTaxAmount,
	  CurrencyID,
	  ExchangeRate
	  )
	 VALUES
	  (
	  @UserKey,
	  @CompanyKey,
	  RTRIM(@NextTranNo),
	  @StartDate,
	  @EndDate,
	  @Comments,
	  1, --@Status,
	  GETDATE(),  --@DateCreated,
	  null, -- @DateSubmitted,
	  null, --@DateApproved,
	  null, --@ApprovalComments
	  @VendorKey,
	  @SalesTaxKey,
	  @SalesTax2Key,
	  @SalesTax1Amount,
	  @SalesTax2Amount,
	  @SalesTaxAmount,
	  @CurrencyID,
	  @ExchangeRate
	  )
	 
	 SELECT @oIdentity = @@IDENTITY
	 RETURN 1
END
GO
