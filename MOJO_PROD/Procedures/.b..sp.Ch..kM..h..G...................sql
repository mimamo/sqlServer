USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckMethodGet]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckMethodGet]
	@CheckMethodKey int

AS --Encrypt

		SELECT *
		FROM tCheckMethod (nolock)
		WHERE
			CheckMethodKey = @CheckMethodKey

	RETURN 1
GO
