USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeGet]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeGet]
	@AttributeKey int

AS --Encrypt

		SELECT *
		FROM tAttribute (nolock)
		WHERE
			AttributeKey = @AttributeKey

	RETURN 1
GO
