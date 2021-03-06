USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphOpportunityPipelineWJ]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGraphOpportunityPipelineWJ]
		@CompanyKey int,
		@UserKey int,
		@EntityKeys varchar(8000), -- There will always be at least one Key passed in, the current user's key
		@UsingFolders varchar(1),
		@ProjectTypeKey int,
		@LeadStatusKey int, -- -1:All, -2:All Active, -3:All Inactive
		@AmountType int,
		@GroupedBy int, -- How do we want the data formatted?
		@ShowAs int,
		@GLCompanyKey int = null

AS --Encrypt

  /*
  || When     Who Rel       What
  || 05/29/09 MAS 10.5.0.0  Created
  || 06/22/09 MAS 10.5.0.0  (55469) - Do not filter out Leads with a NULL CMFolderKey when using folders
  || 07/28/09 GHL 10.5.0.5  Changed 'Insert Into Temp' to 'Create Temp' + Regular Insert to prevent
  ||                        tempdb locks
  || 9/25/09  CRG 10.5.1.1  (62306) Added functionality for new LeadStatus options (All Active and All Inactive).
  ||                        Also un-commented the code that restricts by ProjectTypeKey and LeadStatusKey.
  || 8/03/12  RLB 10.5.5.8  HMI changes and adding GLCompany
  || 02/05/15 RLB 10.5.8.9  Wrapped stage name with is null in case none was entered
  || 03/09/15 RLB 10.5.9.0  Added Display order to StageName selections and new display on dashboard option
  */

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
From   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)


DECLARE @LeadStatusActive tinyint
IF @LeadStatusKey = -2 --All Active
	SELECT @LeadStatusActive = 1
ELSE
	IF @LeadStatusKey = -3 --All Inactive
		SELECt @LeadStatusActive = 0

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
	CMFolderKey int null
	,AccountManager varchar(250) null
	,StageName varchar(200) null
	,WWPCurrentLevel int null
	,Amount money null
	,ProjectTypeKey int null
	,LeadStatusKey int null
	,CompanyKey int null
	,DisplayOrder int null
	,DisplayOnDashboard tinyint null)

INSERT #data	
SELECT 
	tLead.CMFolderKey AS CMFolderKey,
	ISNULL(tUser.FirstName,'') + ' ' + ISNULL(tUser.LastName, '') AS AccountManager,
	ISNULL(tLeadStage.LeadStageName, 'No Stage Name') AS StageName,
	ISNULL(tLead.WWPCurrentLevel,1) AS WWPCurrentLevel,
	CASE @AmountType
		When 0 Then ISNULL(SaleAmount,0)		 -- Sale Amount
		When 1 Then ISNULL(OutsideCostsGross, 0) -- Production
		When 2 Then	ISNULL(MediaGross,0)		 -- Media
		When 3 Then ISNULL(AGI,0)
		Else ISNULL(SaleAmount,0) * ISNULL(Probability,0) / 100
	End As Amount,
	tLead.ProjectTypeKey,
	tLead.LeadStatusKey,
	tLead.CompanyKey, 
	tLeadStage.DisplayOrder,
	ISNULL(tLeadStage.DisplayOnDashboard, 0)
FROM tLead (NOLOCK)
	INNER JOIN tLeadStatus (NOLOCK) ON tLead.LeadStatusKey = tLeadStatus.LeadStatusKey
	LEFT OUTER JOIN tLeadStage (NOLOCK) ON tLead.LeadStageKey = tLeadStage.LeadStageKey
	LEFT OUTER JOIN tProjectType (NOLOCK) ON tLead.ProjectTypeKey = tProjectType.ProjectTypeKey
	INNER JOIN tUser (NOLOCK) ON tLead.AccountManagerKey = tUser.UserKey 
	INNER JOIN #keys on #keys.EntityKey = tLead.AccountManagerKey 
	WHERE tLead.CompanyKey = @CompanyKey 
	and (@LeadStatusActive IS NULL OR tLeadStatus.Active = @LeadStatusActive)
	and (@GLCompanyKey IS NULL OR tLead.GLCompanyKey = @GLCompanyKey)
	AND (@GLCompanyKey IS NOT NULL or (@RestrictToGLCompany = 0 or tUser.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @UserKey)))

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
		Where #data.CMFolderKey not in (Select CMFolderKey from #folders )
		and ISNULL(#data.CMFolderKey, 0) > 0
	End

-- Delete all Project Types that were not selected
if @ProjectTypeKey > 0
	Delete #data
	Where #data.ProjectTypeKey <> @ProjectTypeKey or #data.ProjectTypeKey is null

If @LeadStatusKey > 0
	Delete #data
	Where #data.LeadStatusKey <> @LeadStatusKey or #data.LeadStatusKey is null


If @GroupedBy = 0 And @ShowAs = 0 -- Group By AccountManager / Seperated Account Managers
	Begin
		Select AccountManager as Label,
			ISNULL((Select Sum(Amount) From #data d1 Where d1.WWPCurrentLevel = '1' and d1.AccountManager = d.AccountManager),0) AS Unaware,
			ISNULL((Select Sum(Amount) From #data d1 Where d1.WWPCurrentLevel = '2' and d1.AccountManager = d.AccountManager),0) AS Contemplating,
			ISNULL((Select Sum(Amount) From #data d1 Where d1.WWPCurrentLevel = '3' and d1.AccountManager = d.AccountManager),0) AS Planning,
			ISNULL((Select Sum(Amount) From #data d1 Where d1.WWPCurrentLevel = '4' and d1.AccountManager = d.AccountManager),0) AS [Action]
		from #data d
		Group By AccountManager
		Return 
	End

If @GroupedBy = 0 And @ShowAs = 1 -- Group By AccountManager / Combined Account Managers
	Begin
		Select '' as Label,
			ISNULL((Select Sum(Amount) From #data d1 Where d1.WWPCurrentLevel = '1'),0) AS Unaware,
			ISNULL((Select Sum(Amount) From #data d1 Where d1.WWPCurrentLevel = '2'),0) AS Contemplating,
			ISNULL((Select Sum(Amount) From #data d1 Where d1.WWPCurrentLevel = '3'),0) AS Planning,
			ISNULL((Select Sum(Amount) From #data d1 Where d1.WWPCurrentLevel = '4'),0) AS [Action]
		from #data d
		Group By CompanyKey
		Return 
	End

If @GroupedBy = 1 And @ShowAs = 0 -- Group By StageName / Seperated Account Managers
	Begin
		-- remove any leads whos lead stage is not suppose to be on a dashboard
		DELETE #data
		WHERE #data.DisplayOnDashboard = 0
		
		Select AccountManager as Label, StageName, DisplayOrder,Sum(Amount) as Amount
		from #data d
		Group By AccountManager, DisplayOrder, StageName
		Order By AccountManager, DisplayOrder
		Return
	End

If @GroupedBy = 1 And @ShowAs = 1 -- Group By StageName / Combined Account Managers
	Begin
		-- remove any leads whos lead stage is not suppose to be on a dashboard
		DELETE #data
		WHERE #data.DisplayOnDashboard = 0
		
		Select '' as Label, StageName, DisplayOrder, Sum(Amount) as Amount
		from #data d
		Group By StageName, DisplayOrder
		Order By DisplayOrder
		Return
	End

-- exec spGraphOpportunityPipelineWJ 100, '16', '144,16,17,2072,145', '1', '-1', '-1', '3', '0', '0'
-- exec spGraphOpportunityPipelineWJ 100, '16', '144,16,17,2072,145', '0', '-1', '-1', '0', '1', '0'
GO
