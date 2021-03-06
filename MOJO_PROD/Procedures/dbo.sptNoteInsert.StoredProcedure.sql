USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteInsert]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptNoteInsert]
	@NoteGroupKey int,
	@Subject varchar(300),
	@NoteField text,
	@InactiveDate smalldatetime,
	@DateCreated smalldatetime,
	@CreatedBy int,
	@DateUpdated smalldatetime,
	@UpdatedBy int,
	@oIdentity INT OUTPUT,
	@Entity varchar(50) = NULL,
	@EntityKey int = NULL
AS --Encrypt

/*
|| When      Who Rel     What
|| 3/25/08   CRG 1.0.0.0 Added Entity and EntityKey optional parameters for WMJ
|| 8/7/08    CRG 10.5.0.0 Changed NoteField to text
*/

	Declare @DisplayOrder int,
			@NoteOrder int

	IF @EntityKey IS NULL
		BEGIN
			Select @DisplayOrder = isnull(max(DisplayOrder), 0) from tNote (nolock) Where NoteGroupKey = @NoteGroupKey
			Select @DisplayOrder = @DisplayOrder + 1
			
			SELECT	@Entity = AssociatedEntity,
					@EntityKey = EntityKey
			FROM	tNoteGroup (nolock)
			WHERE	NoteGroupKey = @NoteGroupKey
		END
		
	SELECT	@NoteOrder = ISNULL(MAX(NoteOrder), 0)
	FROM	tNote (nolock)
	WHERE	Entity = @Entity
	AND		EntityKey = @EntityKey
	
	SELECT	@NoteOrder = @NoteOrder + 1
			
	INSERT tNote
		(
		NoteGroupKey,
		Subject,
		NoteField,
		DisplayOrder,
		InactiveDate,
		DateCreated,
		CreatedBy,
		DateUpdated,
		UpdatedBy,
		NoteOrder,
		Entity,
		EntityKey
		)

	VALUES
		(
		@NoteGroupKey,
		@Subject,
		@NoteField,
		@DisplayOrder,
		@InactiveDate,
		@DateCreated,
		@CreatedBy,
		@DateUpdated,
		@UpdatedBy,
		@NoteOrder,
		@Entity,
		@EntityKey
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
