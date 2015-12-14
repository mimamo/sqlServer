USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvTaskAssignmentGetList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvTaskAssignmentGetList]

	(
		@UserKey int,
		@ProjectStatusKey int,		-- -1 All Active, -2 All Inactive, -3 All Projects, -4 Active with complete pred
									-- Or a specific Project Status
		@EndDate smalldatetime,
		@DateOption smallint = 1	-- 1: Due By, 2: Started By
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 12/18/06 CRG 8.4   Added check to make sure the ProjectStatusKey is Active.
|| 12/22/06 CRG 8.4   Wrapped PercCompSeparate and PercComp with ISNULL throughout the SP.
|| 05/23/07 GHL 8.422 Added AssignedPercComp, users want to see their own perc comp. Bug 9296.
|| 08/27/07 GWG 8435  Added Client and Contact details for the dash part.
*/

DECLARE @CompanyKey INT, @DefaultServiceKey int

SELECT @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey), @DefaultServiceKey = DefaultServiceKey
FROM   tUser (NOLOCK)
WHERE  UserKey = @UserKey

if @DateOption = 1 --Due By
BEGIN
	-- All Projects
	if @ProjectStatusKey = -3
		Select 
			p.ProjectKey,
			p.ProjectNumber,
			p.ProjectName,
			c.CustomerID,
			t.*,
			u.FirstName + ' ' + u.LastName as PrimaryContact,
			u.Phone1,
			u.Email,
			c.CompanyName,
			c.Phone,
			tu.Hours as AssignedHours,
			ISNULL(tu.ServiceKey, @DefaultServiceKey) as ServiceKey,
			CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, ISNULL(t.PercComp, 0)) END AS AssignedPercComp   
		from tTask t (nolock)
			Inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
			inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			LEFT OUTER JOIN tCompany c (nolock) on c.CompanyKey = p.ClientKey
			LEFT OUTER JOIN tUser u (nolock) ON p.BillingContact = u.UserKey
		Where 
			tu.UserKey = @UserKey and
			((ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) or (ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)) and
			ISNULL(ps.OnHold, 0) = 0 and
			t.PlanComplete <= @EndDate
		Order By t.PlanComplete
	
	else
		-- All Active
		if @ProjectStatusKey = -1
			Select 
				p.ProjectKey,
				p.ProjectNumber,
				p.ProjectName,
				p.WorkMon,
				p.WorkTue,
				p.WorkWed,
				p.WorkThur,
				p.WorkFri,
				p.WorkSat,
				p.WorkSun,
				c.CustomerID,
				t.*,
				u.FirstName + ' ' + u.LastName as PrimaryContact,
				u.Phone1,
				u.Email,
				c.CompanyName,
				c.Phone,
				tu.Hours as AssignedHours,
				ISNULL(tu.ServiceKey, @DefaultServiceKey) as ServiceKey,
				CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, ISNULL(t.PercComp, 0)) END AS AssignedPercComp   
			from tTask t (nolock)
				Inner join tTaskUser tu (nolock) on tu.TaskKey = t.TaskKey
				inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
				inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
				LEFT OUTER JOIN tCompany c (nolock) on c.CompanyKey = p.ClientKey
				LEFT OUTER JOIN tUser u (nolock) ON p.BillingContact = u.UserKey
			Where 
				tu.UserKey = @UserKey and
				p.Active = 1 AND
				ps.IsActive = 1 AND
				((ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) or (ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)) and
				ISNULL(ps.OnHold, 0) = 0 and
				t.PlanComplete <= @EndDate
			Order By t.PlanComplete		
		else
			-- All Inactive
			if @ProjectStatusKey = -2
				Select 
					p.ProjectKey,
					p.ProjectNumber,
					p.ProjectName,
					p.WorkMon,
					p.WorkTue,
					p.WorkWed,
					p.WorkThur,
					p.WorkFri,
					p.WorkSat,
					p.WorkSun,
					c.CustomerID,
					t.*,
					u.FirstName + ' ' + u.LastName as PrimaryContact,
					u.Phone1,
					u.Email,
					c.CompanyName,
					c.Phone,
					tu.Hours as AssignedHours,
					ISNULL(tu.ServiceKey, @DefaultServiceKey) as ServiceKey,
					CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, ISNULL(t.PercComp, 0)) END AS AssignedPercComp   
				from tTask t (nolock)
					Inner join tTaskUser tu (nolock) on tu.TaskKey = t.TaskKey
					inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
					inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
					LEFT OUTER JOIN tCompany c (nolock) on c.CompanyKey = p.ClientKey
					LEFT OUTER JOIN tUser u (nolock) ON p.BillingContact = u.UserKey
				Where 
					tu.UserKey = @UserKey and
					p.Active = 0 AND
					((ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) or (ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)) and
					ISNULL(ps.OnHold, 0) = 0 and
					t.PlanComplete <= @EndDate
				Order By t.PlanComplete
			else
				if @ProjectStatusKey = -4 -- Remove tasks with incomplete predecessors

					Select 
						p.ProjectKey,
						p.ProjectNumber,
						p.ProjectName,
						p.WorkMon,
						p.WorkTue,
						p.WorkWed,
						p.WorkThur,
						p.WorkFri,
						p.WorkSat,
						p.WorkSun,
						c.CustomerID,
						t.*,
						u.FirstName + ' ' + u.LastName as PrimaryContact,
						u.Phone1,
						u.Email,
						c.CompanyName,
						c.Phone,
						tu.Hours as AssignedHours,
						ISNULL(tu.ServiceKey, @DefaultServiceKey) as ServiceKey,
						CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, ISNULL(t.PercComp, 0)) END AS AssignedPercComp   
						from tTask t (nolock)
						Inner join tTaskUser tu (nolock) on tu.TaskKey = t.TaskKey
						inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
						inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
						LEFT OUTER JOIN tCompany c (nolock) on c.CompanyKey = p.ClientKey
						LEFT OUTER JOIN tUser u (nolock) ON p.BillingContact = u.UserKey
					where   tu.UserKey = @UserKey   
					and		p.Active = 1
					and		ps.IsActive = 1
					and		t.PredecessorsComplete = 1
					and		((ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) or (ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100))
					and		ISNULL(ps.OnHold, 0) <> 1
					and		t.PlanComplete <= @EndDate
				else
					-- For a specific project status		
					Select 
						p.ProjectKey,
						p.ProjectNumber,
						p.ProjectName,
						p.WorkMon,
						p.WorkTue,
						p.WorkWed,
						p.WorkThur,
						p.WorkFri,
						p.WorkSat,
						p.WorkSun,
						c.CustomerID,
						t.*,
						u.FirstName + ' ' + u.LastName as PrimaryContact,
						u.Phone1,
						u.Email,
						c.CompanyName,
						c.Phone,
						tu.Hours as AssignedHours,
						ISNULL(tu.ServiceKey, @DefaultServiceKey) as ServiceKey,
						CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, ISNULL(t.PercComp, 0)) END AS AssignedPercComp   
					from tTask t (nolock)
						Inner join tTaskUser tu (nolock) on tu.TaskKey = t.TaskKey
						inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
						inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
						LEFT OUTER JOIN tCompany c (nolock) on c.CompanyKey = p.ClientKey
						LEFT OUTER JOIN tUser u (nolock) ON p.BillingContact = u.UserKey
						
					Where 
						tu.UserKey = @UserKey and
						p.ProjectStatusKey = @ProjectStatusKey AND
						((ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) or (ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)) and
						ISNULL(ps.OnHold, 0) = 0 and
						t.PlanComplete <= @EndDate
					Order By t.PlanComplete
