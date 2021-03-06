USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTeamGetList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTeamGetList]
	@CompanyKey int
	,@Active tinyint
	,@TeamKey int = NULL

AS -- Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
*/

	SELECT	*
	FROM	tTeam (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	AND		((Active = @Active OR @Active IS NULL) OR (TeamKey = @TeamKey))

	RETURN 1
GO
