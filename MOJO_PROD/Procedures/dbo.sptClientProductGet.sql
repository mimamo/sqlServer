USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientProductGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClientProductGet]
	@ClientProductKey int

AS --Encrypt

		SELECT *
		FROM tClientProduct (nolock)
		WHERE
			ClientProductKey = @ClientProductKey

	RETURN 1
GO
