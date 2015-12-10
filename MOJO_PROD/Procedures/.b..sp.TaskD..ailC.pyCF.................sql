USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskDetailCopyCF]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskDetailCopyCF]
	@TaskKey int,
	@CustomFieldKey int

AS --ENCRYPT

	
declare @ObjectFieldSetKey int
declare @FieldSetKey int


	SELECT	@FieldSetKey = FieldSetKey
	FROM	tObjectFieldSet
	WHERE	ObjectFieldSetKey = @CustomFieldKey
	
	EXEC spCF_tObjectFieldSetInsert @FieldSetKey, @ObjectFieldSetKey OUTPUT
	
	IF ISNULL(@ObjectFieldSetKey,0) > 0
		INSERT	tFieldValue
				(FieldValueKey, FieldDefKey, ObjectFieldSetKey, FieldValue)
		SELECT	newid(), FieldDefKey, @ObjectFieldSetKey, FieldValue
		FROM	tFieldValue
		WHERE	ObjectFieldSetKey = @CustomFieldKey
		
	update tTask
	set CustomFieldKey = @ObjectFieldSetKey	
	where TaskKey = @TaskKey		

RETURN 1
GO
