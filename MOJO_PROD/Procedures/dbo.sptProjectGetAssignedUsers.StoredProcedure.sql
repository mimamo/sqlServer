USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetAssignedUsers]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectGetAssignedUsers]
  @ProjectKey int,
  @IncludeAllEmps tinyint = 0
  
AS --Encrypt

 /*
  || When     Who Rel   What
  || 06/28/06 GHL 8.35  After testing at the Mudd Group, noticed that this sp takes
  ||                    too long to execute. Made mods to improve perfom
  || 12/20/09 GWG 10.5.1.5 Changed to lookup for all employees
  || 10/10/12 WDF 10.5.6.1 (151792) Added User Role
  */
  
	Declare @CompanyKey int
	Select @CompanyKey = CompanyKey 
	from tProject (nolock) 
	Where ProjectKey = @ProjectKey

if @IncludeAllEmps = 0
 select us.UserKey
       ,us.FirstName + ' ' + us.LastName as UserName
       ,us.LastName
       ,us.FirstName
       ,us.MiddleName
       ,us.Email
       ,ISNULL(us.ClientVendorLogin, 0) as ClientVendorLogin
       ,ag.HourlyRate
       ,d.DepartmentName
       ,us.UserRole AS [Role]
   from tUser us (nolock)
       inner join tAssignment ag (nolock) on ag.UserKey = us.UserKey
       inner join tCompany    c  (nolock) on us.CompanyKey = c.CompanyKey
       left outer join tDepartment d (nolock) on us.DepartmentKey = d.DepartmentKey
  where ag.ProjectKey = @ProjectKey
    and us.Active = 1
    and isnull(c.OwnerCompanyKey, c.CompanyKey) = @CompanyKey 
    
    order by UserName
else
BEGIN

 select us.UserKey
       ,us.FirstName + ' ' + us.LastName as UserName
       ,us.LastName
       ,us.FirstName
       ,us.MiddleName
       ,us.Email
       ,ISNULL(us.ClientVendorLogin, 0) as ClientVendorLogin
       ,us.HourlyRate
       ,d.DepartmentName
       ,Assigned
       ,case when Assigned = 1 then 'Assigned Team' else 'Others' end as UserGroup
       ,us.UserRole AS [Role]
   from tUser us (nolock)
	left outer join tDepartment d (nolock) on us.DepartmentKey = d.DepartmentKey
	left outer join (Select UserKey, 1 as Assigned from tAssignment (nolock) Where ProjectKey = @ProjectKey) as assigned on us.UserKey = assigned.UserKey
	Where us.CompanyKey = @CompanyKey
    and us.Active = 1
    
    UNION ALL
    
 select us.UserKey
       ,us.FirstName + ' ' + us.LastName as UserName
       ,us.LastName
       ,us.FirstName
       ,us.MiddleName
       ,us.Email
       ,ISNULL(us.ClientVendorLogin, 0) as ClientVendorLogin
       ,us.HourlyRate
       ,null
       ,1
       ,'Assigned Team' as UserGroup
       ,us.UserRole AS [Role]
  from tUser us (nolock)
	inner join tAssignment a (nolock) on us.UserKey = a.UserKey
	Where a.ProjectKey = @ProjectKey and us.OwnerCompanyKey = @CompanyKey
    
    
	Order By UserName

END
 return  1
GO
