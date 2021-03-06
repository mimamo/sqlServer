USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestDefSpecInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestDefSpecInsert]
	@RequestDefKey int,
	@FieldSetKey int,
	@Subject varchar(200),
	@Description varchar(500),
	@oIdentity INT OUTPUT
AS --Encrypt

Declare @DisplayOrder int

	Select @DisplayOrder = ISNULL(max(DisplayOrder), 0) + 1 from tRequestDefSpec (NOLOCK) Where RequestDefKey = @RequestDefKey

	INSERT tRequestDefSpec
		(
		RequestDefKey,
		FieldSetKey,
		Subject,
		Description,
		DisplayOrder
		)

	VALUES
		(
		@RequestDefKey,
		@FieldSetKey,
		@Subject,
		@Description,
		@DisplayOrder
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
