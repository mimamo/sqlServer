USE [MOJo_dev]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskDetailCopyCF]    Script Date: 04/29/2016 16:27:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter PROCEDURE [dbo].[sptTaskDetailCopyCF]
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

