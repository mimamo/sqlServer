USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskGet]

	@MasterTaskKey int

AS --Encrypt

		SELECT tm.*
			  ,wt.WorkTypeName
			  ,tat.TaskAssignmentType
		FROM tMasterTask tm (NOLOCK)
			LEFT OUTER JOIN tWorkType wt (NOLOCK) ON tm.WorkTypeKey = wt.WorkTypeKey
			left outer join tTaskAssignmentType tat (nolock) on tm.TaskAssignmentTypeKey = tat.TaskAssignmentTypeKey
		WHERE
			tm.MasterTaskKey = @MasterTaskKey
		

	RETURN 1
GO
