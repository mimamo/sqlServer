USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceOVERBUDGETSERVICE]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserPreferenceOVERBUDGETSERVICE]

	@UserKey int,
	@Value int,
	@Value2 int

AS --Encrypt

/*
|| When     Who Rel		   What
|| 12/10/12 GWG 10.5.6.3   Added an all projects option
|| 04/15/13 RLB 10.5.6.7   (166172) Added Total Actual Hours on project and Estimated Project hours to query
*/

-- Value or Mode
-- 1 = My Assigned Projects
-- 2 = Where I am the account manager
-- 3 = In my office

-- Value2
-- 0 all projects over budget
-- 5 5% over budget
-- 10 10% over budget
-- etc...
-- 90 90% over budget
-- 100 100% and up over budget


Declare @CompanyKey int
Declare @OfficeKey int

Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey), @OfficeKey = OfficeKey from tUser (NOLOCK) Where UserKey = @UserKey

DECLARE @PercentOver AS DECIMAL(9, 3)
SELECT  @PercentOver = CAST(@Value2 AS DECIMAL(9, 3)) / 100.0

-- Just compare labor for service
if @Value = 1
select * from
	(
	Select 
		p.ProjectNumber
		,p.ProjectName
		,s.ServiceCode
		,s.Description
		,ISNULL((Select SUM(ROUND(ActualHours, 2)) 
			from tTime (nolock) where tTime.ProjectKey = p.ProjectKey
			and tTime.ServiceKey = pes.EntityKey), 0) as ActualHours
		,ISNULL((Select SUM(ROUND(ActualHours * ActualRate, 2)) 
			from tTime (nolock) where tTime.ProjectKey = p.ProjectKey
			and tTime.ServiceKey = pes.EntityKey), 0) as ActualLabor
		,pes.Gross  -- contains labor
		,ISNULL((Select SUM(Round(Qty, 2)) from tProjectEstByItem (nolock) where tProjectEstByItem.Entity = 'tService' 
			and tProjectEstByItem.ProjectKey = p.ProjectKey and tProjectEstByItem.EntityKey = s.ServiceKey), 0) as EstHours 
		From tProject p (nolock)
			inner join tProjectEstByItem pes (NOLOCK) on pes.ProjectKey = p.ProjectKey
			inner join tService s (NOLOCK) on pes.EntityKey = s.ServiceKey    -- i.e. ignore pes.ServiceKey = 0 records
	where p.Active = 1
	and	  p.Closed = 0	
	and   p.CompanyKey = @CompanyKey
	and   pes.Entity = 'tService'
	and   pes.Gross  > 0
	and   p.ProjectKey in (select ProjectKey from tAssignment (nolock) where UserKey = @UserKey)
	) As b		
where
		ActualLabor >= Gross  * (1 + @PercentOver )
Order By
		ProjectNumber, ServiceCode
		
if @Value = 2
select * from
	(
	Select 
		p.ProjectNumber
		,p.ProjectName
		,s.ServiceCode
		,s.Description
		,ISNULL((Select SUM(ROUND(ActualHours, 2)) 
			from tTime (nolock) where tTime.ProjectKey = p.ProjectKey
			and tTime.ServiceKey = pes.EntityKey), 0) as ActualHours
		,ISNULL((Select SUM(ROUND(ActualHours * ActualRate, 2)) 
			from tTime (nolock) where tTime.ProjectKey = p.ProjectKey
			and tTime.ServiceKey = pes.EntityKey), 0) as ActualLabor
		,pes.Gross  -- contains labor
		,ISNULL((Select SUM(Round(Qty, 2)) from tProjectEstByItem (nolock) where tProjectEstByItem.Entity = 'tService' 
			and tProjectEstByItem.ProjectKey = p.ProjectKey and tProjectEstByItem.EntityKey = s.ServiceKey), 0) as EstHours 
		From tProject p (nolock)
			inner join tProjectEstByItem pes (NOLOCK) on pes.ProjectKey = p.ProjectKey
			inner join tService s (NOLOCK) on pes.EntityKey = s.ServiceKey    -- i.e. ignore pes.ServiceKey = 0 records
	where p.Active = 1
	and	  p.Closed = 0	
	and   p.CompanyKey = @CompanyKey
	and   pes.Entity = 'tService'
	and   pes.Gross  > 0
	and   p.AccountManager = @UserKey
	) As b		
