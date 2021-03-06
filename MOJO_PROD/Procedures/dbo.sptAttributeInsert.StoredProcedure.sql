USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeInsert]
	@Entity varchar(50),
	@EntityKey int,
	@AttributeName varchar(200),
	@oIdentity INT OUTPUT
AS --Encrypt

declare @DisplayOrder int

	Select @DisplayOrder = ISNULL(Max(DisplayOrder), 0) + 1 from tAttribute (nolock) Where Entity = @Entity and EntityKey = @EntityKey

	INSERT tAttribute
		(
		Entity,
		EntityKey,
		AttributeName,
		DisplayOrder
		)

	VALUES
		(
		@Entity,
		@EntityKey,
		@AttributeName,
		@DisplayOrder
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
