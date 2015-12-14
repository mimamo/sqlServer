USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeUpdate]
	@AttributeKey int,
	@AttributeName varchar(200)

AS --Encrypt

	UPDATE
		tAttribute
	SET
		AttributeName = @AttributeName
	WHERE
		AttributeKey = @AttributeKey 

	RETURN 1
GO
