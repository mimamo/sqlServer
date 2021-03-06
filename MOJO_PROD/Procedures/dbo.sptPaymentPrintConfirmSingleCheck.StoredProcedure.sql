USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentPrintConfirmSingleCheck]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentPrintConfirmSingleCheck]
	@PaymentKey int,
	@PostPayment tinyint,
	@oCheckNumberTemp BigInt output

AS --Encrypt

/*
|| When     Who Rel     What
|| 5/17/12  MFT 10.556  Created
|| 06/20/13 RLB 10.570  (181155) Update the NextCheckNumber to track multi page checks
|| 12/26/13 GHL 10.576  (200432) CheckNumberTemp (BigInt) cannot be returned as stored proc return
||                       Keep BigInt and return as output parameter
*/

DECLARE
	@CashAccountKey int,
	@CheckNumberTemp varchar(50),
	@NextCheckNumber varchar(50),
	@CompanyKey int

SELECT
	@CashAccountKey = CashAccountKey,
	@CheckNumberTemp = CheckNumberTemp,
	@CompanyKey = CompanyKey,
	@NextCheckNumber = NextCheckNumber
FROM
	tPayment (nolock)
WHERE
	PaymentKey = @PaymentKey

IF ISNULL(@CheckNumberTemp, 0) = cast (0 as BigInt)
	--No CheckNumberTemp has been set
	begin
		select @oCheckNumberTemp = -1
		RETURN 
	end

IF EXISTS(SELECT * FROM tPayment (nolock) WHERE CheckNumber = @CheckNumberTemp AND CashAccountKey = @CashAccountKey AND PaymentKey != @PaymentKey)
	--Duplicate Check Number
	begin
		select @oCheckNumberTemp = -2
		RETURN 
	end

IF ISNULL(@NextCheckNumber, 0) = cast (0 as BigInt)
	SELECT @NextCheckNumber = @CheckNumberTemp

BEGIN TRAN
	UPDATE
		tPayment
	SET
		CheckNumber = CheckNumberTemp
	WHERE
		PaymentKey = @PaymentKey
	
	IF ISNULL(@PostPayment, 0) = 1
		BEGIN
			DECLARE @RetVal int SELECT @RetVal = -9999
			EXEC @RetVal = spGLPostPayment @CompanyKey, @PaymentKey
			
			IF @@ERROR <> 0 OR @RetVal < 0
				BEGIN
					ROLLBACK TRAN
					--PostPayment error
					select @oCheckNumberTemp = -3
					RETURN 
				END
		END
COMMIT TRAN

-- must convert everything to BigInt to be able to compare
-- Also cannot return a BigInt

 -- if there are multiple printed checks get the last check number on the run to set on gl account
--IF cast (@NextCheckNumber as BigInt)  > cast(@CheckNumberTemp as BigInt)
--	SELECT @CheckNumberTemp = @NextCheckNumber
--RETURN @CheckNumberTemp

declare @bigNextCheckNumber as BigInt
declare @bigCheckNumberTemp as BigInt

select @bigNextCheckNumber = cast (@NextCheckNumber as BigInt)
select @bigCheckNumberTemp = cast (@CheckNumberTemp as BigInt)

IF @bigNextCheckNumber  - @bigCheckNumberTemp > 0
	SELECT @CheckNumberTemp = @NextCheckNumber

select @oCheckNumberTemp = @CheckNumberTemp

RETURN
GO
