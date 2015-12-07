use mojo_prod
go

Alter PROCEDURE intProjectCreate
	(
	@job_number varchar(50)
	,@job_title varchar(100)
	,@parent_job varchar(200)
	,@sub_prod_code varchar(300)
	,@sub_prod_group varchar(300)
	,@client_id varchar(50)
	,@ProjectTypeName varchar(100) = null
	,@descr varchar(30) 
	)
AS
	SET NOCOUNT ON

  /*
  || When     Who Rel    What
  || 11/14/11 GHL 10.550 Creation for the Integer Group
  ||                     Errors are:
  ||                     -1 The project number already exists
  ||                     -2 The client specified by @client_id cannot be found
  ||                     -3 The project number APS_BASE cannot be found
  ||                     -4 Error creating the project, contact WMJ
  ||                     -5 Invalid project type (added 04/25/12)
  ||                     Success: Returns project key
  ||
  
 execute mojo_prod.dbo.intProjectCreate @job_number = '06842715APS',
	@job_title = '15_Wrigley Finance Mgmt',
	@parent_job = '06842715AGY',
	@sub_prod_code = 'WGNR',
	@sub_prod_group = 'MARS',
	@client_id = '1WRGLY',
	--@ProjectTypeName = '',
	@descr = 'Wrigley General - Ret'
	
execute mojo_prod.dbo.intProjectCreate @job_number = '06821415APS',
	@job_title = 'RA_Jan_Football_Game_Day_16',
	@parent_job = '06821415AGY',
	@sub_prod_code = 'RIT',
	@sub_prod_group = 'PG',
	@client_id = '1PGRTE',
	--@ProjectTypeName = '',
	@descr = 'P&G Rite Aid - RET'
  
  
  
  || 12/08/11 GHL 10.550 If the stored procedure is called after creation of the project
  ||                     Just update the job title (ProjectName in WMJ)
  ||
  || 04/25/12 GHL 10.555 Added project type name parameter + new error -5 (invalid project type)
  ||                     If project type name is null, do not validate
  || 09/02/12 GWG 10.559 Look up a template by ProjectTypeName, otherwise use default
  || 04/18/13 GHL 10.566 Added param ModelYear to sptProjectCopy
  || 06/18/13 GHL 10.569 (181721) Added param CampaignKey to sptProjectCopy
  || 07/22/13 GHL 10.569 Removed mapping to project type at Mark Campbell's request
  || 12/30/14 WDF 10.587 (237583) Added param DefaultRetainerKey to sptProjectCopy
  || 11/24/15 MMM		 (34633) Adding input for product description.
  */

	-- Hardcoded values
	declare @CompanyKey int						select @CompanyKey = 1
	declare @kTemplateProject varchar(50)		select @kTemplateProject = 'APS_BASE'

	-- Error constants
	declare @kErrDuplicateProjectNumber	int		select @kErrDuplicateProjectNumber = -1 -- obsolete due to 12/08/11 change
	declare @kErrInvalidClient	int				select @kErrInvalidClient = -2
	declare @kErrTemplateProject int			select @kErrTemplateProject = -3
	declare @kErrCreatingProject int			select @kErrCreatingProject = -4
	declare @kErrInvalidProjectType int			select @kErrInvalidProjectType = -5
	 
	-- Main variables for project creation
	declare @ProjectName varchar(100)
	declare @ProjectNumber varchar(50)
	declare @ClientProjectNumber varchar(200)
	declare @ClientDivisionName varchar(300)
	declare @ClientProductName varchar(300)
	declare @CustomerID varchar(50)
	declare @description varchar(30)

	declare @ClientKey int
	declare @ClientDivisionKey int
	declare @ClientProductKey int
	declare @TemplateProjectKey int
	declare @ProjectStatusKey int
	declare @ProjectTypeKey int
	declare @NewProjectKey int
	declare @RetVal int
	 
	 -- trim everything
	 select @job_number =ltrim(rtrim(@job_number))
	 select @job_title =ltrim(rtrim(@job_title))
	 select @parent_job =ltrim(rtrim(@parent_job))
	 select @sub_prod_code =ltrim(rtrim(@sub_prod_code))
	 select @sub_prod_group =ltrim(rtrim(@sub_prod_group))
	 select @client_id =ltrim(rtrim(@client_id))
	 select @ProjectTypeName =ltrim(rtrim(@ProjectTypeName))
	 select @descr = ltrim(rtrim(@descr))

	-- mapping to WMJ
	select @ProjectNumber = @sub_prod_code + @job_number
	select @ProjectName = @job_title
	select @ClientProjectNumber = @parent_job 
	select @ClientDivisionName = @sub_prod_group
	select @ClientProductName = @sub_prod_code
	select @CustomerID = @client_id
	select @description = @descr


	/**************************************************
	 * If project exists, update job title/project name
	 **************************************************/

	select @NewProjectKey = ProjectKey
	from  mojo_prod.dbo.tProject (nolock)
	where upper(ProjectNumber) = upper(@ProjectNumber)
		and   CompanyKey = @CompanyKey
	
	if isnull(@NewProjectKey, 0) > 0		
	begin
		update mojo_prod.dbo.tProject
			set    ProjectName = @ProjectName,
				[description] = @description
		where  ProjectKey = @NewProjectKey

		return @NewProjectKey
	end

	/***************************
	 * First perform validations
	 ***************************/

	-- validate client
	select @ClientKey = CompanyKey 
	from  mojo_prod.dbo.tCompany (nolock) 
	where OwnerCompanyKey = @CompanyKey
	and   upper(CustomerID) = upper(@CustomerID) 

	if @@ROWCOUNT = 0
		return @kErrInvalidClient
	
	-- validate template project we have to copy tasks from
	IF exists(select ProjectKey 
				from  tProject (nolock) 
				where CompanyKey = @CompanyKey 
					and upper(ProjectNumber) = upper(@ProjectTypeName))
		select @TemplateProjectKey = ProjectKey
		from   mojo_prod.dbo.tProject (nolock)
		where  CompanyKey = @CompanyKey
		and    upper(ProjectNumber) = upper(@ProjectTypeName)
	ELSE
		select @TemplateProjectKey = ProjectKey
		from   mojo_prod.dbo.tProject (nolock)
		where  CompanyKey = @CompanyKey
		and    upper(ProjectNumber) = upper(@kTemplateProject)
		
		
	if @@ROWCOUNT = 0
		return @kErrTemplateProject

