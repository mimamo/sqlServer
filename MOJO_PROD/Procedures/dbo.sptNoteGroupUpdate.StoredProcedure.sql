USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteGroupUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptNoteGroupUpdate]
	@NoteGroupKey int,
	@CompanyKey int,
	@GroupName varchar(200),
	@AssociatedEntity varchar(50),
	@EntityKey int,
	@Active tinyint

AS --Encrypt

	UPDATE
		tNoteGroup
	SET
		CompanyKey = @CompanyKey,
		GroupName = @GroupName,
		AssociatedEntity = @AssociatedEntity,
		EntityKey = @EntityKey,
		Active = @Active
	WHERE
		NoteGroupKey = @NoteGroupKey 

	RETURN 1
GO