where
		ActualLabor >= Gross  * (1 + @PercentOver )
Order By
		ProjectNumber, ServiceCode
		
		
if @Value = 3
select * from
	(
	Select 
		p.ProjectNumber
		,p.ProjectName
		,s.ServiceCode
		,s.Description
		,ISNULL((Select SUM(ROUND(ActualHours, 2)) 
			from tTime (nolock) where tTime.ProjectKey = p.ProjectKey
			and tTime.ServiceKey = pes.EntityKey), 0) as ActualHours
		,ISNULL((Select SUM(ROUND(ActualHours * ActualRate, 2)) 
			from tTime (nolock) where tTime.ProjectKey = p.ProjectKey
			and tTime.ServiceKey = pes.EntityKey), 0) as ActualLabor
		,pes.Gross  -- contains labor
		,ISNULL((Select SUM(Round(Qty, 2)) from tProjectEstByItem (nolock) where tProjectEstByItem.Entity = 'tService' 
			and tProjectEstByItem.ProjectKey = p.ProjectKey and tProjectEstByItem.EntityKey = s.ServiceKey), 0) as EstHours 
		From tProject p (nolock)
			inner join tProjectEstByItem pes (NOLOCK) on pes.ProjectKey = p.ProjectKey
			inner join tService s (NOLOCK) on pes.EntityKey = s.ServiceKey    -- i.e. ignore pes.ServiceKey = 0 records
	where p.Active = 1
	and	  p.Closed = 0
	and   p.CompanyKey = @CompanyKey
	and   pes.Entity = 'tService'
	and   pes.Gross  > 0
	and   p.OfficeKey = @OfficeKey
	) As b		
where
		ActualLabor >= Gross  * (1 + @PercentOver )
Order By
		ProjectNumber, ServiceCode



if @Value = 4
BEGIN



DECLARE	@SecurityGroupKey int
DECLARE @Administrator int
DECLARE @RestrictToGLCompany int
Select @RestrictToGLCompany = isnull(RestrictToGLCompany, 0) from tPreference (nolock) where CompanyKey = @CompanyKey
select @SecurityGroupKey = SecurityGroupKey, @Administrator = ISNULL(Administrator, 0) from tUser (nolock) where UserKey = @UserKey

if @Administrator = 0
	if exists(Select 1 from tRightAssigned (nolock) Where EntityKey = @SecurityGroupKey and RightKey = 90918)
		Select @Administrator = 1

select * from
	(
	Select 
		p.ProjectNumber
		,p.ProjectName
		,s.ServiceCode
		,s.Description
		,ISNULL((Select SUM(ROUND(ActualHours, 2)) 
			from tTime (nolock) where tTime.ProjectKey = p.ProjectKey
			and tTime.ServiceKey = pes.EntityKey), 0) as ActualHours
		,ISNULL((Select SUM(ROUND(ActualHours * ActualRate, 2)) 
			from tTime (nolock) where tTime.ProjectKey = p.ProjectKey
			and tTime.ServiceKey = pes.EntityKey), 0) as ActualLabor
		,pes.Gross  -- contains labor
		,ISNULL((Select SUM(Round(Qty, 2)) from tProjectEstByItem (nolock) where tProjectEstByItem.Entity = 'tService' 
			and tProjectEstByItem.ProjectKey = p.ProjectKey and tProjectEstByItem.EntityKey = s.ServiceKey), 0) as EstHours 
		From tProject p (nolock)
			inner join tProjectEstByItem pes (NOLOCK) on pes.ProjectKey = p.ProjectKey
			inner join tService s (NOLOCK) on pes.EntityKey = s.ServiceKey    -- i.e. ignore pes.ServiceKey = 0 records
	where p.Active = 1
	and	  p.Closed = 0	
	and   p.CompanyKey = @CompanyKey
	and   pes.Entity = 'tService'
	and   pes.Gross  > 0
	and   (@Administrator = 1 OR p.ProjectKey in (Select ProjectKey from tAssignment (nolock) Where UserKey = @UserKey))
	and   (@RestrictToGLCompany = 0 Or p.GLCompanyKey in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey) )
	) As b		
where
		ActualLabor >= Gross  * (1 + @PercentOver )
Order By
		ProjectNumber, ServiceCode


END

return 1
GO
