USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentGetProjectList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAssignmentGetProjectList]
	@ProjectKey int
AS --Encrypt

/*
|| When      Who Rel     What
|| 4/16/08   CRG 1.0.0.0 Created to return all assigned users for the project
*/

	SELECT	*
	FROM	tAssignment (nolock)
	WHERE	ProjectKey = @ProjectKey
GO
