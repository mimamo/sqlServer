USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStandardTextGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStandardTextGet]
	@StandardTextKey int

AS --Encrypt

		SELECT *
		FROM tStandardText (NOLOCK) 
		WHERE
			StandardTextKey = @StandardTextKey

	RETURN 1
GO
