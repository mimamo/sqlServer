USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeValueGetList]    Script Date: 12/10/2015 12:30:22 ******/
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
