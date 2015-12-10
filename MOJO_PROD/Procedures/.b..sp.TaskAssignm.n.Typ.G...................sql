USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentTypeGet]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentTypeGet]
	@TaskAssignmentTypeKey int

AS --Encrypt

		SELECT *, 
		(Select FieldSetKey from tFieldSet (NOLOCK) Where tFieldSet.OwnerEntityKey = @TaskAssignmentTypeKey and AssociatedEntity = 'TaskAssignmentTypes') as FieldSetKey
		FROM tTaskAssignmentType (NOLOCK) 
		WHERE
			TaskAssignmentTypeKey = @TaskAssignmentTypeKey

	RETURN 1
GO
