USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentTempAssignNextNumber]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentTempAssignNextNumber]

	(
		@CompanyKey int,
		@PaymentKey int,
		@CheckNumber bigint output
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 11/2/06  CRG 8.35  Converted CheckNumber to bigint
*/

Declare @CashAccountKey int

Select @CashAccountKey = CashAccountKey from tPayment (nolock) Where PaymentKey = @PaymentKey

if exists(Select 1 from tPayment (NOLOCK) Where CheckNumber = Cast(@CheckNumber as varchar) and CashAccountKey = @CashAccountKey and CompanyKey = @CompanyKey)
begin
	select @CheckNumber = -1
	return
end
	
	
Update tPayment
Set CheckNumberTemp = @CheckNumber
Where
	PaymentKey = @PaymentKey
GO
