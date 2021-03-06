USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentTypeGetList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentTypeGetList]

	@CompanyKey int,
	@Active smallint = -1


AS --Encrypt

if @Active = -1
		SELECT *
		FROM tTaskAssignmentType (NOLOCK) 
		WHERE
		CompanyKey = @CompanyKey
		Order By TaskAssignmentType
else
		SELECT *
		FROM tTaskAssignmentType (NOLOCK) 
		WHERE
		CompanyKey = @CompanyKey and Active = @Active
		Order By TaskAssignmentType
	RETURN 1
GO
