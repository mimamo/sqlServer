USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeEntityValueInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeEntityValueInsert]
	@Entity varchar(50),
	@EntityKey int,
	@AttributeValueKey int
	
AS --Encrypt

	INSERT tAttributeEntityValue
		(
		Entity,
		EntityKey,
		AttributeValueKey
		)

	VALUES
		(
		@Entity,
		@EntityKey,
		@AttributeValueKey
		)
GO
