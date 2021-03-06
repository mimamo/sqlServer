USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_CopyFieldSet]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_CopyFieldSet]

		 @CustomFieldKey int
		,@CopyFieldValues tinyint
		,@ObjectFieldSetKey int output

AS

declare @FieldSetKey int

    IF ISNULL(@CustomFieldKey,0) > 0
		BEGIN
			SELECT	@FieldSetKey = FieldSetKey
			FROM	tObjectFieldSet (NOLOCK)
			WHERE	ObjectFieldSetKey = @CustomFieldKey
			
			EXEC spCF_tObjectFieldSetInsert @FieldSetKey, @ObjectFieldSetKey OUTPUT
			
			-- copy field values if requested
			IF ISNULL(@CopyFieldValues,0) = 1
				IF ISNULL(@ObjectFieldSetKey,0) > 0
					INSERT	tFieldValue
							(FieldValueKey, FieldDefKey, ObjectFieldSetKey, FieldValue)
					SELECT	newid(), FieldDefKey, @ObjectFieldSetKey, FieldValue
					FROM	tFieldValue (NOLOCK)
					WHERE	ObjectFieldSetKey = @CustomFieldKey
		END
    
	return 1
GO
