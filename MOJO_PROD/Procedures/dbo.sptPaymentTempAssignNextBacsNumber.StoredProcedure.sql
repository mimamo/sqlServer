USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentTempAssignNextBacsNumber]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentTempAssignNextBacsNumber] 
	(
	@CompanyKey int
	,@CashAccountKey int
	,@Temporary int -- 1 update temporary numbers, 0 update final numbers
	,@PostPayment int = 0
	)
AS --Encrypt
BEGIN
	
/*
|| When     Who Rel    What
|| 03/17/15 GHL 10.590 (241695) Created for payment by Bacs files (enhancement for Spark44)
||                     The purpose of the SP is to update CheckNumberTemp and CheckNumber
||                     with a Bacs Number so that we do not send the payments twice
||                     At this time, I did not check for uniqueness of these #s   
*/

	SET NOCOUNT ON

  /*
  Assume done in vb
  create table #bacs(PaymentKey int null)
  */

  
	declare @BacsID int

	if @Temporary = 1
	begin	
		-- Update the temporary numbers

		select @BacsID = BacsID from tGLAccount (nolock) where GLAccountKey = @CashAccountKey

		select @BacsID = isnull(@BacsID, 0) 

		update tPayment
		set    @BacsID = @BacsID + 1 -- seems to be executed first
			  ,CheckNumberTemp = @BacsID
		from   #bacs b
 		where  tPayment.PaymentKey = b.PaymentKey
		and    tPayment.CashAccountKey = @CashAccountKey 
	end
		
	else

	begin
		-- Update the real numbers

		select @BacsID = max(cast(CheckNumberTemp as Int))
		from tPayment (nolock)
		inner join #bacs b on tPayment.PaymentKey = b.PaymentKey

		declare @CurrentBacsID int

		select @CurrentBacsID = BacsID from tGLAccount (nolock) where GLAccountKey = @CashAccountKey

		if @CurrentBacsID > @BacsID
			select @BacsID = @CurrentBacsID

		update tGLAccount
		set    BacsID = @BacsID 
		where  GLAccountKey = @CashAccountKey 

		update tPayment set CheckNumber = 'Bacs-' + CheckNumberTemp
		where PaymentKey in (select PaymentKey from #bacs)
		and    tPayment.CashAccountKey = @CashAccountKey

		declare @PaymentKey int

		if @PostPayment = 1
		begin
			select @PaymentKey = -1
			while (1=1)
			begin
				select @PaymentKey = min(PaymentKey)
				from #bacs
				where PaymentKey > @PaymentKey

				if @PaymentKey is null
					break

				EXEC spGLPostPayment @CompanyKey, @PaymentKey
			end
		end

	end


END
GO
