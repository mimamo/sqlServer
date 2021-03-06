USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientDivisionGetActiveList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClientDivisionGetActiveList]

	@ClientKey int,
	@ClientDivisionKey int = NULL

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
*/

	SELECT	*
	FROM	tClientDivision (nolock)
	WHERE	ClientKey = @ClientKey
	AND		(Active = 1 OR ClientDivisionKey = @ClientDivisionKey)
	order by DivisionName
	
	RETURN 1
GO
