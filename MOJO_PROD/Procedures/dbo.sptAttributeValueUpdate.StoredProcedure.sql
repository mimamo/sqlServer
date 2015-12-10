USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeValueUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeValueUpdate]
	@AttributeValueKey int,
	@AttributeValue varchar(200)

AS --Encrypt

	UPDATE
		tAttributeValue
	SET
		AttributeValue = @AttributeValue
	WHERE
		AttributeValueKey = @AttributeValueKey 

	RETURN 1
GO
