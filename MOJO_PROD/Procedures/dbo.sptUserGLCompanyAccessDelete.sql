USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGLCompanyAccessDelete]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGLCompanyAccessDelete]
	(
	@UserKey int
	)
AS

Delete tUserGLCompanyAccess Where UserKey = @UserKey
GO
