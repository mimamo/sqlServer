USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteLinkInsert]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteLinkInsert]
	(
		@ProjectNoteKey INT
		,@Entity VARCHAR(50)
		,@EntityKey INT
	)
	
AS -- Encrypt

	SET NOCOUNT ON
	
	INSERT tProjectNoteLink (ProjectNoteKey, Entity, EntityKey)
	VALUES (@ProjectNoteKey, @Entity, @EntityKey)
		
	RETURN 1
GO
