USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectTimeline]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
  || When     Who Rel     What
  || 10/13/06 WES 8.3567  Added Campaign Name for group by in proj time line report
  || 02/08/07 GHL 8.403   Added Campaign Key to support campaign timeline
  || 05/08/10 RLB 10.522  (68689)Added Project Type to filter data
  || 04/13/12 GHL 10.555  Added logic for UserGLCompanyAccess 
  */

CREATE PROCEDURE [dbo].[spRptProjectTimeline]
	(
		@CompanyKey INT,		-- Always > 0
		@UserKey INT,			-- Always > 0 
		@ProjectKey INT,		-- NULL, > 0
		@ProjectStatusKey INT,	-- -3 All, -1 Active, -2 Inactive, > 0 
		@OfficeKey INT,			-- NULL, > 0
		@ClientKey INT,			-- NULL, > 0
		@AccountManager INT, 	-- NULL, > 0
		@CampaignKey INT = NULL, -- NULL, > 0
		@ProjectTypeKey INT = NULL, -- NULL, > 0
        @CheckRights INT = 0
	)
AS -- Encrypt

	SET NOCOUNT ON

Declare @Administrator int
Declare @SecurityGroupKey int  
Declare @CheckAssignment int  

select @Administrator = isnull(Administrator, 0), @SecurityGroupKey = isnull(SecurityGroupKey, 0)
from tUser (nolock) where UserKey = @UserKey

select @CheckAssignment = 1

if @Administrator = 1
begin
	select @CheckAssignment = 0
end
else
begin

	if exists (select 1 from tRight r (nolock)
		inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
		where ra.EntityType = 'Security Group'
		and   ra.EntityKey = @SecurityGroupKey
		and   r.RightID = 'prjAccessAny')
		
		select @CheckAssignment = 0
	else
		select @CheckAssignment = 1

end

if @CheckRights = 0
	select @CheckAssignment = 1
	
Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

