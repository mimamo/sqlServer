USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphOpportunityForecastWJ]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGraphOpportunityForecastWJ]
		@CompanyKey int,
		@UserKey int,
		@EntityKeys varchar(8000), -- There will always be at least one Key passed in, the current user's key
		@UsingFolders varchar(1),
		@GroupedBy int, -- How do we want the data formatted?
		@GLCompanyKey int = null

AS --Encrypt

  /*
  || When     Who Rel       What
  || 06/09/09 MAS 10.5.0.0  Created
  || 10/07/09 MAS 10.5.1.2	(65005) Modified the way the dates for the chart are calculated and grouped
  || 2/23/10  CRG 10.5.1.9  (75419) Now using fFormatDateNoTime function in query to remove the time element from getdate().
  ||                        This fixes a problem when the EstCloseDate is the same as the day they are looking at the widget.
  || 06/30/11 RLB 10.5.4.5  (115502) Pulling data from the first of the current month instead of todays date
  || 08/07/12 RLB 10.5.5.8  Adding GLCompany option and HMI Changes
  || 03/09/15 RLB 10.5.9.0  new display on dashboard option for lead stage
  */


Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
From   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

Declare @idx int 
Declare	@SecurityGroupKey int

Create table #keys (EntityKey int)
Declare @slice varchar(8000)       

Select @idx = 1  
While @idx!= 0       
Begin       
	set @idx = charindex(',',@EntityKeys)       
	if @idx!=0       
		set @slice = left(@EntityKeys,@idx - 1)       
	else       
		set @slice = @EntityKeys       
      
	if(len(@slice)>0)  
		Insert Into #keys(EntityKey) values(@slice)       

	set @EntityKeys = right(@EntityKeys,len(@EntityKeys) - @idx)       
	if len(@EntityKeys) = 0 break       
End 


--  Stage, Sale Amount, Production, Media, AGI, Forcasted Revenue, DisplayOrder
CREATE TABLE #data(
	EstCloseDate smalldatetime null
	,CMFolderKey int null
	,AccountManager varchar(250) null
	,StageName varchar(200) null
	,WWPCurrentLevel int null
	,Amount money null
	,CompanyKey int null
	,DisplayOrder int null
	,GLCompanyKey int null
	,DisplayOnDashboard tinyint null)
	 
INSERT #data	
SELECT 
	tLead.EstCloseDate,
	tLead.CMFolderKey AS CMFolderKey,
	ISNULL(tUser.FirstName,'') + ' ' + ISNULL(tUser.LastName, '') AS AccountManager,
	tLeadStage.LeadStageName AS StageName,
	ISNULL(tLead.WWPCurrentLevel,1) AS WWPCurrentLevel,
	ISNULL(SaleAmount,0) As Amount, --  * ISNULL(Probability,0) / 100
	tLead.CompanyKey, 
	tLeadStage.DisplayOrder,
	tLead.GLCompanyKey,
	ISNULL(tLeadStage.DisplayOnDashboard, 0)
FROM tLead (nolock)
	INNER JOIN tLeadStatus (nolock) ON tLead.LeadStatusKey = tLeadStatus.LeadStatusKey
	LEFT OUTER JOIN tLeadStage (nolock) ON tLead.LeadStageKey = tLeadStage.LeadStageKey
	LEFT OUTER JOIN tProjectType (nolock) ON tLead.ProjectTypeKey = tProjectType.ProjectTypeKey
	INNER JOIN tUser (nolock)  ON tLead.AccountManagerKey = tUser.UserKey 
	INNER JOIN #keys on #keys.EntityKey = tLead.AccountManagerKey 
WHERE tLead.CompanyKey = @CompanyKey 
	and tLeadStatus.Active = 1 -- Only Active Opportunities
	AND tLead.EstCloseDate >= dbo.fFormatDateNoTime(Cast(STR(Year(GetDate())) + '-' + STR(Month(GetDate())) + '-01' as datetime))
	AND tLead.EstCloseDate < DATEADD(month, 6, dbo.fFormatDateNoTime(Cast(STR(Year(GetDate())) + '-' + STR(Month(GetDate())) + '-01' as datetime)))
	AND (@GLCompanyKey IS NULL OR tLead.GLCompanyKey = @GLCompanyKey)
	AND (@GLCompanyKey IS NOT NULL OR (@RestrictToGLCompany = 0 OR tLead.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @UserKey)))

--select * from #data

-- Populate the #data table with place holders so we always have 6 months worth of data
Declare @CurrentDate as datetime
Declare @ct as int

Set @CurrentDate = Cast(STR(Year(GetDate())) + '-' + STR(Month(GetDate())) + '-01' as datetime)

