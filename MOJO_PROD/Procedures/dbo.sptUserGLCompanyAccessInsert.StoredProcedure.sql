USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGLCompanyAccessInsert]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGLCompanyAccessInsert]
	(
	@UserKey int,
	@GLCompanyKey int
	)

AS


 /*
  || When     Who Rel    What
  || 08/07/12 GHL 10.558 Added update of tUser.GLCompanyKey (default company) if none is selected
  */


if not exists (select 1 from tUser (nolock) where UserKey = @UserKey and isnull(GLCompanyKey, 0) > 0)
	And @GLCompanyKey > 0
	update tUser 
	set    GLCompanyKey = @GLCompanyKey
	where  UserKey = @UserKey

Insert tUserGLCompanyAccess (UserKey, GLCompanyKey)
Values (@UserKey, @GLCompanyKey)
GO
