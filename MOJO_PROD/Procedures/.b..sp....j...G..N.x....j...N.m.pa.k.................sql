USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetNextProjectNumSpark]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectGetNextProjectNumSpark]
(

	@_iCompanyKey		 INTEGER,
	@_iClientKey		 INTEGER,
	@_iProjectTypeKey	 INTEGER,
	@_iClientProductKey  INTEGER,
	@_iModelYear		 VARCHAR(10), -- from 0 to 99
	@_oRetVal			 INTEGER OUTPUT,
	@_oNextTranNo 		 VARCHAR(100) OUTPUT
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/08/13 GHL 10.565 (167857) Customization for Spark. They have their own project number system
  || 03/14/13 GHL 10.565 The Project Code is a function of the Model Year (not Nameplate + ModelYear)
  */

  -- vars to pull our stuff
  declare @CustomerID varchar(50)
  declare @ProductName varchar(300)
  declare @ProjectNumPrefix varchar(20)

  -- working vars
  declare @Zeroes VARCHAR(100)
  declare @Spaces VARCHAR(100)
  declare @NumPlaces INTEGER -- Number of places for the tran no
  declare @NumUsed INTEGER 
  
  declare @_lNextTranNo INTEGER /* local work variable */
  declare @_lNextTranNoC VARCHAR(100)		/* character version of tran number */		
  declare @_lNextTranNoPC VARCHAR(100)		/* character version of tran number padded with 0's on the left */
  declare @_lTempTranNo VARCHAR(200)
  
  -- parts of the Spark project number
  declare @ClientMarket varchar(4) -- JGGL
  declare @Nameplate varchar(4) -- XF or XKRS
  declare @ModelYear varchar(2)
  declare @MediaType varchar(3) -- TRM
  declare @NameplateModelYear varchar(10) -- The Project code is based on that	

  select @_oRetVal = 0
  select @_oNextTranNo = NULL
  select @Zeroes = '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  select @Spaces = '          '
  select @NumPlaces = 4 -- 4 decimals for the project number 

  select @CustomerID = CustomerID from tCompany (nolock) where CompanyKey = @_iClientKey
  select @ProductName = ProductName from tClientProduct (nolock) where ClientProductKey = @_iClientProductKey
  select @ProjectNumPrefix = ProjectNumPrefix from tProjectType (nolock) where ProjectTypeKey = @_iProjectTypeKey

  select @CustomerID = upper(isnull(@CustomerID, ''))
  select @ProductName = upper(isnull(@ProductName, ''))
  select @ProjectNumPrefix = upper(isnull(@ProjectNumPrefix, ''))
  	
  -- Should be 4
  select @ClientMarket = LEFT(@CustomerID, 4)
  if len(@ClientMarket) <> 4
	select @ClientMarket = LEFT(@ClientMarket + @Spaces, 4)
  
  -- The name plate is 2 or 4 
  select @Nameplate = LEFT(@ProductName, 4)

   -- Should be 3
  select @MediaType = LEFT(@ProjectNumPrefix, 3)
   if len(@MediaType) <> 3
	select @MediaType = LEFT(@MediaType + @Spaces, 3)

  select @ModelYear =  CONVERT(VARCHAR(2), @_iModelYear)
  if len(@ModelYear) = 1
	select @ModelYear = '0' + @ModelYear

  select @NameplateModelYear = @Nameplate + @ModelYear -- Entity to calc project number from, ex: XJ12
  
  --select @ClientMarket as ClientMarket, @Nameplate as Nameplate, @ModelYear as ModelYear, @NameplateModelYear as NameplateModelYear, @MediaType as MediaType
  
  create table #project_codes (ProjectNumber varchar(1000) null, ProjectCode varchar(4) null, TranNo int null)
  
  -- get all the project codes for the Model Year (not Nameplate + Model Year)
  insert #project_codes (ProjectNumber)
  select ProjectNumber
  from   tProject (nolock)
  where  CompanyKey = @_iCompanyKey
  --and    dbo.fSparkParseProjectNumber(ProjectNumber, 'NameplateModelYear') = @NameplateModelYear
  and    dbo.fSparkParseProjectNumber(ProjectNumber, 'ModelYear') = @ModelYear


  update #project_codes 
  set    ProjectCode = dbo.fSparkParseProjectNumber(ProjectNumber, 'ProjectCode')

  update #project_codes 
  set    TranNo = 1
  where  isnumeric(ProjectCode) = 0

  update #project_codes 
  set    TranNo = cast (ProjectCode as int)
  where  isnumeric(ProjectCode) = 1

  if ((select count(*) from #project_codes) = 0) 
	select @_lNextTranNo = 1
  else		
  begin
	  select @_lNextTranNo = max(TranNo) 
	  from #project_codes

	  select @_lNextTranNo = @_lNextTranNo + 1
  end	

--select * from #project_codes order by TranNo
--select @ModelYear
--select @_lNextTranNo
   
  	/* loop until unused tran number found */
	WHILE( 1=1 )
	BEGIN

		-- Protection when @NumPlaces too small
		IF LEN(@_lNextTranNo) > @NumPlaces
		BEGIN
			SELECT	@_oRetVal = 2
			RETURN
		END
	
		SELECT @_lNextTranNoC = CONVERT(CHAR(100), @_lNextTranNo)
		SELECT @_lTempTranNo = @Zeroes +LTRIM(RTRIM(@_lNextTranNoC))
		SELECT @_lNextTranNoPC = RIGHT(@_lTempTranNo, @NumPlaces)
		
		SELECT @_lNextTranNoPC = @ClientMarket + '-' + @Nameplate + @ModelYear + '-' + @MediaType + @_lNextTranNoPC
		
		/* see if next tran number already exists in tran log...removed nolock 06/17/11 GHL */
		/* removed checking of @_lNextTranNoC */
		IF EXISTS (SELECT 1 FROM tProject WHERE ProjectNumber IN (@_lNextTranNoPC) AND CompanyKey = @_iCompanyKey)
			SELECT @NumUsed = 1
		ELSE
			SELECT @NumUsed = 0		
		
		IF @NumUsed = 0

		BEGIN
			/* not found, return as valid choice */
			SELECT	@_oNextTranNo = @_lNextTranNoPC 

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


	/*
	Testing

	declare @CompanyKey int
	declare @ClientKey int
	declare @ProjectTypeKey int
	declare @ClientProductKey int
	declare @ModelYear int
	declare @RetVal int
	declare @NextTranNo VARCHAR(100)
	
	select @CompanyKey = 100
	select @ClientKey = 211
	select @ProjectTypeKey = 17
	select @ClientProductKey = 1
	select @ModelYear = 12

	EXEC sptProjectGetNextProjectNumSpark
		@CompanyKey,
		@ClientKey,
		@ProjectTypeKey,
		@ClientProductKey,
		@ModelYear,
		@RetVal OUTPUT,
		@NextTranNo OUTPUT

	select @RetVal, @NextTranNo

	*/
GO
