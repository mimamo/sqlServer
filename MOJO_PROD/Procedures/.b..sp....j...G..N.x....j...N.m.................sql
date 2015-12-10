USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetNextProjectNum]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptProjectGetNextProjectNum]
(

	@_iCompanyKey		 INTEGER,
	@_iClientKey		 INTEGER,
	@_iOfficeKey		 INTEGER,
	@_iProjectTypeKey	 INTEGER,
	@_iClientDivisionKey INTEGER,
	@_iCampaignKey       INTEGER,
	@_oRetVal			 INTEGER OUTPUT,
	@_oNextTranNo 		 VARCHAR(100) OUTPUT
	)
AS --Encrypt
BEGIN

  /*
  || When     Who Rel   What
  || 03/07/07 GHL 8.4   New Breed Marketing, Bug 8478: 1000 projects per client and NumPlaces = 3
  ||                    Style = Client ID + Next Number from Client 
  ||                    Causing infinite loop, added protection against this situation   
  || 06/17/11 GHL 10.545 (114614) Removed NOLOCK when reading Next numbers from tPreference or other tables
  ||                    This is a case where I want a lock on the record and not a dirty read
  ||                    so that we do not end up with 2 projects with the same number              
  || 01/22/13 GHL 10.564 (164895) Users complained that numbers go from 13-TEST-0005 to 13-TEST-0007
  ||                    This was due to the fact that a project number 6 existed.
  ||                    Modified the checking of existing project numbers so that we only check 6 if the
  ||                    desired project number is numeric 
  || 06/18/13 GHL 10.569 (181721) Added project numbers by campaign
  || 03/19/15 WDF 10.590 (Abelson Taylor) Added ProjectNumberStyle 9 - Client ID, Next Global Number
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
			   ,@NextProjectNumStyle INTEGER
			   ,@ProjectNumSep VARCHAR(1)
			   ,@TwoDigitPrefix tinyint
			   ,@StartMonth smallint
			   
	/* initialize return value to failure status */
	SELECT	@_oRetVal = 0
	SELECT	@_oNextTranNo = NULL
	SELECT	@Zeroes = '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	

	/* find next tran number (with lock on row when reading next numbers) */

	-- Determine where to get the number from
	SELECT	 @NextProjectNumStyle = isnull(ProjectNumStyle, 1)
			,@ProjectNumSep = ISNULL(ProjectNumSep, '')
			,@NumPrefix = ISNULL(ProjectNumPrefix, '')  
		    ,@TwoDigitPrefix = ISNULL(ProjectNumPrefixUseYear, 0)
		    ,@StartMonth = ISNULL(FirstMonth, 1)
	FROM	tPreference (NOLOCK)
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
				NextProjectNum = 1, 
				ProjectNumPrefix = @CurYear
			Where
				CompanyKey = @_iCompanyKey
		END
	END

	IF @NextProjectNumStyle = 7
		IF ISNULL(@_iClientDivisionKey, 0) = 0
			if @TwoDigitPrefix = 1
				Select @NextProjectNumStyle = 3
			else
				Select @NextProjectNumStyle = 2
	
	-- Just the Global Prefix and a Global Sequential
	IF @NextProjectNumStyle = 1
	BEGIN
		SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1)
  				,@NumPrefix =		ISNULL(ProjectNumPrefix, '')
				,@NumPlaces =		ISNULL(ProjectNumPlaces, 6)
				,@TwoDigitPrefix = ISNULL(ProjectNumPrefixUseYear, 0)
		FROM	tPreference
		WHERE	CompanyKey = @_iCompanyKey
				
		Select @NumPrefix = @NumPrefix+LTRIM(@ProjectNumSep)
	END


	-- Client ID and Next Number for the Client (2 Digit year not used)
	IF @NextProjectNumStyle = 2
	BEGIN
		IF ISNULL(@_iClientKey, 0) = 0
			SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1)
  					,@NumPrefix =		ISNULL(ProjectNumPrefix, '')
					,@NumPlaces =		ISNULL(ProjectNumPlaces, 6)
			FROM	tPreference 
			WHERE	CompanyKey = @_iCompanyKey
		ELSE
		BEGIN
			SELECT	@NumPlaces = ISNULL(ProjectNumPlaces, 6)
			FROM	tPreference (NOLOCK) 
			WHERE	CompanyKey = @_iCompanyKey
		
			SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1)
  					,@NumPrefix = ISNULL(CustomerID, '')
			FROM	tCompany  
			WHERE	CompanyKey = @_iClientKey
		END
		IF LEN(LTRIM(RTRIM(@NumPrefix))) > 50 - @NumPlaces - 1
			Select @NumPrefix = LEFT(@NumPrefix, 50 - @NumPlaces - 1)
			Select @NumPrefix = @NumPrefix+LTRIM(@ProjectNumSep)
	END
	
	-- Global Prefix, Client ID + Next Number from the client
	IF @NextProjectNumStyle = 3
	BEGIN
		IF ISNULL(@_iClientKey, 0) = 0
		BEGIN
			SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1)
  					,@NumPrefix =		ISNULL(ProjectNumPrefix, '')
					,@NumPlaces =		ISNULL(ProjectNumPlaces, 6)
			FROM	tPreference  
			WHERE	CompanyKey = @_iCompanyKey
			Select @NumPrefix = @NumPrefix+LTRIM(@ProjectNumSep)
		END
		ELSE
		BEGIN
			SELECT	@NumPlaces = ISNULL(ProjectNumPlaces, 6)
				   ,@NumPrefix2 = ISNULL(ProjectNumPrefix, '')
			FROM	tPreference (NOLOCK) 
			WHERE	CompanyKey = @_iCompanyKey
		
			SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1)
  					,@NumPrefix = ISNULL(CustomerID, '')
			FROM	tCompany  
			WHERE	CompanyKey = @_iClientKey
			Select @NumPrefix = @NumPrefix2+LTRIM(@ProjectNumSep)+@NumPrefix
			IF LEN(LTRIM(RTRIM(@NumPrefix))) > 50 - @NumPlaces - 1
				Select @NumPrefix = LEFT(@NumPrefix, 50 - @NumPlaces - 1)
				Select @NumPrefix = @NumPrefix+LTRIM(@ProjectNumSep)
		END
	END
	-- Global Prefix, Client ID, Next Global Number
	IF @NextProjectNumStyle = 4
	BEGIN
		IF ISNULL(@_iClientKey, 0) = 0
		BEGIN
			SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1)
  					,@NumPrefix =		ISNULL(ProjectNumPrefix, '')
					,@NumPlaces =		ISNULL(ProjectNumPlaces, 6)
			FROM	tPreference  
			WHERE	CompanyKey = @_iCompanyKey
			Select @NumPrefix = @NumPrefix+LTRIM(@ProjectNumSep)
		END
		ELSE
		BEGIN
			SELECT	@NumPlaces = ISNULL(ProjectNumPlaces, 6)
				   ,@_lNextTranNo = ISNULL(NextProjectNum, 1)
				   ,@NumPrefix2 = ISNULL(ProjectNumPrefix, '')
			FROM	tPreference  
			WHERE	CompanyKey = @_iCompanyKey
		
			SELECT	@NumPrefix = ISNULL(CustomerID, '')
			FROM	tCompany (NOLOCK) 
			WHERE	CompanyKey = @_iClientKey
			Select @NumPrefix = @NumPrefix2+LTRIM(@ProjectNumSep)+@NumPrefix
			IF LEN(LTRIM(RTRIM(@NumPrefix))) > 50 - @NumPlaces - 1
				Select @NumPrefix = LEFT(@NumPrefix, 50 - @NumPlaces - 1)
				Select @NumPrefix = @NumPrefix+LTRIM(@ProjectNumSep)
		END
	END
	
	-- Office Prefix and Office Next Number
	IF @NextProjectNumStyle = 5
	BEGIN
		IF ISNULL(@_iOfficeKey, 0) = 0
			SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1) 
  					,@NumPrefix =		ISNULL(ProjectNumPrefix, '')
					,@NumPlaces =		ISNULL(ProjectNumPlaces, 6)
			FROM	tPreference 
			WHERE	CompanyKey = @_iCompanyKey
		ELSE
		BEGIN
			SELECT	@NumPlaces = ISNULL(ProjectNumPlaces, 6)
			FROM	tPreference (NOLOCK) 
			WHERE	CompanyKey = @_iCompanyKey
		
			SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1)
  					,@NumPrefix = ISNULL(ProjectNumPrefix, '')
			FROM	tOffice  
			WHERE	OfficeKey = @_iOfficeKey
		END
		IF LEN(LTRIM(RTRIM(@NumPrefix))) > 50 - @NumPlaces - 1
			Select @NumPrefix = LEFT(@NumPrefix, 50 - @NumPlaces - 1)
			Select @NumPrefix = @NumPrefix+LTRIM(@ProjectNumSep)
	END
	
	-- Project Type Prefix and Type Next Number
	IF @NextProjectNumStyle = 6
	BEGIN
		IF ISNULL(@_iProjectTypeKey, 0) = 0
			SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1)
  					,@NumPrefix =		ISNULL(ProjectNumPrefix, '')
					,@NumPlaces =		ISNULL(ProjectNumPlaces, 6)
			FROM	tPreference  
			WHERE	CompanyKey = @_iCompanyKey
		ELSE
		BEGIN
			SELECT	@NumPlaces = ISNULL(ProjectNumPlaces, 6)
			FROM	tPreference (NOLOCK) 
			WHERE	CompanyKey = @_iCompanyKey
		
			SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1)
  					,@NumPrefix = ISNULL(ProjectNumPrefix, '')
			FROM	tProjectType   
			WHERE	ProjectTypeKey = @_iProjectTypeKey
		END
		IF LEN(LTRIM(RTRIM(@NumPrefix))) > 50 - @NumPlaces - 1
			Select @NumPrefix = LEFT(@NumPrefix, 50 - @NumPlaces - 1)
			Select @NumPrefix = @NumPrefix+LTRIM(@ProjectNumSep)
	END
	
	-- Client Division Prefix and Client Division Next Number
	IF @NextProjectNumStyle = 7
	BEGIN
		IF ISNULL(@_iClientDivisionKey, 0) = 0
			SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1)
  					,@NumPrefix =		ISNULL(ProjectNumPrefix, '')
					,@NumPlaces =		ISNULL(ProjectNumPlaces, 6)
			FROM	tPreference  
			WHERE	CompanyKey = @_iCompanyKey
		ELSE
		BEGIN
			SELECT	@NumPlaces = ISNULL(ProjectNumPlaces, 6)
			FROM	tPreference (NOLOCK) 
			WHERE	CompanyKey = @_iCompanyKey
		
			SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1)
  					,@NumPrefix = ISNULL(ProjectNumPrefix, '')
			FROM	tClientDivision  
			WHERE	ClientDivisionKey = @_iClientDivisionKey
		END
		IF LEN(LTRIM(RTRIM(@NumPrefix))) > 50 - @NumPlaces - 1
			Select @NumPrefix = LEFT(@NumPrefix, 50 - @NumPlaces - 1)
			Select @NumPrefix = @NumPrefix+LTRIM(@ProjectNumSep)
	END
	
	-- Campaign ID and Campaign Next Number
	IF @NextProjectNumStyle = 8
	BEGIN
		IF ISNULL(@_iCampaignKey, 0) = 0
			SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1)
  					,@NumPrefix =		ISNULL(ProjectNumPrefix, '')
					,@NumPlaces =		ISNULL(ProjectNumPlaces, 6)
			FROM	tPreference  
			WHERE	CompanyKey = @_iCompanyKey
		ELSE
		BEGIN
			SELECT	@NumPlaces = ISNULL(ProjectNumPlaces, 6)
			FROM	tPreference (NOLOCK) 
			WHERE	CompanyKey = @_iCompanyKey
		
			SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1)
  					,@NumPrefix = ISNULL(CampaignID, '')
			FROM	tCampaign  
			WHERE	CampaignKey = @_iCampaignKey
		END
		IF LEN(LTRIM(RTRIM(@NumPrefix))) > 50 - @NumPlaces - 1
			Select @NumPrefix = LEFT(@NumPrefix, 50 - @NumPlaces - 1)
			Select @NumPrefix = @NumPrefix+LTRIM(@ProjectNumSep)
	END
	
	-- Client ID, Next Global Number
	IF @NextProjectNumStyle = 9
	BEGIN
		IF ISNULL(@_iClientKey, 0) = 0
		BEGIN
			SELECT	@_lNextTranNo = ISNULL(NextProjectNum, 1)
  					,@NumPrefix =	ISNULL(ProjectNumPrefix, '')
					,@NumPlaces =   ISNULL(ProjectNumPlaces, 6)
			FROM	tPreference  
			WHERE	CompanyKey = @_iCompanyKey
			Select @NumPrefix = @NumPrefix+LTRIM(@ProjectNumSep)
		END
		ELSE
		BEGIN
			SELECT	@NumPlaces = ISNULL(ProjectNumPlaces, 6)
				   ,@_lNextTranNo = ISNULL(NextProjectNum, 1)
			FROM	tPreference  
			WHERE	CompanyKey = @_iCompanyKey
		
			SELECT	@NumPrefix = ISNULL(CustomerID, '')
			FROM	tCompany (NOLOCK) 
			WHERE	CompanyKey = @_iClientKey
			IF LEN(LTRIM(RTRIM(@NumPrefix))) > 50 - @NumPlaces - 1
				Select @NumPrefix = LEFT(@NumPrefix, 50 - @NumPlaces - 1)
			Select @NumPrefix = @NumPrefix+LTRIM(@ProjectNumSep)
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
			SET    ProjectNumPlaces = @NumPlaces
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

		-- Added check of numeric for (164895)
		if isnumeric(@_lNextTranNoPC) = 1
		begin
			/* see if next tran number already exists in tran log...removed nolock 06/17/11 GHL */
			IF EXISTS (SELECT 1 FROM tProject WHERE ProjectNumber IN (@_lNextTranNoC, @_lNextTranNoPC) AND CompanyKey = @_iCompanyKey)
				SELECT @NumUsed = 1
			ELSE
				SELECT @NumUsed = 0		
		end
		else
		begin
			/* see if next tran number already exists in tran log...removed nolock 06/17/11 GHL */
			/* removed checking of @_lNextTranNoC */
			IF EXISTS (SELECT 1 FROM tProject WHERE ProjectNumber IN (@_lNextTranNoPC) AND CompanyKey = @_iCompanyKey)
				SELECT @NumUsed = 1
			ELSE
				SELECT @NumUsed = 0		
		end

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
			IF @NextProjectNumStyle = 1
				UPDATE tPreference
				SET    NextProjectNum = @_lNextTranNo
				WHERE	CompanyKey = @_iCompanyKey
			IF @NextProjectNumStyle = 2
				if @_iClientKey = 0
					UPDATE tPreference
					SET    NextProjectNum = @_lNextTranNo
					WHERE	CompanyKey = @_iCompanyKey
				else
					UPDATE tCompany
					SET    NextProjectNum = @_lNextTranNo
					WHERE	CompanyKey = @_iClientKey
			IF @NextProjectNumStyle = 3
				if @_iClientKey = 0
					UPDATE tPreference
					SET    NextProjectNum = @_lNextTranNo
					WHERE	CompanyKey = @_iCompanyKey
				else
					UPDATE tCompany
					SET    NextProjectNum = @_lNextTranNo
					WHERE	CompanyKey = @_iClientKey
			IF @NextProjectNumStyle = 4
				UPDATE tPreference
				SET    NextProjectNum = @_lNextTranNo
				WHERE	CompanyKey = @_iCompanyKey
			IF @NextProjectNumStyle = 5
				if isnull(@_iOfficeKey, 0) = 0
					UPDATE tPreference
					SET    NextProjectNum = @_lNextTranNo
					WHERE	CompanyKey = @_iCompanyKey
				else
					UPDATE tOffice
					SET	NextProjectNum = @_lNextTranNo
					WHERE OfficeKey = @_iOfficeKey
			IF @NextProjectNumStyle = 6
				if isnull(@_iProjectTypeKey, 0) = 0
					UPDATE tPreference
					SET    NextProjectNum = @_lNextTranNo
					WHERE	CompanyKey = @_iCompanyKey
				else
					UPDATE tProjectType
					SET    NextProjectNum = @_lNextTranNo
					WHERE	ProjectTypeKey = @_iProjectTypeKey

			IF @NextProjectNumStyle = 7
				if isnull(@_iClientDivisionKey, 0) = 0
					UPDATE tPreference
					SET    NextProjectNum = @_lNextTranNo
					WHERE	CompanyKey = @_iCompanyKey
				else
					UPDATE tClientDivision
					SET    NextProjectNum = @_lNextTranNo
					WHERE  ClientDivisionKey = @_iClientDivisionKey

			IF @NextProjectNumStyle = 8
				if isnull(@_iCampaignKey, 0) = 0
					UPDATE tPreference
					SET    NextProjectNum = @_lNextTranNo
					WHERE	CompanyKey = @_iCompanyKey
				else
					UPDATE tCampaign
					SET    NextProjectNum = @_lNextTranNo
					WHERE  CampaignKey = @_iCampaignKey

			IF @NextProjectNumStyle = 9
				UPDATE tPreference
				SET    NextProjectNum = @_lNextTranNo
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
