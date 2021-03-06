USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetNextTranNo]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spGetNextTranNo]
(

	@_iCompanyKey		INTEGER,
	@_iTranType		VARCHAR(50),
	@_oRetVal		INTEGER OUTPUT,
	@_oNextTranNo 		VARCHAR(100) OUTPUT
	)
AS --Encrypt
BEGIN

/*
|| When      Who Rel      What
|| 6/25/13   CRG 10.5.6.9 Added TranType for Media Worksheet
|| 1/13/14   CRG 10.5.7.5 Added TranType for Interactive
|| 2/26/14   CRG 10.5.7.7 Added separate TranTypes for different Media Worksheet types rather than one for all Media Worksheets
*/

	DECLARE		@_lNextTranNo		INTEGER			/* local work variable */
	DECLARE 	@_lNextTranNoC	 	CHAR(100)		/* character version of tran number */		
	DECLARE 	@_lNextTranNoPC         CHAR(100)		/* character version of tran number padded with 0's on the left */
	DECLARE 	@_lTempTranNo           VARCHAR(200)

	DECLARE		@NumPrefix 		VARCHAR(10)
				,@NumPlaces		INTEGER
				,@Zeroes		VARCHAR(100)
				,@NumUsed		INTEGER
				,@TwoDigitPrefix tinyint

	/* initialize return value to failure status */
	SELECT	@_oRetVal = 0
	SELECT	@_oNextTranNo = NULL
	SELECT	@Zeroes = '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000'

	/* find next tran number (with lock on row) */
	IF @_iTranType = 'PO'
		SELECT	@_lNextTranNo = ISNULL(NextPONum, 1)
  				,@NumPrefix = ISNULL(PONumPrefix, '')
				,@NumPlaces = ISNULL(PONumPlaces, 6)
		FROM	tPreference
		WHERE	CompanyKey = @_iCompanyKey
	ELSE 
	IF @_iTranType = 'IO'
		SELECT	@_lNextTranNo = ISNULL(NextIONum, 1)
  				,@NumPrefix = ISNULL(IONumPrefix, '')
				,@NumPlaces = ISNULL(IONumPlaces, 6)
		FROM	tPreference
		WHERE	CompanyKey = @_iCompanyKey
	ELSE 
	IF @_iTranType = 'BC'
		SELECT	@_lNextTranNo = ISNULL(NextBCNum, 1)
  				,@NumPrefix = ISNULL(BCNumPrefix, '')
				,@NumPlaces = ISNULL(BCNumPlaces, 6)
		FROM	tPreference
		WHERE	CompanyKey = @_iCompanyKey
	ELSE 
	IF @_iTranType = 'INT'
		SELECT	@_lNextTranNo = ISNULL(NextIntNum, 1)
  				,@NumPrefix = ISNULL(IntNumPrefix, '')
				,@NumPlaces = ISNULL(IntNumPlaces, 6)
		FROM	tPreference
		WHERE	CompanyKey = @_iCompanyKey
	ELSE
	IF @_iTranType = 'AR'
		SELECT	@_lNextTranNo = ISNULL(NextARNum, 1)
  				,@NumPrefix = ISNULL(ARNumPrefix, '')
				,@NumPlaces = ISNULL(ARNumPlaces, 6)
		FROM	tPreference
		WHERE	CompanyKey = @_iCompanyKey
	ELSE
	IF @_iTranType = 'Expense'
		SELECT	@_lNextTranNo = ISNULL(NextExpenseNum, 1)
  				,@NumPrefix = ISNULL(ExpenseNumPrefix, '')
				,@NumPlaces = ISNULL(ExpenseNumPlaces, 6)
		FROM	tPreference
		WHERE	CompanyKey = @_iCompanyKey
	IF @_iTranType = 'MediaWkshtPrint'
		SELECT	@_lNextTranNo = ISNULL(NextMediaWorksheetNum, 1)
  				,@NumPrefix = ''
				,@NumPlaces = 6
		FROM	tPreference
		WHERE	CompanyKey = @_iCompanyKey
	IF @_iTranType = 'MediaWkshtInt'
		SELECT	@_lNextTranNo = ISNULL(NextMediaWorksheetIntNum, 1)
  				,@NumPrefix = ''
				,@NumPlaces = 6
		FROM	tPreference
		WHERE	CompanyKey = @_iCompanyKey
	IF @_iTranType = 'MediaWkshtBC'
		SELECT	@_lNextTranNo = ISNULL(NextMediaWorksheetBCNum, 1)
  				,@NumPrefix = ''
				,@NumPlaces = 6
		FROM	tPreference
		WHERE	CompanyKey = @_iCompanyKey
	IF @_iTranType = 'MediaWkshtOOH'
		SELECT	@_lNextTranNo = ISNULL(NextMediaWorksheetNum, 1)
  				,@NumPrefix = ''
				,@NumPlaces = 6
		FROM	tPreference
		WHERE	CompanyKey = @_iCompanyKey


		
	/* loop until unused tran number found */
	WHILE( 1=1 )
	BEGIN

		SELECT @_lNextTranNoC = CONVERT(CHAR(100), @_lNextTranNo)
		IF @NumPlaces < LEN(LTRIM(RTRIM(@_lNextTranNoC)))
			SELECT @_lNextTranNoPC = @_lNextTranNoC
		ELSE
		BEGIN
			SELECT @_lTempTranNo = @Zeroes +LTRIM(RTRIM(@_lNextTranNoC))
			SELECT @_lNextTranNoPC = RIGHT(@_lTempTranNo, @NumPlaces)
		END
		IF @NumPrefix <> '' 
			SELECT @_lNextTranNoPC = @NumPrefix+'-'+@_lNextTranNoPC
		
		/* see if next tran number already exists in tran log */
		IF @_iTranType = 'PO'
			IF EXISTS (SELECT 1 FROM tPurchaseOrder (NOLOCK)
					WHERE 	PurchaseOrderNumber IN (@_lNextTranNoC, @_lNextTranNoPC)
					AND     CompanyKey = @_iCompanyKey
					AND		POKind = 0)
				SELECT @NumUsed = 1
			ELSE
				SELECT @NumUsed = 0
		ELSE
		IF @_iTranType = 'IO'
			IF EXISTS (SELECT 1 FROM tPurchaseOrder (NOLOCK)
					WHERE 	PurchaseOrderNumber IN (@_lNextTranNoC, @_lNextTranNoPC)
					AND     CompanyKey = @_iCompanyKey
					AND		POKind = 1)
				SELECT @NumUsed = 1
			ELSE
				SELECT @NumUsed = 0
		ELSE
		IF @_iTranType = 'BC'
			IF EXISTS (SELECT 1 FROM tPurchaseOrder (NOLOCK)
					WHERE 	PurchaseOrderNumber IN (@_lNextTranNoC, @_lNextTranNoPC)
					AND     CompanyKey = @_iCompanyKey
					AND		POKind = 2)
				SELECT @NumUsed = 1
			ELSE
				SELECT @NumUsed = 0
		ELSE
		IF @_iTranType = 'INT'
			IF EXISTS (SELECT 1 FROM tPurchaseOrder (NOLOCK)
					WHERE 	PurchaseOrderNumber IN (@_lNextTranNoC, @_lNextTranNoPC)
					AND     CompanyKey = @_iCompanyKey
					AND		POKind = 4)
				SELECT @NumUsed = 1
			ELSE
				SELECT @NumUsed = 0
		ELSE
		IF @_iTranType = 'AR'
			IF EXISTS (SELECT 1 FROM tInvoice (NOLOCK)
					WHERE 	InvoiceNumber IN (@_lNextTranNoC, @_lNextTranNoPC)
					AND     CompanyKey = @_iCompanyKey)
				SELECT @NumUsed = 1
			ELSE
				SELECT @NumUsed = 0		
		ELSE
		IF @_iTranType = 'Expense'
			IF EXISTS (SELECT 1 FROM tExpenseEnvelope (NOLOCK)
					WHERE 	EnvelopeNumber IN (@_lNextTranNoC, @_lNextTranNoPC)
					AND     CompanyKey = @_iCompanyKey)
				SELECT @NumUsed = 1
			ELSE
				SELECT @NumUsed = 0		
		IF @_iTranType IN ('MediaWkshtPrint', 'MediaWkshtInt', 'MediaWkshtBC', 'MediaWkshtOOH')
			IF EXISTS (SELECT 1 FROM tMediaWorksheet (NOLOCK)
					WHERE	WorksheetID IN (@_lNextTranNoC, @_lNextTranNoPC)
					AND		CompanyKey = @_iCompanyKey)
				SELECT @NumUsed = 1
			ELSE
				SELECT @NumUsed = 0
		
		IF @NumUsed = 0

		BEGIN
			/* not found, return as valid choice */
			SELECT	@_oNextTranNo = @_lNextTranNoPC 

			/* increment to next number */
			SELECT	@_lNextTranNo = @_lNextTranNo + 1

			/* check if we've hit the limit */
			IF @_lNextTranNo >  2147483647
			BEGIN
				SELECT	@_oRetVal = 2
				RETURN
			END

			/* update next number */
			IF @_iTranType = 'PO'
				UPDATE tPreference
				SET    NextPONum = @_lNextTranNo
				WHERE	CompanyKey = @_iCompanyKey
			ELSE
			IF @_iTranType = 'IO'
				UPDATE tPreference
				SET    NextIONum = @_lNextTranNo
				WHERE	CompanyKey = @_iCompanyKey
			ELSE
			IF @_iTranType = 'BC'
				UPDATE tPreference
				SET    NextBCNum = @_lNextTranNo
				WHERE	CompanyKey = @_iCompanyKey
			ELSE
			IF @_iTranType = 'INT'
				UPDATE tPreference
				SET    NextIntNum = @_lNextTranNo
				WHERE	CompanyKey = @_iCompanyKey
			ELSE
			IF @_iTranType = 'AR'
				UPDATE tPreference
				SET    NextARNum = @_lNextTranNo
				WHERE	CompanyKey = @_iCompanyKey
			ELSE
			IF @_iTranType = 'Expense'
				UPDATE tPreference
				SET    NextExpenseNum = @_lNextTranNo
				WHERE	CompanyKey = @_iCompanyKey
			IF @_iTranType = 'MediaWkshtPrint'
				UPDATE	tPreference
				SET		NextMediaWorksheetNum = @_lNextTranNo
				WHERE	CompanyKey = @_iCompanyKey
			IF @_iTranType = 'MediaWkshtInt'
				UPDATE	tPreference
				SET		NextMediaWorksheetIntNum = @_lNextTranNo
				WHERE	CompanyKey = @_iCompanyKey
			IF @_iTranType = 'MediaWkshtBC'
				UPDATE	tPreference
				SET		NextMediaWorksheetBCNum = @_lNextTranNo
				WHERE	CompanyKey = @_iCompanyKey
			IF @_iTranType = 'MediaWkshtOOH'
				UPDATE	tPreference
				SET		NextMediaWorksheetOOHNum = @_lNextTranNo
				WHERE	CompanyKey = @_iCompanyKey
			
			SELECT	@_oRetVal = 1

			/* return to caller */
			RETURN
		END

		/* increment to next number */
		SELECT	@_lNextTranNo = @_lNextTranNo + 1

		/* check if we've hit the limit */
		IF @_lNextTranNo > 2147483647
		BEGIN
			SELECT	@_oRetVal = 2
	
		RETURN
		END

		/* loop until we find a free tran no*/
	END
END
GO
