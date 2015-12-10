USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeValueDelete]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeValueDelete]
	@AttributeValueKey int

AS --Encrypt

	DELETE
	FROM tAttributeEntityValue
	WHERE
		AttributeValueKey = @AttributeValueKey 

	DELETE
	FROM tAttributeValue
	WHERE
		AttributeValueKey = @AttributeValueKey 

	RETURN 1
GO
