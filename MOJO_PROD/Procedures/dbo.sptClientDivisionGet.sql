USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientDivisionGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClientDivisionGet]
	@ClientDivisionKey int

AS --Encrypt

		SELECT *
		FROM tClientDivision (nolock)
		WHERE ClientDivisionKey = @ClientDivisionKey

	RETURN 1
GO
