USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentGetUser]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAssignmentGetUser]
	@ProjectKey int,
	@UserKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 11/05/13  RLB 10.5.7.4 Created to return the project assigned user
*/

	SELECT	*
	FROM	tAssignment (nolock)
	WHERE	ProjectKey = @ProjectKey
	AND     UserKey = @UserKey
GO
