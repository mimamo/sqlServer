USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeValueGetList]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeValueGetList]

	@AttributeKey int


AS --Encrypt

		SELECT *
		FROM tAttributeValue (nolock)
		WHERE
		AttributeKey = @AttributeKey
		Order By AttributeValue

	RETURN 1
GO
