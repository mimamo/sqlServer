USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentProjectAllList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAssignmentProjectAllList]
 (
  @ProjectKey int,
  @KeysOnly tinyint = 0,
  @ActiveOnly tinyint = 0
 )
AS --Encrypt

  /*
  || When     Who Rel   What
  || 11/22/06 GHL 8.4   Added @ActiveOnly parameter so that assigned users are active only
  ||                    to match active users in other drop downs on Flash interface 
  || 12/14/06 GHL 8.4   Added DepartmentKey,etc.. to make it consistent with sptUserGetProjectAvailableList
  ||                    since various lists are merged now in Flash
  */
  
if @KeysOnly = 0
	SELECT tUser.UserKey,
	tUser.FirstName + ' ' + tUser.LastName AS UserName, 
	tUser.FirstName,
	tUser.LastName,
	tUser.DepartmentKey, 
	tUser.OfficeKey,
	tUser.NoUnassign,
	tCompany.CompanyName,
	tAssignment.AssignmentKey,
	tAssignment.HourlyRate
	FROM tAssignment (nolock) 
		INNER JOIN tUser (nolock) ON tAssignment.UserKey = tUser.UserKey 
		INNER JOIN tCompany (nolock) ON tUser.CompanyKey = tCompany.CompanyKey
	WHERE tAssignment.ProjectKey = @ProjectKey
	AND   (@ActiveOnly = 0 OR tUser.Active = 1)
	ORDER BY tCompany.CompanyName, tUser.FirstName
else
	SELECT *
	FROM tAssignment (nolock) 
		INNER JOIN tUser (nolock) ON tAssignment.UserKey = tUser.UserKey 	
	WHERE tAssignment.ProjectKey = @ProjectKey
	AND   (@ActiveOnly = 0 OR tUser.Active = 1)
GO
