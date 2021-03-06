USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentTypeGetActiveList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentTypeGetActiveList]

	@CompanyKey int,
	@TaskAssignmentTypeKey int = NULL

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
*/

	SELECT	*
	FROM	tTaskAssignmentType (NOLOCK) 
	WHERE	CompanyKey = @CompanyKey 
	AND		(Active = 1 OR TaskAssignmentTypeKey = @TaskAssignmentTypeKey)
	Order By TaskAssignmentType

	RETURN 1
GO