Set @ct = 0
While @ct < 6
BEGIN
	Insert Into #data (EstCloseDate, CMFolderKey, AccountManager, StageName,WWPCurrentLevel,Amount,CompanyKey,DisplayOrder,GLCompanyKey ) 
		Values (DateAdd(month, @ct, @CurrentDate), 0, '', '',0,0,@CompanyKey,0,NULL)

	Set @ct = @ct + 1
END

If @UsingFolders = 1
	Begin
		-- Opportunity Folders (taken from sptCMFolderUserLeadGet)
		SELECT  @SecurityGroupKey = SecurityGroupKey, @CompanyKey = CompanyKey 
		FROM	tUser (NOLOCK) Where UserKey = @UserKey

		Select	f.CMFolderKey into #folders
		From	tCMFolder f (NOLOCK)
				left outer join (Select * from tCMFolderSecurity (nolock) 
				Where Entity = 'tSecurityGroup' and EntityKey = @SecurityGroupKey and CanView = 1) as securityGroup 
					on f.CMFolderKey = securityGroup.CMFolderKey
				left outer join (Select * from tCMFolderSecurity (nolock) Where Entity = 'tUser' and EntityKey = @UserKey and CanView = 1) as securityUser
					on f.CMFolderKey = securityUser.CMFolderKey
		Where	f.Entity = 'tLead' and CompanyKey = @CompanyKey

		Delete #data
		Where #data.CMFolderKey not in (Select CMFolderKey from #folders ) and ISNULL(#data.CMFolderKey, 0) > 0
	End

If @GroupedBy = 0  -- Group By WWP
	Begin
		-- There was also an issue with Flex doing a time/date conversion when I used the 1st of the month so on using the 15th
		Select Cast(STR(Year(EstCloseDate)) + '-' + STR(Month(EstCloseDate)) + '-15' as datetime) as Label,
		CASE WWPCurrentLevel 
			WHEN 2 THEN 'Contemplating'
			WHEN 3 THEN 'Planning'
			WHEN 4 THEN 'Action'
			ELSE 'Unaware' 
			END AS StageName, 
		AccountManager, Sum(Amount) as Amount
		from #data d
		Group By Cast(STR(Year(EstCloseDate)) + '-' + STR(Month(EstCloseDate)) + '-15' as datetime), AccountManager, WWPCurrentLevel
		Order By Cast(STR(Year(EstCloseDate)) + '-' + STR(Month(EstCloseDate)) + '-15' as datetime), WWPCurrentLevel
		Return 
	End

If @GroupedBy = 1 -- Group By StageName
	Begin
		-- remove any leads whos lead stage is not suppose to be on a dashboard
		DELETE #data
		WHERE #data.DisplayOnDashboard = 0
		
		-- There was also an issue with Flex doing a time/date conversion when I used the 1st of the month so we're using the 15th
		Select Cast(STR(Year(EstCloseDate)) + '-' + STR(Month(EstCloseDate)) + '-15' as datetime)  as Label, StageName, AccountManager, Sum(Amount) as Amount, DisplayOrder
		from #data d
		Group By Cast(STR(Year(EstCloseDate)) + '-' + STR(Month(EstCloseDate)) + '-15' as datetime), AccountManager, DisplayOrder, StageName
		Order By Cast(STR(Year(EstCloseDate)) + '-' + STR(Month(EstCloseDate)) + '-15' as datetime), DisplayOrder
		Return
	End

If @GroupedBy = 2  -- Group By AccountManager 
	Begin
		-- remove any leads whos lead stage is not suppose to be on a dashboard
		DELETE #data
		WHERE #data.DisplayOnDashboard = 0
		
		-- There was also an issue with Flex doing a time/date conversion when I used the 1st of the month so on using the 15th
		Select Cast(STR(Year(EstCloseDate)) + '-' + STR(Month(EstCloseDate)) + '-15' as datetime)  as Label, AccountManager as StageName, Sum(Amount) as Amount
		from #data d
		Group By Cast(STR(Year(EstCloseDate)) + '-' + STR(Month(EstCloseDate)) + '-15' as datetime), AccountManager
		Order By Cast(STR(Year(EstCloseDate)) + '-' + STR(Month(EstCloseDate)) + '-15' as datetime), AccountManager
		Return
	End

-- exec spGraphOpportunityForecastWJ 100, '16', '144,16,17,2072,145,177115', '0', '0'
-- exec spGraphOpportunityForecastWJ 100, '16', '144,16,17,2072,145,177115', '0', '1'
-- exec spGraphOpportunityForecastWJ 100, '16', '144,16,17,2072,145,177115', '0', '2'
GO
