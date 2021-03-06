USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastCreateBudget]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastCreateBudget]
	(
	@ForecastKey int
	,@GLBudgetKey int = 0
	,@Gross int = 1
	,@Net int = 0
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 11/26/12  GHL 10.562  Created for revenue forecast
||                       This SP creates a financial budget for the forecast
|| 11/27/12  GHL 10.562  If StartMonth <> 1, leave Month1 = 0, etc (do not wrap around)
||                       Added update of existing GLBudgetKey
|| 06/27/13  GHL 10.5.6.9 (182036) Added support for Net values in tForecastDetailItem     
|| 08/29/13  GHL 10.5.7.1  Testing by Ron Ause. When we modify an existing budget
||                         only delete specific GLaccounts in budget which are also in the forecast
||                         then creates them back from the forecast, rather than deleting the whole
||                         budget details and recreating them          
*/

	SET NOCOUNT ON 

	-- contants
	declare @kErrInsertBudget int			select @kErrInsertBudget = -1
	declare @kErrInsertBudgetDetail int		select @kErrInsertBudgetDetail = -2
	declare @kErrDeleteBudgetDetail int		select @kErrDeleteBudgetDetail = -3

	-- Error out if nothing is selected
	if @Gross = 0 and @Net = 0
		return @kErrInsertBudget

	-- vars
	declare @CompanyKey int
	declare @ForecastName varchar(200)
	declare @StartMonth int
	declare @NameCount int
	declare @NameLength int
	declare @Error int

	select @ForecastName = ForecastName
	      ,@CompanyKey = CompanyKey
		  ,@StartMonth = StartMonth
	from   tForecast (nolock)
	where  ForecastKey = @ForecastKey

	declare @DefaultSalesAccountKey int, @ForecastCostAccountKey int
	select @DefaultSalesAccountKey = DefaultSalesAccountKey 
	      ,@ForecastCostAccountKey = ForecastCostAccountKey
	from tPreference (nolock) 
	where CompanyKey = @CompanyKey

	-- cannot have blanks
	if @ForecastCostAccountKey is null
		select @ForecastCostAccountKey = @DefaultSalesAccountKey

	-- Budget name is varchar(100), we need some room for (2), (3), etc...
	select @ForecastName = substring(@ForecastName, 1, 95)
	select @NameLength = Len(@ForecastName)

	select @NameCount = count(*) from tGLBudget (nolock) 
	where CompanyKey = @CompanyKey 
	and substring(BudgetName, 1, @NameLength) = @ForecastName
	if @NameCount > 0
	begin
		select @NameCount = @NameCount + 1
		select @ForecastName = @ForecastName + ' (' + cast(@NameCount as varchar(200)) + ')' 
	end

	create table #forecastdetail (
		Entity varchar(50) null -- Added to support Net values
		,AtNet int null         -- Added to support Net values  

		,GLAccountKey int null
		,ClassKey int null
		,ClientKey int null
		,GLCompanyKey int null
		,OfficeKey int null
		,DepartmentKey int null

		-- From forecast
		,Month1 money null
		,Month2 money null
		,Month3 money null
		,Month4 money null
		,Month5 money null
		,Month6 money null
		,Month7 money null
		,Month8 money null
		,Month9 money null
		,Month10 money null
		,Month11 money null
		,Month12 money null

		-- To Budget
		,BMonth1 money null
		,BMonth2 money null
		,BMonth3 money null
		,BMonth4 money null
		,BMonth5 money null
		,BMonth6 money null
		,BMonth7 money null
		,BMonth8 money null
		,BMonth9 money null
		,BMonth10 money null
		,BMonth11 money null
		,BMonth12 money null

		,UpdateFlag int null
	)

	create table #forecastdetailsumm (

		GLAccountKey int null
		,ClassKey int null
		,ClientKey int null
		,GLCompanyKey int null
		,OfficeKey int null
		,DepartmentKey int null

		-- From forecast
		,Month1 money null
		,Month2 money null
		,Month3 money null
		,Month4 money null
		,Month5 money null
		,Month6 money null
		,Month7 money null
		,Month8 money null
		,Month9 money null
		,Month10 money null
		,Month11 money null
		,Month12 money null

		-- To Budget
		,BMonth1 money null
		,BMonth2 money null
		,BMonth3 money null
		,BMonth4 money null
		,BMonth5 money null
		,BMonth6 money null
		,BMonth7 money null
		,BMonth8 money null
		,BMonth9 money null
		,BMonth10 money null
		,BMonth11 money null
		,BMonth12 money null

		,UpdateFlag int null
	)

	-- Get GLCompanyKey and ClientKey from tForecastDetail, others from tForecastDetailItem 
	insert #forecastdetail (
		Entity, AtNet, GLAccountKey,ClassKey,ClientKey,GLCompanyKey,OfficeKey,DepartmentKey
		,Month1,Month2,Month3,Month4,Month5,Month6,Month7,Month8,Month9,Month10,Month11,Month12
		)
	select fdi.Entity, isnull(fdi.AtNet,0), fdi.GLAccountKey, fdi.ClassKey, fd.ClientKey,fd.GLCompanyKey,fdi.OfficeKey,fdi.DepartmentKey,
			(fdi.Month1 * fd.Probability) / 100.0000,
			(fdi.Month2 * fd.Probability) / 100.0000,
			(fdi.Month3 * fd.Probability) / 100.0000,
			(fdi.Month4 * fd.Probability) / 100.0000,
			(fdi.Month5 * fd.Probability) / 100.0000,
			(fdi.Month6 * fd.Probability) / 100.0000,
			(fdi.Month7 * fd.Probability) / 100.0000,
			(fdi.Month8 * fd.Probability) / 100.0000,
			(fdi.Month9 * fd.Probability) / 100.0000,
			(fdi.Month10 * fd.Probability) / 100.0000,
			(fdi.Month11 * fd.Probability) / 100.0000,
			(fdi.Month12 * fd.Probability) / 100.0000
	from   tForecastDetail fd (nolock)
	inner join tForecastDetailItem fdi (nolock) on fd.ForecastDetailKey = fdi.ForecastDetailKey 
	where  fd.ForecastKey = @ForecastKey

	-- In tForecastDetailItem, Net values are stored negative, we have to flip the sign of the net values
	
	/*  Gross              Net          Action
		0                  0            impossible, the UI does not allow for that
		0                  1            delete gross
		1                  0            delete net
		1                  1            do nothing, take all
	*/

	-- if net only, delete gross for budget data only
	if @Gross = 0 
		delete #forecastdetail where AtNet = 0 --and Entity in ('tEstimateTask', 'tEstimateTaskLabor', 'tEstimateTaskExpense', 'tLead-Labor', 'tLead-Production', 'tLead-Media') 

	-- if gross only, delete net for budget data only, only budget data has AtNet = 1
	if  @Net = 0
		delete #forecastdetail where AtNet = 1 -- and Entity in ('tEstimateTask', 'tEstimateTaskLabor', 'tEstimateTaskExpense') 

	update #forecastdetail
	set Month1 = -1 * Month1, Month2 = -1 * Month2, Month3 = -1 * Month3, Month4 = -1 * Month4
	   ,Month5 = -1 * Month5, Month6 = -1 * Month6, Month7 = -1 * Month7, Month8 = -1 * Month8
	   ,Month9 = -1 * Month9, Month10 = -1 * Month10, Month11 = -1 * Month11, Month12 = -1 * Month12
	where AtNet = 1

	-- Items,services and retainers do not have any tForecastDetailItem, so do not join with tForecastDetailItem
	if @Gross = 1
	insert #forecastdetail (
		GLAccountKey,ClassKey,ClientKey,GLCompanyKey,OfficeKey,DepartmentKey
		,Month1,Month2,Month3,Month4,Month5,Month6,Month7,Month8,Month9,Month10,Month11,Month12
		)
	select i.SalesAccountKey, i.ClassKey, fd.ClientKey,fd.GLCompanyKey,fd.OfficeKey,i.DepartmentKey,
			(fd.Month1 * fd.Probability) / 100.0000,
			(fd.Month2 * fd.Probability) / 100.0000,
			(fd.Month3 * fd.Probability) / 100.0000,
			(fd.Month4 * fd.Probability) / 100.0000,
			(fd.Month5 * fd.Probability) / 100.0000,
			(fd.Month6 * fd.Probability) / 100.0000,
			(fd.Month7 * fd.Probability) / 100.0000,
			(fd.Month8 * fd.Probability) / 100.0000,
			(fd.Month9 * fd.Probability) / 100.0000,
			(fd.Month10 * fd.Probability) / 100.0000,
			(fd.Month11 * fd.Probability) / 100.0000,
			(fd.Month12 * fd.Probability) / 100.0000
	from   tForecastDetail fd (nolock)
		inner join tItem i (nolock) on fd.EntityKey = i.ItemKey
	where  fd.ForecastKey = @ForecastKey
	and    fd.Entity = 'tItem'

	if @Gross = 1
	insert #forecastdetail (
		GLAccountKey,ClassKey,ClientKey,GLCompanyKey,OfficeKey,DepartmentKey
		,Month1,Month2,Month3,Month4,Month5,Month6,Month7,Month8,Month9,Month10,Month11,Month12
		)
	select s.GLAccountKey, s.ClassKey, fd.ClientKey,fd.GLCompanyKey,fd.OfficeKey, s.DepartmentKey,
			(fd.Month1 * fd.Probability) / 100.0000,
			(fd.Month2 * fd.Probability) / 100.0000,
			(fd.Month3 * fd.Probability) / 100.0000,
			(fd.Month4 * fd.Probability) / 100.0000,
			(fd.Month5 * fd.Probability) / 100.0000,
			(fd.Month6 * fd.Probability) / 100.0000,
			(fd.Month7 * fd.Probability) / 100.0000,
			(fd.Month8 * fd.Probability) / 100.0000,
			(fd.Month9 * fd.Probability) / 100.0000,
			(fd.Month10 * fd.Probability) / 100.0000,
			(fd.Month11 * fd.Probability) / 100.0000,
			(fd.Month12 * fd.Probability) / 100.0000	
	from   tForecastDetail fd (nolock)
		inner join tService s (nolock) on fd.EntityKey = s.ServiceKey
	where  fd.ForecastKey = @ForecastKey
	and    fd.Entity = 'tService'

	if @Gross = 1
	insert #forecastdetail (
		GLAccountKey,ClassKey,ClientKey,GLCompanyKey,OfficeKey,DepartmentKey
		,Month1,Month2,Month3,Month4,Month5,Month6,Month7,Month8,Month9,Month10,Month11,Month12
		)
	select r.SalesAccountKey, r.ClassKey, fd.ClientKey,fd.GLCompanyKey, fd.OfficeKey, -1,
			(fd.Month1 * fd.Probability) / 100.0000,
			(fd.Month2 * fd.Probability) / 100.0000,
			(fd.Month3 * fd.Probability) / 100.0000,
			(fd.Month4 * fd.Probability) / 100.0000,
			(fd.Month5 * fd.Probability) / 100.0000,
			(fd.Month6 * fd.Probability) / 100.0000,
			(fd.Month7 * fd.Probability) / 100.0000,
			(fd.Month8 * fd.Probability) / 100.0000,
			(fd.Month9 * fd.Probability) / 100.0000,
			(fd.Month10 * fd.Probability) / 100.0000,
			(fd.Month11 * fd.Probability) / 100.0000,
			(fd.Month12 * fd.Probability) / 100.0000	
	from   tForecastDetail fd (nolock)
		inner join tRetainer r (nolock) on fd.EntityKey = r.RetainerKey
	where  fd.ForecastKey = @ForecastKey
	and    fd.Entity = 'tRetainer'

	if @Net = 1
	insert #forecastdetail (
		GLAccountKey,ClassKey,ClientKey,GLCompanyKey,OfficeKey,DepartmentKey
		,Month1,Month2,Month3,Month4,Month5,Month6,Month7,Month8,Month9,Month10,Month11,Month12
		)
	select @ForecastCostAccountKey, r.ClassKey, fd.ClientKey,fd.GLCompanyKey, fd.OfficeKey, -1,   -- we use @ForecastCostAccountKey
			-1 * (fd.Month1N * fd.Probability) / 100.0000,
			-1 * (fd.Month2N * fd.Probability) / 100.0000,
			-1 * (fd.Month3N * fd.Probability) / 100.0000,
			-1 * (fd.Month4N * fd.Probability) / 100.0000,
			-1 * (fd.Month5N * fd.Probability) / 100.0000,
			-1 * (fd.Month6N * fd.Probability) / 100.0000,
			-1 * (fd.Month7N * fd.Probability) / 100.0000,
			-1 * (fd.Month8N * fd.Probability) / 100.0000,
			-1 * (fd.Month9N * fd.Probability) / 100.0000,
			-1 * (fd.Month10N * fd.Probability) / 100.0000,
			-1 * (fd.Month11N * fd.Probability) / 100.0000,
			-1 * (fd.Month12N * fd.Probability) / 100.0000	
	from   tForecastDetail fd (nolock)
		inner join tRetainer r (nolock) on fd.EntityKey = r.RetainerKey
	where  fd.ForecastKey = @ForecastKey
	and    fd.Entity = 'tRetainer'

	-- we need at least a GL Account, anything else can be null (or -1)
	update #forecastdetail
	set    GLAccountKey = @DefaultSalesAccountKey
	where  isnull(GLAccountKey, 0) = 0
	

	update #forecastdetail
	set    ClassKey			= case when isnull(ClassKey, 0) =0		then -1 else ClassKey end
	      ,GLCompanyKey		= case when isnull(GLCompanyKey, 0) =0	then -1 else GLCompanyKey end
		  ,OfficeKey		= case when isnull(OfficeKey, 0) =0		then -1 else OfficeKey end
		  ,DepartmentKey	= case when isnull(DepartmentKey, 0) =0 then -1 else DepartmentKey end

		  ,ClientKey	= isnull(ClientKey, 0) 


	delete #forecastdetail
	where  (isnull(Month1, 0) + isnull(Month2, 0) + isnull(Month3, 0) + isnull(Month4, 0) + isnull(Month5, 0) + isnull(Month6, 0)
	+ isnull(Month7, 0) + isnull(Month8, 0) + isnull(Month9, 0) + isnull(Month10, 0) + isnull(Month11, 0) + isnull(Month12, 0))
	= 0


	if @StartMonth = 1 -- subtract 0, BMonth1= Month1
		update #forecastdetail
		set    BMonth1 = Month1,BMonth2= Month2,BMonth3= Month3,BMonth4=Month4,BMonth5=Month5,BMonth6=Month6
		      ,BMonth7 = Month7,BMonth8= Month8,BMonth9= Month9,BMonth10=Month10,BMonth11=Month11,BMonth12=Month12 
	if @StartMonth = 2 -- subtract 1, BMonth2= Month1
		update #forecastdetail
		--set    BMonth1 = Month12,BMonth2= Month1,BMonth3= Month2,BMonth4=Month3,BMonth5=Month4,BMonth6=Month5
		set    BMonth1 = 0,BMonth2= Month1,BMonth3= Month2,BMonth4=Month3,BMonth5=Month4,BMonth6=Month5
		      ,BMonth7 = Month6,BMonth8= Month7,BMonth9= Month8,BMonth10=Month9,BMonth11=Month10,BMonth12=Month11 
	else if @StartMonth = 3 -- subtract 2, BMonth3= Month1
		update #forecastdetail
		--set    BMonth1 = Month11,BMonth2= Month12,BMonth3= Month1,BMonth4=Month2,BMonth5=Month3,BMonth6=Month4
		set    BMonth1 = 0,BMonth2= 0,BMonth3= Month1,BMonth4=Month2,BMonth5=Month3,BMonth6=Month4
		      ,BMonth7 = Month5,BMonth8= Month6,BMonth9= Month7,BMonth10=Month8,BMonth11=Month9,BMonth12=Month10 
	else if @StartMonth = 4 -- subtract 3, BMonth4= Month1
		update #forecastdetail
		--set    BMonth1 = Month10,BMonth2= Month11,BMonth3= Month12,BMonth4=Month1,BMonth5=Month2,BMonth6=Month3
		set    BMonth1 = 0,BMonth2= 0,BMonth3= 0,BMonth4=Month1,BMonth5=Month2,BMonth6=Month3
		      ,BMonth7 = Month4,BMonth8= Month5,BMonth9= Month6,BMonth10=Month7,BMonth11=Month8,BMonth12=Month9 
	else if @StartMonth = 5 -- subtract 4, BMonth5= Month1
		update #forecastdetail
		--set    BMonth1 = Month9,BMonth2= Month10,BMonth3= Month11,BMonth4=Month12,BMonth5=Month1,BMonth6=Month2
		set    BMonth1 = 0,BMonth2= 0,BMonth3= 0,BMonth4=0,BMonth5=Month1,BMonth6=Month2
		      ,BMonth7 = Month3,BMonth8= Month4,BMonth9= Month5,BMonth10=Month6,BMonth11=Month7,BMonth12=Month8
	else if @StartMonth = 6 -- subtract 5, BMonth6= Month1
		update #forecastdetail
		--set    BMonth1 = Month8,BMonth2= Month9,BMonth3= Month10,BMonth4=Month11,BMonth5=Month12,BMonth6=Month1
		set    BMonth1 = 0,BMonth2= 0,BMonth3= 0,BMonth4=0,BMonth5=0,BMonth6=Month1
		      ,BMonth7 = Month2,BMonth8= Month3,BMonth9= Month4,BMonth10=Month5,BMonth11=Month6,BMonth12=Month7

	else if @StartMonth = 7 -- subtract 6, BMonth7= Month1
		update #forecastdetail
		--set    BMonth1 = Month7,BMonth2= Month8,BMonth3= Month9,BMonth4=Month10,BMonth5=Month11,BMonth6=Month12
		set    BMonth1 = 0,BMonth2= 0,BMonth3= 0,BMonth4=0,BMonth5=0,BMonth6=0
		      ,BMonth7 = Month1,BMonth8= Month2,BMonth9= Month3,BMonth10=Month4,BMonth11=Month5,BMonth12=Month6
	else if @StartMonth = 8 -- subtract 7, BMonth8= Month1
		update #forecastdetail
		--set    BMonth1 = Month6,BMonth2= Month7,BMonth3= Month8,BMonth4=Month9,BMonth5=Month10,BMonth6=Month11
		set    BMonth1 = 0,BMonth2= 0,BMonth3= 0,BMonth4=0,BMonth5=0,BMonth6=0
		      ,BMonth7 = 0,BMonth8= Month1,BMonth9= Month2,BMonth10=Month3,BMonth11=Month4,BMonth12=Month5
	else if @StartMonth = 9 -- subtract 8, BMonth9= Month1
		update #forecastdetail
		--set    BMonth1 = Month5,BMonth2= Month6,BMonth3= Month7,BMonth4=Month8,BMonth5=Month9,BMonth6=Month10
		set    BMonth1 = 0,BMonth2= 0,BMonth3= 0,BMonth4=0,BMonth5=0,BMonth6=0
		      ,BMonth7 = 0,BMonth8= 0,BMonth9= Month1,BMonth10=Month2,BMonth11=Month3,BMonth12=Month4
	else if @StartMonth = 10 -- subtract 9, BMonth10= Month1
		update #forecastdetail
		--set    BMonth1 = Month4,BMonth2= Month5,BMonth3= Month6,BMonth4=Month7,BMonth5=Month8,BMonth6=Month9
		set    BMonth1 = 0,BMonth2= 0,BMonth3= 0,BMonth4=0,BMonth5=0,BMonth6=0
		      ,BMonth7 = 0,BMonth8= 0,BMonth9= 0,BMonth10=Month1,BMonth11=Month2,BMonth12=Month3
	else if @StartMonth = 11 -- subtract 10, BMonth11= Month1
		update #forecastdetail
		--set    BMonth1 = Month3,BMonth2= Month4,BMonth3= Month5,BMonth4=Month6,BMonth5=Month7,BMonth6=Month8
		set    BMonth1 = 0,BMonth2= 0,BMonth3= 0,BMonth4=0,BMonth5=0,BMonth6=0
		      ,BMonth7 = 0,BMonth8= 0,BMonth9= 0,BMonth10=0,BMonth11=Month1,BMonth12=Month2
	else if @StartMonth = 12 -- subtract 11, BMonth12= Month1
		update #forecastdetail
		--set    BMonth1 = Month2,BMonth2= Month3,BMonth3= Month4,BMonth4=Month5,BMonth5=Month6,BMonth6=Month7
		set    BMonth1 = 0,BMonth2= 0,BMonth3= 0,BMonth4=0,BMonth5=0,BMonth6=0
		      ,BMonth7 = 0,BMonth8= 0,BMonth9= 0,BMonth10=0,BMonth11=0,BMonth12=Month1
		
	-- cleanup, no null
	update #forecastdetail
	set    BMonth1 = isnull(BMonth1,0),BMonth2= isnull(BMonth2,0),BMonth3= isnull(BMonth3,0),BMonth4=isnull(BMonth4,0),BMonth5=isnull(BMonth5,0),BMonth6=isnull(BMonth6,0)
		    ,BMonth7 = isnull(BMonth7,0),BMonth8= isnull(BMonth8,0),BMonth9= isnull(BMonth9,0),BMonth10=isnull(BMonth10,0),BMonth11=isnull(BMonth11,0),BMonth12=isnull(BMonth12,0) 
	
