USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserInOutList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserInOutList]

	(
		@CompanyKey int,
		@UserKey int = null
	)

AS --Encrypt

  /*
  || 11/27/07 GHL 8.5 removed *= join for SQL 2005
  || 8/20/08  CRG 10.0.0.7 Wrapped DepartmentName with ISNULL to prevent error in Flex GroupingCollection
  || 07/27/12 RLB 10.5.5.8  Added HMI GL Company restrictions
  */


  Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
From   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)


  
Select
	u.FirstName + ' ' + u.LastName as UserName,
	u.UserKey,
	u.InOutStatus,
	u.InOutNotes,
	ISNULL(d.DepartmentName, '') AS DepartmentName
from
	tUser u (nolock)
	LEFT OUTER JOIN tDepartment d (nolock) ON u.DepartmentKey = d.DepartmentKey
where
	u.CompanyKey = @CompanyKey 
	and u.Active = 1
	and (@RestrictToGLCompany = 0 OR u.GLCompanyKey in(select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @UserKey))
order by
	d.DepartmentName, u.LastName
GO
