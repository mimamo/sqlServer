USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeGetList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeGetList]

	@CompanyKey int
	,@ProjectTypeKey int = NULL	--Null: Show Active = 1 only
								--Not NULL, include the specified type along with the Active ones (used on Project setup screen)
								-- -1, include all Status values regardless of Active flag (used on maintenance screen listing)

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/13/08   GHL 8.510  (26090) Added @ProjectTypeKey parameter.
||                       Same logic as sptProjectBillingStatusGetList 
*/
		SELECT *
		FROM 
			tProjectType (NOLOCK) 
		WHERE
				CompanyKey = @CompanyKey
		AND		(Active = 1 OR 
				 ProjectTypeKey = @ProjectTypeKey OR 
				 @ProjectTypeKey = -1)
		ORDER BY
			Active DESC, ProjectTypeName

	RETURN 1
GO
