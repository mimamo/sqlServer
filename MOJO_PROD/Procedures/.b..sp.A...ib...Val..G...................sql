USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeValueGet]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeValueGet]
	@AttributeValueKey int

AS --Encrypt

		SELECT *
		FROM tAttributeValue (nolock)
		inner join tAttribute (nolock) on tAttribute.AttributeKey = tAttributeValue.AttributeKey
		WHERE
			tAttributeValue.AttributeValueKey = @AttributeValueKey

	RETURN 1
GO