if @CheckAssignment = 1
		Select 
			p.ClientKey,
			p.ProjectStatusKey,
			u1.FirstName + ' ' + u1.LastName as AccountManagerName,
			p.AccountManager,
			isnull(c.CustomerID+' \ ','') + ISNULL(p.ProjectNumber,'') AS ClientProjectNumber,
			isnull(c.CustomerID+' \ ','') + ISNULL(p.ProjectNumber+' \ ','') + ISNULL(LEFT(p.ProjectName,15),'') AS ClientProject,
			p.ProjectNumber,
			p.ProjectName,
			p.OfficeKey,
			o.OfficeName,
			p.StartDate as ProjectStartDate,
			p.CompleteDate as ProjectCompleteDate,
			p.StatusNotes,
			ps.ProjectStatus,
			pt.ProjectTypeName,
			t.ProjectKey,
			t.TaskKey,
			t.TaskID,
			t.PlanStart,
			t.PlanComplete,
			t.BaseStart,
			t.BaseComplete,
			t.PlanDuration,
			t.DisplayOrder,
			t.TaskType,
			ISNULL(t.PercComp, 0) as PercComp,
			t.ScheduleNote,
			t.Comments,
			t.ActStart,
			t.ActComplete,
			t.TaskName,
			t.TaskStatus,
			ISNULL(t.ProjectOrder, 0) as ProjectOrder,
			ISNULL(t.TaskLevel, 0) as TaskLevel,
			c.CompanyName,
			c.CustomerID,
			t.HideFromClient,
			cn.CampaignName as CampaignName
		FROM 
			tTask t (nolock) 
			INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey 
			INNER JOIN tAssignment a (nolock) ON p.ProjectKey = a.ProjectKey 
			INNER JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey 
			LEFT OUTER JOIN tUser u1 (nolock) ON p.AccountManager = u1.UserKey 
			left outer join tCampaign cn (nolock) on p.CampaignKey = cn.CampaignKey
			LEFT OUTER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
			LEFT OUTER JOIN tOffice o (nolock) on p.OfficeKey = o.OfficeKey
			LEFT OUTER JOIN tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
		WHERE p.CompanyKey = @CompanyKey
		AND   t.ScheduleTask = 1
		AND   a.UserKey = @UserKey
		AND   (@ProjectKey IS NULL OR p.ProjectKey = @ProjectKey)
		AND   (@OfficeKey IS NULL OR p.OfficeKey = @OfficeKey)
		AND   (@ClientKey IS NULL OR p.ClientKey = @ClientKey)
		AND	  (@AccountManager IS NULL OR p.AccountManager = @AccountManager)
		AND	  (@CampaignKey IS NULL OR p.CampaignKey = @CampaignKey)
		AND	  (@ProjectTypeKey IS NULL OR p.ProjectTypeKey = @ProjectTypeKey)
		AND   (		@ProjectStatusKey = -3
				OR (@ProjectStatusKey = -1 AND p.Active = 1)
				OR (@ProjectStatusKey = -2 AND p.Active = 0)
				OR (@ProjectStatusKey > 0 AND p.ProjectStatusKey = @ProjectStatusKey) 
			  )	
		AND (@RestrictToGLCompany = 0 
		OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
			

else

		Select 
			p.ClientKey,
			p.ProjectStatusKey,
			u1.FirstName + ' ' + u1.LastName as AccountManagerName,
			p.AccountManager,
			isnull(c.CustomerID+' \ ','') + ISNULL(p.ProjectNumber,'') AS ClientProjectNumber,
			isnull(c.CustomerID+' \ ','') + ISNULL(p.ProjectNumber+' \ ','') + ISNULL(LEFT(p.ProjectName,15),'') AS ClientProject,
			p.ProjectNumber,
			p.ProjectName,
			p.OfficeKey,
			o.OfficeName,
			p.StartDate as ProjectStartDate,
			p.CompleteDate as ProjectCompleteDate,
			p.StatusNotes,
			ps.ProjectStatus,
			pt.ProjectTypeName,
			t.ProjectKey,
			t.TaskKey,
			t.TaskID,
			t.PlanStart,
			t.PlanComplete,
			t.BaseStart,
			t.BaseComplete,
			t.PlanDuration,
			t.DisplayOrder,
			t.TaskType,
			ISNULL(t.PercComp, 0) as PercComp,
			t.ScheduleNote,
			t.Comments,
			t.ActStart,
			t.ActComplete,
			t.TaskName,
			t.TaskStatus,
			ISNULL(t.ProjectOrder, 0) as ProjectOrder,
			ISNULL(t.TaskLevel, 0) as TaskLevel,
			c.CompanyName,
			c.CustomerID,
			t.HideFromClient,
			cn.CampaignName as CampaignName
		FROM 
			tTask t (nolock) 
			INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey 
			INNER JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey 
			LEFT OUTER JOIN tUser u1 (nolock) ON p.AccountManager = u1.UserKey 
			left outer join tCampaign cn (nolock) on p.CampaignKey = cn.CampaignKey
			LEFT OUTER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
			LEFT OUTER JOIN tOffice o (nolock) on p.OfficeKey = o.OfficeKey
			LEFT OUTER JOIN tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
		WHERE p.CompanyKey = @CompanyKey
		AND   t.ScheduleTask = 1
		AND   (@ProjectKey IS NULL OR p.ProjectKey = @ProjectKey)
		AND   (@OfficeKey IS NULL OR p.OfficeKey = @OfficeKey)
		AND   (@ClientKey IS NULL OR p.ClientKey = @ClientKey)
		AND	  (@AccountManager IS NULL OR p.AccountManager = @AccountManager)
		AND	  (@CampaignKey IS NULL OR p.CampaignKey = @CampaignKey)
		AND	  (@ProjectTypeKey IS NULL OR p.ProjectTypeKey = @ProjectTypeKey)
		AND   (		@ProjectStatusKey = -3
				OR (@ProjectStatusKey = -1 AND p.Active = 1)
				OR (@ProjectStatusKey = -2 AND p.Active = 0)
				OR (@ProjectStatusKey > 0 AND p.ProjectStatusKey = @ProjectStatusKey) 
			  )			
		AND (@RestrictToGLCompany = 0 
		OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )

		RETURN 1
GO
