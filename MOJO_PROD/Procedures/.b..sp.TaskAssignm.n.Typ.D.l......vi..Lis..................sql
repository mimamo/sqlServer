USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentTypeDeleteServiceList]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentTypeDeleteServiceList]
	(
		@TaskAssignmentTypeKey int
	)

AS --Encrypt

Delete tTaskAssignmentTypeService Where TaskAssignmentTypeKey = @TaskAssignmentTypeKey
GO
