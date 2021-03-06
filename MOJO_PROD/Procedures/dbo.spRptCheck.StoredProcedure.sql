USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptCheck]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptCheck]
	@CheckFormatKey int
AS --Encrypt

/*
|| When      Who Rel     What
|| 12/17/07  CRG 8.5     Modified how the MaxDetail is calulated based on the GridHeight in the Check Format.
|| 01/15/12  GWG 10.552  Modified the increment of the next number to use  Cast(1 as bigint) instead of 1
|| 11/13/12 GHL 10.562  (159263) When paying credit cards, the list of CC Charges is too long
||                      In that case, summarize the data on the stub, 1 line per Credit Card/GLAccount
||                      Modified here the DetailCount
|| 03/05/13 GHL 10.565  (170264) When comparing 2 strings 9999 and 10000, SQL thinks that 10000 is the smallest
||                      Cast to bigint before comparing
|| 06/20/13 RLB 10.570  (181155) Update the NextCheckNumber to track multi page checks
*/

	DECLARE	@MaxDetail int,
			@GridHeight decimal(24, 9)

	DECLARE	@DetailPage int,
			@DetailCount int,
			@PaymentKey int,
			@Current int,
			@CheckNumberTemp varchar(50),
			@NewCheckNumber varchar(50),
			@CashAccountKey int,
			@CompanyKey int,
			@ShowDetail1 tinyint,
			@ShowDetail2 tinyint,
			@CCChargesExist int 
	
	--Remove blank lines from the address before printing
	UPDATE	#tRptCheck
	SET		PayToAddress4 = PayToAddress5,
			PayToAddress5 = NULL
	WHERE	LEN(ISNULL(PayToAddress4,'')) = 0
	
	UPDATE	#tRptCheck
	SET		PayToAddress3 = PayToAddress4,
			PayToAddress4 = NULL
	WHERE	LEN(ISNULL(PayToAddress3,'')) = 0

	UPDATE	#tRptCheck
	SET		PayToAddress2 = PayToAddress3,
			PayToAddress3 = NULL
	WHERE	LEN(ISNULL(PayToAddress2,'')) = 0

	UPDATE	#tRptCheck
	SET		PayToAddress1 = PayToAddress2,
			PayToAddress2 = NULL
	WHERE	LEN(ISNULL(PayToAddress1,'')) = 0

	--Load info from the Check Format
	SELECT	@ShowDetail1 = ShowDetail1,
			@ShowDetail2 = ShowDetail2,
			@GridHeight = GridHeight
	FROM	tCheckFormat (NOLOCK)
	WHERE	CheckFormatKey = @CheckFormatKey

	--Regardless of font size, due to the size of the boxes in the Active Reports design, 
	--we can only fit 5 lines per inch on the detail.
	SELECT	@MaxDetail = CAST((@GridHeight * 5) AS int)
	
	IF ISNULL(@ShowDetail1,0) + ISNULL(@ShowDetail2,0) = 0
		RETURN 1

	--Get the first check number			
	SELECT	@CheckNumberTemp = MIN(cast(OldCheckNumberTemp as bigint))
	FROM	#tRptCheck
	
	--Set the new check number to the first one
	SELECT	@NewCheckNumber = @CheckNumberTemp
	
	--Get the Payment info for use when validating the check number in the loop
	--Since the CompanyKey and CashAccountKey are going to be the same for the whole batch, 
	--we can just get it for the first record.
	SELECT	@CashAccountKey = CashAccountKey,
			@CompanyKey = CompanyKey
	FROM	tPayment (nolock) 
	WHERE	PaymentKey = (SELECT MIN(PaymentKey) FROM #tRptCheck)
	
	--Loop through by check number	
	WHILE (@CheckNumberTemp IS NOT NULL)
	BEGIN
		--Get the PaymentKey
		SELECT	@PaymentKey = PaymentKey
		FROM	#tRptCheck (nolock) 
		WHERE	OldCheckNumberTemp = @CheckNumberTemp

		--Update the check number to the new one and set NextCheckNumber
		UPDATE	tPayment
		SET		CheckNumberTemp = @NewCheckNumber , NextCheckNumber = @NewCheckNumber
		WHERE	PaymentKey = @PaymentKey
		
		--Get the Detail Count
		select @CCChargesExist = 0
		if exists (select 1 
					from tPaymentDetail pd (nolock)
					inner join tVoucher ccc (nolock) on pd.VoucherKey = ccc.VoucherKey
					where pd.PaymentKey = @PaymentKey
					and   isnull(ccc.CreditCard, 0) = 1
				) 
		select @CCChargesExist = 1

		if  @CCChargesExist = 0
			SELECT	@DetailCount = COUNT(*)
			FROM	tPaymentDetail (NOLOCK)
			WHERE	PaymentKey = @PaymentKey
		else
			-- group by GL account
			SELECT	@DetailCount = COUNT(DISTINCT GLAccountKey)
			FROM	tPaymentDetail (NOLOCK)
			WHERE	PaymentKey = @PaymentKey

		--Update the current temp table row
		UPDATE	#tRptCheck
		SET		DetailPage = 1,
				DetailCount = @DetailCount,
				DetailStart = 1,
				DetailEnd = @MaxDetail,
				Processed = 1,
				CheckNumberTemp = @NewCheckNumber
		WHERE	OldCheckNumberTemp = @CheckNumberTemp
	
		--If the detail will go onto more than one page...
		IF @DetailCount > @MaxDetail
		BEGIN
					
			SET	@Current = @MaxDetail + 1
			SET	@DetailPage = 2

			--Loop through the additional pages
			WHILE @Current <= @DetailCount
			BEGIN
				--Increment the new check number
				SELECT	@NewCheckNumber = @NewCheckNumber + Cast(1 as bigint)
				
				--Validate that the number has not been used
				IF EXISTS
						(SELECT 1 
						FROM	tPayment (NOLOCK) 
						WHERE	CheckNumber = @NewCheckNumber 
						AND		CashAccountKey = @CashAccountKey 
						AND		CompanyKey = @CompanyKey)
					RETURN -1
		
				--Insert rows if the detail will go onto another page
				INSERT	#tRptCheck (PaymentKey, CheckNumberTemp, DetailCount, DetailPage, DetailStart, DetailEnd, Processed)
				VALUES	(@PaymentKey, @NewCheckNumber, @DetailCount, @DetailPage, @Current, @Current + @MaxDetail - 1, 1)
				
				SET	@Current = @Current + @MaxDetail
				SET	@DetailPage = @DetailPage + 1

				-- Update payment NextCheckNumber if there a multiple pages
				UPDATE tPayment
				SET NextCheckNumber = @NewCheckNumber
				WHERE PaymentKey = @PaymentKey
			END
		END


		SELECT	@NewCheckNumber = @NewCheckNumber + Cast(1 as bigint)
		
		SELECT	@CheckNumberTemp = MIN(cast (OldCheckNumberTemp as bigint))
		FROM	#tRptCheck
		WHERE	cast(OldCheckNumberTemp as bigint) > cast(@CheckNumberTemp as bigint)
		AND		ISNULL(Processed,0) = 0
	END
GO
