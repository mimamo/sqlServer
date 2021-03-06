USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignGetNextCampaignNum]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptCampaignGetNextCampaignNum]
(

	@_iCompanyKey		 INTEGER,
	@_iClientKey		 INTEGER,
	@_oRetVal			 INTEGER OUTPUT,
	@_oNextTranNo 		 VARCHAR(100) OUTPUT
	)
AS --Encrypt
BEGIN

  /*
  || When     Who Rel    What
  || 03/07/07 GHL 8.4    New Breed Marketing, Bug 8478: 1000 Projects per client and NumPlaces = 3
  ||                     Style = Client ID + Next Number from Client 
  ||                     Causing infinite loop, added protection against this situation
  || 03/02/11 GHL 10.542 (103729) Cloned sptProjectGetNextProjectNum for enhancement
  */
  
	DECLARE		@_lNextTranNo		INTEGER			/* local work variable */
	DECLARE 	@_lNextTranNoC	 	CHAR(100)		/* character version of tran number */		
	DECLARE 	@_lNextTranNoPC     CHAR(100)		/* character version of tran number padded with 0's on the left */
	DECLARE 	@_lTempTranNo       VARCHAR(200)

	DECLARE		@NumPrefix 		VARCHAR(50)
			   ,@NumPrefix2		VARCHAR(50)
			   ,@NumPlaces		INTEGER
			   ,@Zeroes		VARCHAR(100)
			   ,@NumUsed		INTEGER
			   ,@NextCampaignNumStyle INTEGER
			   ,@CampaignNumSep VARCHAR(1)
			   ,@TwoDigitPrefix tinyint
			   ,@StartMonth smallint
			   
	/* initialize return value to failure status */
	SELECT	@_oRetVal = 0
	SELECT	@_oNextTranNo = NULL
	SELECT	@Zeroes = '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	
	-- Determine where to get the number from
	Select @NextCampaignNumStyle = isnull(CampaignNumStyle, 1), @CampaignNumSep = ISNULL(CampaignNumSep, '')
	from tPreference (nolock) Where CompanyKey = @_iCompanyKey

	/* find next tran number (with lock on row) */

	SELECT	@NumPrefix = ISNULL(CampaignNumPrefix, '') , 
		@TwoDigitPrefix = ISNULL(CampaignNumPrefixUseYear, 0),
		@StartMonth = ISNULL(FirstMonth, 1)
	FROM	tPreference 
	WHERE	CompanyKey = @_iCompanyKey
	
	if @TwoDigitPrefix = 1
	BEGIN
		Declare @CurYear char(2)
		Select @CurYear = Right(Year(GETDATE()), 2)
		if @CurYear <> @NumPrefix and Month(GETDATE()) >= @StartMonth
		BEGIN
			Select @NumPrefix = @CurYear, @_lNextTranNo = 1
			Update tPreference
			Set
				NextCampaignNum = 1, 
				CampaignNumPrefix = @CurYear
			Where
				CompanyKey = @_iCompanyKey
		END
	END

	-- Just the Global Prefix and a Global Sequential
	IF @NextCampaignNumStyle = 1
	BEGIN
		SELECT	@_lNextTranNo = ISNULL(NextCampaignNum, 1)
  				,@NumPrefix =		ISNULL(CampaignNumPrefix, '')
				,@NumPlaces =		ISNULL(CampaignNumPlaces, 6)
				,@TwoDigitPrefix = ISNULL(CampaignNumPrefixUseYear, 0)
		FROM	tPreference (NOLOCK) 
		WHERE	CompanyKey = @_iCompanyKey
				
		Select @NumPrefix = @NumPrefix+LTRIM(@CampaignNumSep)
	END


	-- Client ID and Next Number for the Client (2 Digit year not used)
	IF @NextCampaignNumStyle = 2
	BEGIN
		IF ISNULL(@_iClientKey, 0) = 0
			SELECT	@_lNextTranNo = ISNULL(NextCampaignNum, 1)
  					,@NumPrefix =		ISNULL(CampaignNumPrefix, '')
					,@NumPlaces =		ISNULL(CampaignNumPlaces, 6)
			FROM	tPreference (NOLOCK) 
			WHERE	CompanyKey = @_iCompanyKey
		ELSE
		BEGIN
			SELECT	@NumPlaces = ISNULL(CampaignNumPlaces, 6)
			FROM	tPreference (NOLOCK) 
			WHERE	CompanyKey = @_iCompanyKey
		
			SELECT	@_lNextTranNo = ISNULL(NextCampaignNum, 1)
  					,@NumPrefix = ISNULL(CustomerID, '')
			FROM	tCompany (NOLOCK) 
			WHERE	CompanyKey = @_iClientKey
		END
		IF LEN(LTRIM(RTRIM(@NumPrefix))) > 50 - @NumPlaces - 1
			Select @NumPrefix = LEFT(@NumPrefix, 50 - @NumPlaces - 1)
			Select @NumPrefix = @NumPrefix+LTRIM(@CampaignNumSep)
	END
	
	-- Global Prefix, Client ID + Next Number from the client
	IF @NextCampaignNumStyle = 3
	BEGIN
		IF ISNULL(@_iClientKey, 0) = 0
		BEGIN
			SELECT	@_lNextTranNo = ISNULL(NextCampaignNum, 1)
  					,@NumPrefix =		ISNULL(CampaignNumPrefix, '')
					,@NumPlaces =		ISNULL(CampaignNumPlaces, 6)
			FROM	tPreference (NOLOCK) 
			WHERE	CompanyKey = @_iCompanyKey
			Select @NumPrefix = @NumPrefix+LTRIM(@CampaignNumSep)
		END
		ELSE
		BEGIN
			SELECT	@NumPlaces = ISNULL(CampaignNumPlaces, 6)
				   ,@NumPrefix2 = ISNULL(CampaignNumPrefix, '')
			FROM	tPreference (NOLOCK) 
			WHERE	CompanyKey = @_iCompanyKey
		
			SELECT	@_lNextTranNo = ISNULL(NextCampaignNum, 1)
  					,@NumPrefix = ISNULL(CustomerID, '')
			FROM	tCompany (NOLOCK) 
			WHERE	CompanyKey = @_iClientKey
			Select @NumPrefix = @NumPrefix2+LTRIM(@CampaignNumSep)+@NumPrefix
			IF LEN(LTRIM(RTRIM(@NumPrefix))) > 50 - @NumPlaces - 1
				Select @NumPrefix = LEFT(@NumPrefix, 50 - @NumPlaces - 1)
				Select @NumPrefix = @NumPrefix+LTRIM(@CampaignNumSep)
		END
	END
	-- Global Prefix, Client ID, Next Global Number
	IF @NextCampaignNumStyle = 4
	BEGIN
		IF ISNULL(@_iClientKey, 0) = 0
		BEGIN
			SELECT	@_lNextTranNo = ISNULL(NextCampaignNum, 1)
  					,@NumPrefix =		ISNULL(CampaignNumPrefix, '')
					,@NumPlaces =		ISNULL(CampaignNumPlaces, 6)
			FROM	tPreference (NOLOCK) 
			WHERE	CompanyKey = @_iCompanyKey
			Select @NumPrefix = @NumPrefix+LTRIM(@CampaignNumSep)
		END
		ELSE
		BEGIN
			SELECT	@NumPlaces = ISNULL(CampaignNumPlaces, 6)
				   ,@_lNextTranNo = ISNULL(NextCampaignNum, 1)
				   ,@NumPrefix2 = ISNULL(CampaignNumPrefix, '')
			FROM	tPreference (NOLOCK) 
			WHERE	CompanyKey = @_iCompanyKey
		
			SELECT	@NumPrefix = ISNULL(CustomerID, '')
			FROM	tCompany (NOLOCK) 
			WHERE	CompanyKey = @_iClientKey
			Select @NumPrefix = @NumPrefix2+LTRIM(@CampaignNumSep)+@NumPrefix
			IF LEN(LTRIM(RTRIM(@NumPrefix))) > 50 - @NumPlaces - 1
				Select @NumPrefix = LEFT(@NumPrefix, 50 - @NumPlaces - 1)
				Select @NumPrefix = @NumPrefix+LTRIM(@CampaignNumSep)
		END
	END
	
	
		
	/* loop until unused tran number found */
	WHILE( 1=1 )
	BEGIN

		-- Protection when @NumPlaces too small
		IF LEN(@_lNextTranNo) > @NumPlaces
		BEGIN
			SELECT @NumPlaces = LEN(@_lNextTranNo)
			
			UPDATE tPreference
			SET    CampaignNumPlaces = @NumPlaces
			WHERE  CompanyKey = @_iCompanyKey  
			
			/* Explanation: 
			
			if @_lTempTranNo = 1000 and @NumPlaces = 3
			@_lNextTranNoC = '1000                                 '
			@_lTempTranNo  = '0000000000000000000000000000000001000' 
			@_lNextTranNoPC = '000' i.e. not enough for 1000, we need @NumPlaces = 4 
		
			*/
		END
	
		SELECT @_lNextTranNoC = CONVERT(CHAR(100), @_lNextTranNo)
		SELECT @_lTempTranNo = @Zeroes +LTRIM(RTRIM(@_lNextTranNoC))
		SELECT @_lNextTranNoPC = RIGHT(@_lTempTranNo, @NumPlaces)

		IF @NumPrefix <> '' 
			SELECT @_lNextTranNoPC = @NumPrefix+@_lNextTranNoPC


		/* see if next tran number already exists in tran log */
		IF EXISTS (SELECT 1 FROM tCampaign (NOLOCK) WHERE CampaignID IN (@_lNextTranNoC, @_lNextTranNoPC) AND CompanyKey = @_iCompanyKey)
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
			IF @NextCampaignNumStyle = 1
				UPDATE tPreference
				SET    NextCampaignNum = @_lNextTranNo
				WHERE	CompanyKey = @_iCompanyKey
			IF @NextCampaignNumStyle = 2
				if @_iClientKey = 0
					UPDATE tPreference
					SET    NextCampaignNum = @_lNextTranNo
					WHERE	CompanyKey = @_iCompanyKey
				else
					UPDATE tCompany
					SET    NextCampaignNum = @_lNextTranNo
					WHERE	CompanyKey = @_iClientKey
			IF @NextCampaignNumStyle = 3
				if @_iClientKey = 0
					UPDATE tPreference
					SET    NextCampaignNum = @_lNextTranNo
					WHERE	CompanyKey = @_iCompanyKey
				else
					UPDATE tCompany
					SET    NextCampaignNum = @_lNextTranNo
					WHERE	CompanyKey = @_iClientKey
			IF @NextCampaignNumStyle = 4
				UPDATE tPreference
				SET    NextCampaignNum = @_lNextTranNo
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
