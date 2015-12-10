USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityGroupGetAllDetails]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSecurityGroupGetAllDetails]
	@CompanyKey int

AS --Encrypt

/*
|| When			   Who Rel			 What
|| 12/16/2009	 MAS 10.5.1.8	 Created
|| 03/06/2010	 MAS 10.5.2		 Remove the 'SetGroup' filter on tRight that was only returning Client and Admin records
|| 11/16/2010  RLB 10.5.3.8  (92243) Added Legacy in right groups
|| 03/20/2012  GWG 10.5.5.4  added RestrictToGLCompany to the get
|| 07/09/2012  GHL 10.5.5.8  added ShowICTSetup to the get
|| 08/22/2012  KMC 10.5.5.9  (148856) Added the project requests and tracking forms security to the security
||                           options that can be updated on the security screens.
|| 10/29/2012  CRG 10.5.6.1  (156391) Added tPreference.CustomReportAssignedProjectOnly
|| 10/28/2013  MFT 10.5.7.3  (193819) Added PwdRequireSpecialChars, PwdRequireCapital, PwdRequireLowerCase, PwdNotSimilarToUserID, PwdChangeOnFirstLogin
|| 11/21/2014  WDF 10.5.8.7  Suppress 'legacy' items if no customization
*/
DECLARE @SecurityGroup varchar(35), @FormsGroup varchar(35), @SkillsKey int, @TasksKey int
DECLARE @LegacySecurity smallint, @LegacyForms smallint, @LegacySkills smallint, @LegacyTasks smallint

-- Groups
Exec sptSecurityGroupGetCompanyList @CompanyKey, 1 -- Only Active Security Groups

-- Users 
Select	UserKey, SecurityGroupKey,  
		ISNULL(FirstName + ' ', '') + ISNULL((LEFT(ISNULL(MiddleName, ''), 1) + ' '),  '') + LastName as UserName 
		,Active
From tUser (NOLOCK) 
Where isnull(OwnerCompanyKey, CompanyKey) = @CompanyKey
and Active = 1 And SecurityGroupKey is not NULL
Order By FirstName, LastName

-- Assigned Datasets
SELECT	vsg.ViewKey, vsg.SecurityGroupKey
FROM	tViewSecurityGroup vsg(NOLOCK)
JOIN tSecurityGroup sg (NOLOCK) on sg.SecurityGroupKey = vsg.SecurityGroupKey
And sg.CompanyKey = @CompanyKey

-- All Rights
Select @LegacySecurity = ISNULL(CHARINDEX('legacysecurity', Customizations), 0)
      ,@LegacyForms = ISNULL(CHARINDEX('legacyforms', Customizations), 0) 
      ,@LegacySkills = ISNULL(CHARINDEX('legacyskills', Customizations), 0)
      ,@LegacyTasks = ISNULL(CHARINDEX('legacymastertasks', Customizations), 0)
  from tPreference where CompanyKey = @CompanyKey

if @LegacySecurity = 0 Select @SecurityGroup = 'legacy'
if @LegacyForms = 0  Select @FormsGroup = 'form'
if @LegacySkills = 0 Select @SkillsKey = 10800
if @LegacyTasks = 0  Select @TasksKey = 90355

SELECT  r.*  
	,Case r.SetGroup
		When 'admin' then 'Full User Options'
		When 'client' then 'Client Vendor Login Options'
		else 'Custom Security Options'  end as SetGroupLabel 
	,Case r.SetGroup
		When 'admin' then 0
		When 'client' then 1
		else 2  end as SetGroupOrder 
	,Case r.RightGroup
		  When 'desktop' then 'Edit the company settings for the desktop'	
		  When 'admin' then 'System Administration'  
		  When 'project' then 'Project Administration'  
		  When 'cm' then 'Contact Management'  
		  When 'time' then 'Time and Expenses'  
		  When 'acct' then 'Accounting'  
		  When 'billing' then 'Billing'  
		  When 'purch' then 'Purchasing'  
		  When 'media' then 'Media'  
		  When 'traffic' then 'Traffic'  
		  When 'calendar' then 'Calendar'  
		  When 'form' then 'Tracking Forms'  
		  When 'forum' then 'Discussion Forums'  
		  When 'file' then 'Digital Assets'  
		  When 'approval' then 'Project Approvals'  
		  When 'dashboard' then 'Dashboard'  
		  When 'reports' then 'Reports'
		  When 'legacy' then 'Legacy Item Rights'  
		  When 'client' then 'All Options'  
		  When 'requests' then 'Project Requests' end as GroupHeading  
	 ,Case r.RightGroup  
		  When 'admin' then 1  
		  When 'project' then 2  
		  When 'requests' then 3  
		  When 'cm' then 4  
		  When 'time' then 5  
		  When 'acct' then 6  
		  When 'billing' then 7  
		  When 'purch' then 8  
		  when 'media' then 9  
		  When 'traffic' then 10  
		  When 'calendar' then 11  
		  When 'form' then 12  
		  When 'forum' then 13  
		  When 'file' then 14  
		  When 'approval' then 15  
		  When 'dashboard' then 16 
		  When 'legacy' then 17  
		  When 'reports' then 18  
		  When 'client' then 19 
		  else 0 end as GroupOrder				
 FROM tRight r (NOLOCK) 
WHERE (@SecurityGroup is null or r.RightGroup <> @SecurityGroup)
  AND (@FormsGroup is null or (r.RightGroup <> @FormsGroup and r.RightKey <> 10110))  
  AND (@SkillsKey is null or r.RightKey <> @SkillsKey)  
  AND (@TasksKey is null or r.RightKey <> @TasksKey)  
 ORDER BY SetGroup, GroupOrder, r.DisplayOrder  

-- Assigned Rights
Select EntityKey As SecurityGroupKey, tRightAssigned.RightKey 
from tRightAssigned (NOLOCK) 
Join tSecurityGroup (NOLOCK) on tSecurityGroup.SecurityGroupKey = tRightAssigned.EntityKey
Join tRight (NOLOCK) on tRight.RightKey = tRightAssigned.RightKey
Where EntityType = 'Security Group' 
And tSecurityGroup.CompanyKey = @CompanyKey
--- And (Upper(SetGroup)  = 'CLIENT'  or UPPER(SetGroup) = 'ADMIN')

-- Get Security settings (password length, requirements, etc..)
Select PwdRequireNumbers,PwdRequireLetters,PwdRequireSpecialChars,PwdRequireCapital,PwdRequireLowerCase,PwdNotSimilarToUserID,PwdChangeOnFirstLogin,PwdMinLength,PwdRememberLast,PwdBadLoginLockout,PwdDaysBetweenChanges,RestrictToGLCompany,ShowICTSetup,CustomReportAssignedProjectOnly
from tPreference (NOLOCK)
Where CompanyKey = @CompanyKey

-- Get the Active Project Requests
EXEC sptRequestDefGetList @CompanyKey, 1
--Get the security groups assigned to the active project requests
EXEC sptRequestDefGetAllAccess @CompanyKey

-- Get the Active Tracking Forms
EXEC sptFormDefGetList @CompanyKey
--Get the security groups assigned to the active tracking forms
EXEC sptFormDefGetAllAccess @CompanyKey
GO
