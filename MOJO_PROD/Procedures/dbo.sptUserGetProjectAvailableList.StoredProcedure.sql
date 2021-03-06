USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetProjectAvailableList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetProjectAvailableList]

	(
		@CompanyKey int
		,@ProjectKey int = null
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 11/01/06 GHL 8.4   Added NoUnassign column for reassign function
  || 11/15/06 GHL 8.4   Added ProjectKey parameter to get people assigned to a project  
  || 03/14/07 GHL 8.4   Removed restriction Active = 1 when getting users in tAssignment
  ||                    This creates a problem in Flash user grid when we assign and then set inactive                    
  || 01/02/08 GHL 8.5   Changed OR in where clause by UNION to speed up perfo
  */

  
If @ProjectKey Is Null
 
/*  
Select
	UserKey, FirstName, LastName, MiddleName, DepartmentKey, OfficeKey, NoUnassign
From
	tUser (nolock)
Where
	(OwnerCompanyKey = @CompanyKey and
	Len(UserID) > 0 and
	ClientVendorLogin = 0 And
	Active = 1)
	OR
	(CompanyKey = @CompanyKey and Active = 1)
Order By
	FirstName, LastName
*/

	Select UserKey, FirstName, LastName, MiddleName, DepartmentKey, OfficeKey, NoUnassign
	From
		tUser (nolock)
	Where
		OwnerCompanyKey = @CompanyKey 
		and Len(UserID) > 0 and
		ClientVendorLogin = 0 And
		Active = 1
		
	UNION
	
	Select UserKey, FirstName, LastName, MiddleName, DepartmentKey, OfficeKey, NoUnassign
	From
		tUser (nolock)
	Where
		CompanyKey = @CompanyKey 
		and Active = 1
			
	Order By
	FirstName, LastName	
	
Else

/*
Select
	UserKey, FirstName, LastName, MiddleName, DepartmentKey, OfficeKey, NoUnassign
From
	tUser (nolock)
Where
	(OwnerCompanyKey = @CompanyKey and
	Len(UserID) > 0 and
	ClientVendorLogin = 0 And
	Active = 1)
	OR
	(CompanyKey = @CompanyKey and Active = 1)
	OR
	(UserKey IN (SELECT UserKey FROM tAssignment (NOLOCK) WHERE ProjectKey = @ProjectKey)
	)
Order By
	FirstName, LastName
*/

	Select UserKey, FirstName, LastName, MiddleName, DepartmentKey, OfficeKey, NoUnassign
	From
		tUser (nolock)
	Where
		OwnerCompanyKey = @CompanyKey 
		and Len(UserID) > 0 and
		ClientVendorLogin = 0 And
		Active = 1
		
	UNION
	
	Select UserKey, FirstName, LastName, MiddleName, DepartmentKey, OfficeKey, NoUnassign
	From
		tUser (nolock)
	Where
		CompanyKey = @CompanyKey 
		and Active = 1
		
	UNION
	
	Select a.UserKey, u.FirstName, u.LastName, u.MiddleName, u.DepartmentKey, u.OfficeKey, u.NoUnassign
	From
		tAssignment a (nolock)
	Inner Join 	
		tUser u (nolock) on a.UserKey = u.UserKey
	Where a.ProjectKey = @ProjectKey
		
	Order By
	FirstName, LastName
GO