if isnull(@GLBudgetKey, 0) = 0
begin			
	begin tran

	-- insert a gl budget for all accounts (type = 0, labor + expense)	
	insert tGLBudget (CompanyKey, BudgetType, BudgetName, Active)
	values (@CompanyKey, 0, @ForecastName, 1)
	
	select @GLBudgetKey = @@IDENTITY, @Error = @@ERROR

	if @Error <> 0
	begin
		rollback tran
		return @kErrInsertBudget
	end

	insert tGLBudgetDetail (GLBudgetKey, GLAccountKey, ClassKey, ClientKey, GLCompanyKey,OfficeKey, DepartmentKey
		,Month1,Month2,Month3,Month4,Month5,Month6,Month7,Month8,Month9,Month10,Month11,Month12
	)
	select @GLBudgetKey, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey
	,round(sum(BMonth1), 2)
	,round(sum(BMonth2), 2)
	,round(sum(BMonth3), 2)
	,round(sum(BMonth4), 2)
	,round(sum(BMonth5), 2)
	,round(sum(BMonth6), 2)
	,round(sum(BMonth7), 2)
	,round(sum(BMonth8), 2)
	,round(sum(BMonth9), 2)
	,round(sum(BMonth10), 2)
	,round(sum(BMonth11), 2)
	,round(sum(BMonth12), 2)
	from #forecastdetail
	group by GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey
			
	if @@ERROR <> 0
	begin
		return @kErrInsertBudgetDetail
		rollback tran
	end

	commit tran