/* commented out at Mark Campbell's request 7/22/13

	-- validate project type
	if isnull(@ProjectTypeName, '') <> ''
	begin
	    select @ProjectTypeKey = ProjectTypeKey
	    from   tProjectType (nolock)
	    where  CompanyKey = @CompanyKey
	    and    upper(ProjectTypeName) = upper(@ProjectTypeName)

	    if @@ROWCOUNT = 0
		    return @kErrInvalidProjectType
	end
*/

                  /******************************
	 * Then get division and product
	 *******************************/

	if len(@ClientDivisionName) > 0
	begin
		select @ClientDivisionKey = ClientDivisionKey
		from   mojo_prod.dbo.tClientDivision (nolock)
		where  CompanyKey = @CompanyKey
		and    ClientKey = @ClientKey
		and    upper(DivisionName) = upper(@ClientDivisionName)

		if @@ROWCOUNT = 0
			exec sptClientDivisionInsert @CompanyKey,@ClientKey,@ClientDivisionName, null, null, 1, @ClientDivisionKey output
	end

	if len(@ClientProductName) > 0
	begin
		select @ClientProductKey = ClientProductKey
		from   mojo_prod.dbo.tClientProduct (nolock)
		where  CompanyKey = @CompanyKey
		and    ClientKey = @ClientKey
		and    upper(ProductName) = upper(@ClientProductName)
		and    (@ClientDivisionKey is null or ClientDivisionKey = @ClientDivisionKey)

		if @@ROWCOUNT = 0
			exec sptClientProductInsert @CompanyKey,@ClientKey,@ClientProductName, @ClientDivisionKey, 1, @ClientProductKey output
	end

	-- select first available project status, because this is required by WMJ
	declare @DisplayOrder int
	select @DisplayOrder = min(DisplayOrder) 
	from   mojo_prod.dbo.tProjectStatus (nolock)
	where  CompanyKey = @CompanyKey
	and    DisplayOrder is not null
	and    isnull(IsActive, 0) = 1
	and    isnull(Locked, 0) = 0

	select @ProjectStatusKey = ProjectStatusKey
	from   mojo_prod.dbo.tProjectStatus (nolock)
	where  CompanyKey = @CompanyKey
	and    DisplayOrder = @DisplayOrder

	exec @RetVal = sptProjectCopy
		null -- UserKey
		,@ProjectName
		,@ProjectNumber
		,@CompanyKey
		,@ProjectStatusKey
		,@ProjectTypeKey 
		,@ClientDivisionKey
		,@ClientProductKey
		,null -- OfficeKey
		,null -- GLCompanyKey
		,null -- ClassKey
		,@ClientKey
		,null -- RequestKey
		,@TemplateProjectKey
		,0    -- CopyEstimate
		,0    -- CopyFrom 0:From Project
		,null -- EstimateInternalApprover
		,null -- TeamKey
		,null -- LeadKey
		,null -- ProjectColor
		,null -- ModelYear
		,null -- CampaignKey
		,null -- DefaultRetainerKey
		,@Description
		,@NewProjectKey output
		
		

	if @RetVal < 0
		return @kErrCreatingProject

	return @NewProjectKey
