USE [MOJo_dev]
GO

/****** Object:  StoredProcedure [dbo].[sptEstimateGetNextEstimateNum]    Script Date: 04/29/2016 16:37:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sptEstimateGetNextEstimateNum]
	(
	@_iCompanyKey		 INTEGER,	
	@_iProjectKey		 INTEGER,
	@_iCampaignKey       INTEGER,
	@_iLeadKey           INTEGER,
	@_oRetVal			 INTEGER OUTPUT,
	@_oNextTranNo 		 VARCHAR(50) OUTPUT
	)
	
AS -- Encrypt

  /*
  || When     Who Rel    What
  || 02/19/07 GHL 8.4    Ervin & Smith: Next Number = 2775 and NumPlaces = 3
  ||                     Causing infinite loop in SQL Server 2005, OK in 2000
  ||                     Added protection against this situation
  || 02/09/10 GHL 10.518 Added CampaignKey, LeadKey params  ... NOT SURE WHAT TO DO WITH LeadKey ????? (no ID) 
  || 03/04/10 GHL 10.519 Added logic for opportunities (@_iLeadKey > 0)             
  */
  
	SET NOCOUNT ON
	
	DECLARE		 @_lNextTranNo		INTEGER			/* local work variable */
				,@_lNextTranNoC	 	VARCHAR(50)		/* character version of tran number */		
	            ,@_lNextTranNoPC     CHAR(100)		/* character version of tran number padded with 0's on the left */
	            ,@_lTempTranNo       VARCHAR(200)
			    ,@NumUsed		INTEGER
			    ,@ProjectNumber VARCHAR(50)
			    ,@NumPrefix 		VARCHAR(50)
			    ,@NumPrefix2		VARCHAR(50)
			    ,@NumPlaces		INTEGER
			    ,@Zeroes		VARCHAR(100)
			    ,@NextEstimateNumStyle INTEGER
			    ,@EstimateNumSep VARCHAR(1)
			    ,@TwoDigitPrefix tinyint
			    ,@StartMonth smallint
	
	-- initialize return value to failure status */
	SELECT	@_oRetVal = 0
	SELECT	@_oNextTranNo = NULL
	SELECT	@Zeroes = '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000'

	-- determine where to get the number from
	Select @NextEstimateNumStyle = isnull(EstimateNumStyle, 2), @EstimateNumSep = ISNULL(EstimateNumSep, '')
	from tPreference (nolock) Where CompanyKey = @_iCompanyKey

	-- find next tran number (with lock on row) 
	SELECT	@NumPrefix = ISNULL(EstimateNumPrefix, '') , 
		    @TwoDigitPrefix = ISNULL(EstimateNumPrefixUseYear, 0),
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
				NextEstimateNum = 1, 
				EstimateNumPrefix = @CurYear
			Where
				CompanyKey = @_iCompanyKey
		END
	END

	-- Just the Global Prefix and a Global Sequential
	IF @NextEstimateNumStyle = 1
	BEGIN
		SELECT	@_lNextTranNo = ISNULL(NextEstimateNum, 1)
  				,@NumPrefix =		ISNULL(EstimateNumPrefix, '')
				,@NumPlaces =		ISNULL(EstimateNumPlaces, 6)
				,@TwoDigitPrefix = ISNULL(EstimateNumPrefixUseYear, 0)
		FROM	tPreference (NOLOCK) 
		WHERE	CompanyKey = @_iCompanyKey
				
		Select @NumPrefix = @NumPrefix+LTRIM(@EstimateNumSep)
	END

	-- Project Number and Next Number for the Project (2 Digit year not used)
	IF @NextEstimateNumStyle = 2
	BEGIN
		SELECT	@NumPlaces = ISNULL(EstimateNumPlaces, 3)
		FROM	tPreference (NOLOCK) 
		WHERE	CompanyKey = @_iCompanyKey
	
		IF ISNULL(@_iProjectKey, 0) > 0
		BEGIN
			SELECT	@NumPrefix = RTrim(ProjectNumber)
			FROM	tProject (NOLOCK) 
			WHERE	ProjectKey = @_iProjectKey

			SELECT	@_lNextTranNo = ISNULL(Count(*), 1) + 1
			FROM	tEstimate (nolock) 
			WHERE	ProjectKey = @_iProjectKey

			IF LEN(LTRIM(RTRIM(@NumPrefix))) > 50 - @NumPlaces - 1
				Select @NumPrefix = LEFT(@NumPrefix, 50 - @NumPlaces - 1)
				Select @NumPrefix = @NumPrefix+LTRIM(@EstimateNumSep)

		END
		
		ELSE IF ISNULL(@_iCampaignKey, 0) > 0
		BEGIN
			SELECT	@NumPrefix = RTrim(CampaignID)
			FROM	tCampaign (NOLOCK) 
			WHERE	CampaignKey = @_iCampaignKey

			SELECT	@_lNextTranNo = ISNULL(Count(*), 1) + 1
			FROM	tEstimate (nolock) 
			WHERE	CampaignKey = @_iCampaignKey

			IF LEN(LTRIM(RTRIM(@NumPrefix))) > 50 - @NumPlaces - 1
				Select @NumPrefix = LEFT(@NumPrefix, 50 - @NumPlaces - 1)
				Select @NumPrefix = @NumPrefix+LTRIM(@EstimateNumSep)

		END

		ELSE IF ISNULL(@_iLeadKey, 0) > 0
		BEGIN
			-- We do not have an ID here, so use TranNo only
			SELECT	@_lNextTranNo = ISNULL(Count(*), 1) + 1
			FROM	tEstimate (nolock) 
			WHERE	LeadKey = @_iLeadKey
		
			-- And no prefix
			SELECT @NumPrefix = ''
			
		END
				
	END

		
	SELECT @_lTempTranNo = CONVERT(VARCHAR(200), @_lNextTranNo)
	IF LEN(@_lTempTranNo) > @NumPlaces
	BEGIN
		SELECT @NumPlaces = LEN(@_lTempTranNo)
		
		UPDATE tPreference
		SET    EstimateNumPlaces = @NumPlaces
		WHERE  CompanyKey = @_iCompanyKey  
		
	END
			   
	/* loop until unused tran number found */
 
	WHILE( 1=1 )
	BEGIN
	
		SELECT @_lNextTranNoC = CONVERT(CHAR(100), @_lNextTranNo)
		SELECT @_lTempTranNo = @Zeroes +LTRIM(RTRIM(@_lNextTranNoC))
		SELECT @_lNextTranNoPC = RIGHT(@_lTempTranNo, @NumPlaces)
			
		IF @NumPrefix <> '' 
			SELECT @_lNextTranNoPC = @NumPrefix+@_lNextTranNoPC	
					
		IF @NextEstimateNumStyle = 1
		BEGIN				
			-- Global	
			/* see if next tran number already exists in tran log */
			IF EXISTS (SELECT 1 FROM tEstimate e (NOLOCK) 
						WHERE e.EstimateNumber in (@_lNextTranNoC, @_lNextTranNoPC) 
						AND   e.CompanyKey = @_iCompanyKey)
				SELECT @NumUsed = 1
			ELSE
				SELECT @NumUsed = 0		
		END
		ELSE
		BEGIN
			-- By Project					
			/* see if next tran number already exists in tran log */
			IF ISNULL(@_iProjectKey, 0) > 0
			BEGIN
			IF EXISTS (SELECT 1 FROM tEstimate e (NOLOCK) inner join tProject p (nolock) on e.ProjectKey= p.ProjectKey
						WHERE e.EstimateNumber in (@_lNextTranNoC, @_lNextTranNoPC) 
						AND   p.CompanyKey = @_iCompanyKey
						AND   p.ProjectKey = @_iProjectKey)
				SELECT @NumUsed = 1
			ELSE
				SELECT @NumUsed = 0
			END
			
			-- By Campaign					
			/* see if next tran number already exists in tran log */
			IF ISNULL(@_iCampaignKey, 0) > 0
			BEGIN
			IF EXISTS (SELECT 1 FROM tEstimate e (NOLOCK) inner join tCampaign c (nolock) on e.CampaignKey= c.CampaignKey
						WHERE e.EstimateNumber in (@_lNextTranNoC, @_lNextTranNoPC) 
						AND   c.CompanyKey = @_iCompanyKey
						AND   c.CampaignKey = @_iCampaignKey)
				SELECT @NumUsed = 1
			ELSE
				SELECT @NumUsed = 0
			END
			
			-- By Lead					
			/* see if next tran number already exists in tran log */
			IF ISNULL(@_iLeadKey, 0) > 0
			BEGIN
			IF EXISTS (SELECT 1 FROM tEstimate e (NOLOCK) inner join tLead l (nolock) on e.LeadKey= l.LeadKey
						WHERE e.EstimateNumber in (@_lNextTranNoC, @_lNextTranNoPC) 
						AND   l.CompanyKey = @_iCompanyKey
						AND   l.LeadKey = @_iLeadKey)
				SELECT @NumUsed = 1
			ELSE
				SELECT @NumUsed = 0
			END
					
		END
				
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
			IF @NextEstimateNumStyle = 1
				UPDATE tPreference
				SET    NextEstimateNum = @_lNextTranNo
				WHERE	CompanyKey = @_iCompanyKey
			
			SELECT	@_oNextTranNo = ltrim(rtrim(@_oNextTranNo))
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
	
	RETURN

GO


