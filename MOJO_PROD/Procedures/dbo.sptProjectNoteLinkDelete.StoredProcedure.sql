USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteLinkDelete]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteLinkDelete]
	(
		@ProjectNoteKey INT
		,@Entity VARCHAR(50)
		,@EntityKey INT 
	)
AS -- Encrypt
	
	SET NOCOUNT ON
	
	DELETE tProjectNoteLink
	WHERE  ProjectNoteKey = @ProjectNoteKey
	AND    Entity = @Entity
	AND    EntityKey = @EntityKey 
	
	RETURN 1
GO
