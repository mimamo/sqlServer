USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityTypeGetList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityTypeGetList]

	@CompanyKey int,
	@Entity varchar(50) = NULL


AS --Encrypt

/*
|| When      Who Rel      What
|| 03/14/09  RTC 10.5.0.0 Initial Release
*/

if @Entity is null
	SELECT	a.*, StatusName, acs.AssignToKey, u.UserName
	FROM	tActivityType a (NOLOCK) 
	LEFT OUTER JOIN tActivityStatus acs (NOLOCK) on a.DefaultStatusKey = acs.ActivityStatusKey
	LEFT OUTER JOIN vUserName u (NOLOCK) on acs.AssignToKey = u.UserKey
	WHERE	a.CompanyKey = @CompanyKey and a.Entity is null
	Order By TypeName

else

	SELECT	a.*, StatusName, acs.AssignToKey, u.UserName
	FROM	tActivityType a (NOLOCK) 
	LEFT OUTER JOIN tActivityStatus acs (NOLOCK) on a.DefaultStatusKey = acs.ActivityStatusKey
	LEFT OUTER JOIN vUserName u (NOLOCK) on acs.AssignToKey = u.UserKey
	WHERE	a.CompanyKey = @CompanyKey and a.Entity = @Entity
	Order By TypeName

	RETURN 1
GO
