USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptNoteUpdate]
	@NoteKey int,
	@NoteGroupKey int,
	@Subject varchar(300),
	@NoteField text,
	@InactiveDate smalldatetime,
	@DateUpdated smalldatetime,
	@UpdatedBy int,
	@Entity varchar(50) = NULL,
	@EntityKey int = NULL

AS --Encrypt

/*
|| When      Who Rel      What
|| 3/25/08   CRG 1.0.0.0  Added Entity and EntityKey optional parameters for WMJ
|| 8/7/08    CRG 10.5.0.0 Changed NoteField to text
*/

	IF @Entity IS NULL
		SELECT	@Entity = Entity,
				@EntityKey = EntityKey
		FROM	tNote (nolock)
		WHERE	NoteKey = @NoteKey

	IF @NoteGroupKey IS NULL
		SELECT	@NoteGroupKey = NoteGroupKey
		FROM	tNote (nolock)
		WHERE	NoteKey = @NoteKey

	UPDATE
		tNote
	SET
		NoteGroupKey = @NoteGroupKey,
		Subject = @Subject,
		NoteField = @NoteField,
		InactiveDate = @InactiveDate,
		DateUpdated = @DateUpdated,
		UpdatedBy = @UpdatedBy,
		Entity = @Entity,
		EntityKey = @EntityKey
	WHERE
		NoteKey = @NoteKey 

	RETURN 1
GO
