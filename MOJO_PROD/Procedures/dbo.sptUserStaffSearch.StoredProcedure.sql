USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserStaffSearch]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserStaffSearch]
	@CompanyKey int,
	@DepartmentKey int, -- -1 All, 0 blank, >0 
	@OfficeKey int,		-- -1 All, 0 blank, >0 
	@GLCompanyKey int	-- -1 All, 0 blank, >0 
AS --Encrypt

/*
|| When      Who Rel      What
|| 05/17/12  GHL 10.556   Created for the Add User of the project screen
*/

Declare @OwnerCompanyKey int
Select @OwnerCompanyKey = OwnerCompanyKey
from   tCompany (nolock)
where  CompanyKey = @CompanyKey

If isnull(@OwnerCompanyKey, 0) > 0
	Select @CompanyKey = @OwnerCompanyKey 

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
From   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

-- No nulls
select @DepartmentKey = isnull(@DepartmentKey, -1)
select @OfficeKey = isnull(@OfficeKey, -1)
select @GLCompanyKey = isnull(@GLCompanyKey, -1)


	select u.*
	      ,ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS UserName
		  ,SUBSTRING(ISNULL(u.FirstName, ''),1,1) + SUBSTRING(ISNULL(u.MiddleName, ''),1,1) + SUBSTRING(ISNULL(u.LastName, ''),1,1) AS Initials			
		  
		  ,o.OfficeName	
		  ,d.DepartmentName	
		  ,glc.GLCompanyID
		  ,glc.GLCompanyName
		  ,s.Description AS ServiceDescription
		  ,s.ServiceCode
		  ,0 AS ASC_Selected
		  	
	from   tUser u (nolock)

	left join tGLCompany glc (nolock) on u.GLCompanyKey = glc.GLCompanyKey
	left join tOffice o (nolock) on u.OfficeKey = o.OfficeKey
	left join tDepartment d (nolock) on u.DepartmentKey = d.DepartmentKey
	left join tService s (nolock) on u.DefaultServiceKey = s.ServiceKey

	where (
		-- Employees
		u.CompanyKey = @CompanyKey
		-- Contractors/CLients/etc
		OR (u.OwnerCompanyKey = @CompanyKey and u.ClientVendorLogin = 0 and u.UserID is not null and u.Password is not null and u.Active = 1)
		)

    -- for the project assignment, we want to be able to add users from other Gl comps to the project regardless of security
	and (@GLCompanyKey = -1 Or
			(
				(@RestrictToGLCompany = 0 and isnull(u.GLCompanyKey, 0) = @GLCompanyKey )
				Or
			    (@RestrictToGLCompany = 1 and @GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = u.UserKey) )
			)
		)

	and (@OfficeKey = -1 Or isnull(u.OfficeKey, 0) = @OfficeKey)

	and (@DepartmentKey = -1 Or isnull(u.DepartmentKey, 0) = @DepartmentKey)

	ORDER BY u.FirstName, u.LastName
GO