end
else
begin
	-- the GL Budget exists, we must keep the old records/buckets if the forecast does not start in January

	-- summarize data
	insert #forecastdetailsumm (GLAccountKey, ClassKey, ClientKey, GLCompanyKey,OfficeKey, DepartmentKey
		,BMonth1,BMonth2,BMonth3,BMonth4,BMonth5,BMonth6,BMonth7,BMonth8,BMonth9,BMonth10,BMonth11,BMonth12
	)
	select GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey
	,sum(BMonth1)
	,sum(BMonth2)
	,sum(BMonth3)
	,sum(BMonth4)
	,sum(BMonth5)
	,sum(BMonth6)
	,sum(BMonth7)
	,sum(BMonth8)
	,sum(BMonth9)
	,sum(BMonth10)
	,sum(BMonth11)
	,sum(BMonth12)
	from #forecastdetail
	group by GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey

	-- much simpler version

	-- delete original budget detail recs for the GLAccountKey on the forecast
	delete tGLBudgetDetail where GLBudgetKey = @GLBudgetKey
	and    GLAccountKey in (select GLAccountKey from #forecastdetailsumm)

	-- now copy forecast to budget
	insert tGLBudgetDetail (GLBudgetKey, GLAccountKey, ClassKey, ClientKey, GLCompanyKey,OfficeKey, DepartmentKey
		,Month1,Month2,Month3,Month4,Month5,Month6,Month7,Month8,Month9,Month10,Month11,Month12
	)
	select @GLBudgetKey, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey
	,round(BMonth1, 2)
	,round(BMonth2, 2)
	,round(BMonth3, 2)
	,round(BMonth4, 2)
	,round(BMonth5, 2)
	,round(BMonth6, 2)
	,round(BMonth7, 2)
	,round(BMonth8, 2)
	,round(BMonth9, 2)
	,round(BMonth10, 2)
	,round(BMonth11, 2)
	,round(BMonth12, 2)
	from #forecastdetailsumm
	 
	 
	 /* first attempt to update existing records and leave others  

	update tGLBudgetDetail
	set    tGLBudgetDetail.Month1 = round(fds.BMonth1, 2)
		  , tGLBudgetDetail.Month2 = round(fds.BMonth2, 2)
		  , tGLBudgetDetail.Month3 = round(fds.BMonth3, 2)
		  , tGLBudgetDetail.Month4 = round(fds.BMonth4, 2)
		  , tGLBudgetDetail.Month5 = round(fds.BMonth5, 2)
		  , tGLBudgetDetail.Month6 = round(fds.BMonth6, 2)
	      , tGLBudgetDetail.Month7 = round(fds.BMonth7, 2)
		  , tGLBudgetDetail.Month8 = round(fds.BMonth8, 2)
		  , tGLBudgetDetail.Month9 = round(fds.BMonth9, 2)
		  , tGLBudgetDetail.Month10 = round(fds.BMonth10, 2)
		  , tGLBudgetDetail.Month11 = round(fds.BMonth11, 2)
		  , tGLBudgetDetail.Month12 = round(fds.BMonth12, 2)
	from  #forecastDetailsumm fds
	where tGLBudgetDetail.GLBudgetKey = @GLBudgetKey
	and   tGLBudgetDetail.GLAccountKey = fds.GLAccountKey
	and   tGLBudgetDetail.ClassKey = fds.ClassKey
	and   tGLBudgetDetail.ClientKey = fds.ClientKey
	and   tGLBudgetDetail.GLCompanyKey = fds.GLCompanyKey
	and   tGLBudgetDetail.OfficeKey = fds.OfficeKey
	and   tGLBudgetDetail.DepartmentKey = fds.DepartmentKey
	and   fds.UpdateFlag = 1
	 
	insert tGLBudgetDetail (GLBudgetKey, GLAccountKey, ClassKey, ClientKey, GLCompanyKey,OfficeKey, DepartmentKey
		,Month1,Month2,Month3,Month4,Month5,Month6,Month7,Month8,Month9,Month10,Month11,Month12
	)
	select @GLBudgetKey, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey
	,round(BMonth1, 2)
	,round(BMonth2, 2)
	,round(BMonth3, 2)
	,round(BMonth4, 2)
	,round(BMonth5, 2)
	,round(BMonth6, 2)
	,round(BMonth7, 2)
	,round(BMonth8, 2)
	,round(BMonth9, 2)
	,round(BMonth10, 2)
	,round(BMonth11, 2)
	,round(BMonth12, 2)
	from #forecastdetailsumm
	where UpdateFlag = 0
	*/


	/* part of original code

	update #forecastDetailsumm set UpdateFlag = 0

	-- I reuse the Month1,Month2,etc...because they have been already transferred to the BMonth1,BMonth2,etc..
	-- I store there the buckets from the GL Budget

	update #forecastDetailsumm
	set    #forecastDetailsumm.UpdateFlag = 1 -- these are the records I have to update
	      ,#forecastDetailsumm.Month1 = glbd.Month1
	      ,#forecastDetailsumm.Month2 = glbd.Month2
	      ,#forecastDetailsumm.Month3 = glbd.Month3
	      ,#forecastDetailsumm.Month4 = glbd.Month4
	      ,#forecastDetailsumm.Month5 = glbd.Month5
	      ,#forecastDetailsumm.Month6 = glbd.Month6
	      ,#forecastDetailsumm.Month7 = glbd.Month7
	      ,#forecastDetailsumm.Month8 = glbd.Month8
	      ,#forecastDetailsumm.Month9 = glbd.Month9
	      ,#forecastDetailsumm.Month10 = glbd.Month10
	      ,#forecastDetailsumm.Month11 = glbd.Month11
		  ,#forecastDetailsumm.Month12 = glbd.Month12

	from   tGLBudgetDetail glbd (nolock)
	where  glbd.GLBudgetKey = @GLBudgetKey
	and    #forecastDetailsumm.GLAccountKey = glbd.GLAccountKey
	and    #forecastDetailsumm.ClassKey = glbd.ClassKey
	and    #forecastDetailsumm.ClientKey = glbd.ClientKey
	and    #forecastDetailsumm.GLCompanyKey = glbd.GLCompanyKey
	and    #forecastDetailsumm.OfficeKey = glbd.OfficeKey
	and    #forecastDetailsumm.DepartmentKey = glbd.DepartmentKey

	-- now we must override the early buckets from the GL budget if the forecast does not start in January
	if @StartMonth = 2
		update #forecastDetailsumm
		set    BMonth1 = Month1
		where  UpdateFlag = 1
	else if @StartMonth = 3
		update #forecastDetailsumm
		set    BMonth1 = Month1 ,BMonth2 = Month2
		where  UpdateFlag = 1
	else if @StartMonth = 4
		update #forecastDetailsumm
		set    BMonth1 = Month1,BMonth2 = Month2,BMonth3 = Month3
		where  UpdateFlag = 1
	else if @StartMonth = 5
		update #forecastDetailsumm
		set    BMonth1 = Month1,BMonth2 = Month2,BMonth3 = Month3,BMonth4 = Month4
		where  UpdateFlag = 1
	else if @StartMonth = 6
		update #forecastDetailsumm
		set    BMonth1 = Month1,BMonth2 = Month2,BMonth3 = Month3,BMonth4 = Month4,BMonth5 = Month5
		where  UpdateFlag = 1
	else if @StartMonth = 7
		update #forecastDetailsumm
		set    BMonth1 = Month1,BMonth2 = Month2,BMonth3 = Month3,BMonth4 = Month4,BMonth5 = Month5,BMonth6 = Month6
		where  UpdateFlag = 1
	else if @StartMonth = 8
		update #forecastDetailsumm
		set    BMonth1 = Month1,BMonth2 = Month2,BMonth3 = Month3,BMonth4 = Month4,BMonth5 = Month5,BMonth6 = Month6
		      ,BMonth7 = Month7
		where  UpdateFlag = 1
	else if @StartMonth = 9
		update #forecastDetailsumm
		set    BMonth1 = Month1,BMonth2 = Month2,BMonth3 = Month3,BMonth4 = Month4,BMonth5 = Month5,BMonth6 = Month6
		      ,BMonth7 = Month7,BMonth8 = Month8
		where  UpdateFlag = 1
	else if @StartMonth = 10
		update #forecastDetailsumm
		set    BMonth1 = Month1,BMonth2 = Month2,BMonth3 = Month3,BMonth4 = Month4,BMonth5 = Month5,BMonth6 = Month6
		      ,BMonth7 = Month7,BMonth8 = Month8,BMonth9 = Month9
		where  UpdateFlag = 1
	else if @StartMonth = 11
		update #forecastDetailsumm
		set    BMonth1 = Month1,BMonth2 = Month2,BMonth3 = Month3,BMonth4 = Month4,BMonth5 = Month5,BMonth6 = Month6
		      ,BMonth7 = Month7,BMonth8 = Month8,BMonth9 = Month9,BMonth10 = Month10
		where  UpdateFlag = 1
	else if @StartMonth = 12
		update #forecastDetailsumm
		set    BMonth1 = Month1,BMonth2 = Month2,BMonth3 = Month3,BMonth4 = Month4,BMonth5 = Month5,BMonth6 = Month6
		      ,BMonth7 = Month7,BMonth8 = Month8,BMonth9 = Month9,BMonth10 = Month10,BMonth11 = Month11
		where  UpdateFlag = 1

	-- Original code
	 
	begin tran

	
	delete tGLBudgetDetail where GLBudgetKey = @GLBudgetKey

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrDeleteBudgetDetail
	end	

	insert tGLBudgetDetail (GLBudgetKey, GLAccountKey, ClassKey, ClientKey, GLCompanyKey,OfficeKey, DepartmentKey
		,Month1,Month2,Month3,Month4,Month5,Month6,Month7,Month8,Month9,Month10,Month11,Month12
	)
	select @GLBudgetKey, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey
	,round(BMonth1, 2)
	,round(BMonth2, 2)
	,round(BMonth3, 2)
	,round(BMonth4, 2)
	,round(BMonth5, 2)
	,round(BMonth6, 2)
	,round(BMonth7, 2)
	,round(BMonth8, 2)
	,round(BMonth9, 2)
	,round(BMonth10, 2)
	,round(BMonth11, 2)
	,round(BMonth12, 2)
	from #forecastdetailsumm
	 

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrInsertBudgetDetail
	end	

	commit tran

	*/

end

	RETURN @GLBudgetKey
GO