END
ELSE
BEGIN
	-- Started By
	
	-- All Projects
	if @ProjectStatusKey = -3
		Select 
			p.ProjectKey,
			p.ProjectNumber,
			p.ProjectName,
			p.WorkMon,
			p.WorkTue,
			p.WorkWed,
			p.WorkThur,
			p.WorkFri,
			p.WorkSat,
			p.WorkSun,
			c.CustomerID,
			t.*,
			u.FirstName + ' ' + u.LastName as PrimaryContact,
			u.Phone1,
			u.Email,
			c.CompanyName,
			c.Phone,
			tu.Hours as AssignedHours,
			ISNULL(tu.ServiceKey, @DefaultServiceKey) as ServiceKey,
			CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, ISNULL(t.PercComp, 0)) END AS AssignedPercComp   
		from tTask t (nolock)
			Inner join tTaskUser tu (nolock) on tu.TaskKey = t.TaskKey
			inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
			inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			LEFT OUTER JOIN tCompany c (nolock) on c.CompanyKey = p.ClientKey
			LEFT OUTER JOIN tUser u (nolock) ON p.BillingContact = u.UserKey
		Where 
			tu.UserKey = @UserKey and
			((ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) or (ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)) and
			ISNULL(ps.OnHold, 0) = 0 and
			t.PlanStart <= @EndDate
		Order By t.PlanComplete	
	else
		-- All Active
		if @ProjectStatusKey = -1
			Select 
				p.ProjectKey,
				p.ProjectNumber,
				p.ProjectName,
				p.WorkMon,
				p.WorkTue,
				p.WorkWed,
				p.WorkThur,
				p.WorkFri,
				p.WorkSat,
				p.WorkSun,
				c.CustomerID,
				t.*,
				u.FirstName + ' ' + u.LastName as PrimaryContact,
				u.Phone1,
				u.Email,
				c.CompanyName,
				c.Phone,
				tu.Hours as AssignedHours,
				ISNULL(tu.ServiceKey, @DefaultServiceKey) as ServiceKey,
				CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, ISNULL(t.PercComp, 0)) END AS AssignedPercComp   
			from tTask t (nolock)
				Inner join tTaskUser tu (nolock) on tu.TaskKey = t.TaskKey
				inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
				inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
				LEFT OUTER JOIN tCompany c (nolock) on c.CompanyKey = p.ClientKey
				LEFT OUTER JOIN tUser u (nolock) ON p.BillingContact = u.UserKey
			Where 
				tu.UserKey = @UserKey and
				((ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) or (ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)) and
				p.Active = 1 AND
				ps.IsActive = 1 AND
				ISNULL(ps.OnHold, 0) = 0 and
				t.PlanStart <= @EndDate
			Order By t.PlanComplete
			
		else
			-- All Inactive
			if @ProjectStatusKey = -2
				Select 
					p.ProjectKey,
					p.ProjectNumber,
					p.ProjectName,
					p.WorkMon,
					p.WorkTue,
					p.WorkWed,
					p.WorkThur,
					p.WorkFri,
					p.WorkSat,
					p.WorkSun,
					c.CustomerID,
					t.*,
					u.FirstName + ' ' + u.LastName as PrimaryContact,
					u.Phone1,
					u.Email,
					c.CompanyName,
					c.Phone,
					tu.Hours as AssignedHours,
					ISNULL(tu.ServiceKey, @DefaultServiceKey) as ServiceKey,
					CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, ISNULL(t.PercComp, 0)) END AS AssignedPercComp   
				from tTask t (nolock)
					Inner join tTaskUser tu (nolock) on tu.TaskKey = t.TaskKey
					inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
					inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
					LEFT OUTER JOIN tCompany c (nolock) on c.CompanyKey = p.ClientKey
					LEFT OUTER JOIN tUser u (nolock) ON p.BillingContact = u.UserKey
				Where 
					tu.UserKey = @UserKey and
					((ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) or (ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)) and
					p.Active = 0 AND
					ps.IsActive = 1 AND
					ISNULL(ps.OnHold, 0) = 0 and
					t.PlanStart <= @EndDate
				Order By t.PlanComplete
			else
				if @ProjectStatusKey = -4 -- Remove tasks with incomplete predecessors
					Select 
						p.ProjectKey,
						p.ProjectNumber,
						p.ProjectName,
						p.WorkMon,
						p.WorkTue,
						p.WorkWed,
						p.WorkThur,
						p.WorkFri,
						p.WorkSat,
						p.WorkSun,
						c.CustomerID,
						t.*,
						u.FirstName + ' ' + u.LastName as PrimaryContact,
						u.Phone1,
						u.Email,
						c.CompanyName,
						c.Phone,
						tu.Hours as AssignedHours,
						ISNULL(tu.ServiceKey, @DefaultServiceKey) as ServiceKey,
						CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, ISNULL(t.PercComp, 0)) END AS AssignedPercComp   
					from tTask t (nolock)
						Inner join tTaskUser tu (nolock) on tu.TaskKey = t.TaskKey
						inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
						inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
						LEFT OUTER JOIN tCompany c (nolock) on c.CompanyKey = p.ClientKey
						LEFT OUTER JOIN tUser u (nolock) ON p.BillingContact = u.UserKey

					where   tu.UserKey = @UserKey   
					and		p.Active = 1
					and		ps.IsActive = 1
					and		ISNULL(ps.OnHold, 0) <> 1
					and		t.PredecessorsComplete = 1
					and		((ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) or (ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)) 
					and		t.PlanStart <= @EndDate
					and		t.PredecessorsComplete = 1
				else
					-- For a specific status
					Select 
						p.ProjectKey,
						p.ProjectNumber,
						p.ProjectName,
						p.WorkMon,
						p.WorkTue,
						p.WorkWed,
						p.WorkThur,
						p.WorkFri,
						p.WorkSat,
						p.WorkSun,
						c.CustomerID,
						t.*,
						u.FirstName + ' ' + u.LastName as PrimaryContact,
						u.Phone1,
						u.Email,
						c.CompanyName,
						c.Phone,
						tu.Hours as AssignedHours,
						ISNULL(tu.ServiceKey, @DefaultServiceKey) as ServiceKey,
						CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, ISNULL(t.PercComp, 0)) END AS AssignedPercComp   
					from tTask t (nolock)
						Inner join tTaskUser tu (nolock) on tu.TaskKey = t.TaskKey
						inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
						inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
						LEFT OUTER JOIN tCompany c (nolock) on c.CompanyKey = p.ClientKey
						LEFT OUTER JOIN tUser u (nolock) ON p.BillingContact = u.UserKey
					Where 
						tu.UserKey = @UserKey and
						((ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) or (ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)) and
						p.ProjectStatusKey = @ProjectStatusKey AND
						ISNULL(ps.OnHold, 0) = 0 and
						t.PlanStart <= @EndDate
					Order By t.PlanComplete
END
GO
