USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentTypeDelete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[sptTaskAssignmentTypeDelete]
	@TaskAssignmentTypeKey int

AS --Encrypt

Declare @FieldSetKey int

if exists(Select 1 from tMasterTaskAssignment (NOLOCK) Where TaskAssignmentTypeKey = @TaskAssignmentTypeKey)
	Return -2

if exists(Select 1 from tTaskAssignment (NOLOCK) Where TaskAssignmentTypeKey = @TaskAssignmentTypeKey)
	Return -1
	
Select @FieldSetKey = FieldSetKey from tFieldSet (NOLOCK) Where AssociatedEntity = 'TaskAssignmentTypes' and OwnerEntityKey = @TaskAssignmentTypeKey

	DELETE
	FROM tFieldValue
	WHERE
	ObjectFieldSetKey in (Select ObjectFieldSetKey from tObjectFieldSet (NOLOCK) Where FieldSetKey = @FieldSetKey)

	DELETE
	FROM tObjectFieldSet
	WHERE
	FieldSetKey = @FieldSetKey 

	DELETE
	FROM tFieldSetField
	WHERE
	FieldSetKey = @FieldSetKey 

	DELETE
	FROM tFieldSet
	WHERE
	FieldSetKey = @FieldSetKey 


	DELETE
	FROM tTaskAssignmentTypeService
	WHERE
		TaskAssignmentTypeKey = @TaskAssignmentTypeKey 
		
	DELETE
	FROM tTaskAssignmentType
	WHERE
		TaskAssignmentTypeKey = @TaskAssignmentTypeKey 

	RETURN 1
GO
