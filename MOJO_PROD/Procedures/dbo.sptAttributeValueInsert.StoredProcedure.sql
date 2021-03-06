USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeValueInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeValueInsert]
	@AttributeKey int,
	@AttributeValue varchar(200),
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tAttributeValue
		(
		AttributeKey,
		AttributeValue
		)

	VALUES
		(
		@AttributeKey,
		@AttributeValue
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
