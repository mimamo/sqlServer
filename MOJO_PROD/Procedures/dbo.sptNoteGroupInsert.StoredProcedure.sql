USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteGroupInsert]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptNoteGroupInsert]
	@CompanyKey int,
	@GroupName varchar(200),
	@AssociatedEntity varchar(50),
	@EntityKey int,
	@Active tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

Declare @DisplayOrder int

	Select @DisplayOrder = isnull(max(DisplayOrder), 0) from tNoteGroup (nolock) Where AssociatedEntity = @AssociatedEntity and EntityKey = @EntityKey
	Select @DisplayOrder = @DisplayOrder + 1

	INSERT tNoteGroup
		(
		CompanyKey,
		GroupName,
		AssociatedEntity,
		EntityKey,
		DisplayOrder,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@GroupName,
		@AssociatedEntity,
		@EntityKey,
		@DisplayOrder,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
