USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptOfficeGetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptOfficeGetList]

	@CompanyKey int
	,@Active int = 1 -- -1: Show everything
	,@OfficeKey int = NULL

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
|| 10/11/07  CRG 8.5     Added OfficeID
|| 6/23/08   CRG 8.5.1.4 Added ability to pass -1 for Active in order to get all values regardless of whether they were active or not.
|| 7/16/08   CRG 8.5.1.6 (29678) If CMP85 explicitly sends in NULL, set @Active = -1.  If the parameter is not specified when called, we still want it to
||                       default to 1 for WMJ.
|| 7/16/08   GWG 8.5.1.6 added back the null flag as well because the old listings pass in null
*/

	--If CMP85 explicitly passes in NULL, set @Active = -1.
	IF @Active IS NULL
		SELECT @Active = -1

	SELECT	OfficeKey, CompanyKey, OfficeName, ProjectNumPrefix, NextProjectNum, 
			ISNULL(Active, 1) AS Active, OfficeID
	FROM	tOffice (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	AND		((@Active is null) OR (@Active = -1) OR (ISNULL(Active, 1) = @Active) OR (OfficeKey = @OfficeKey))
	ORDER BY OfficeName

	RETURN 1
GO
