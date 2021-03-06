USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFlatFileGetList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFlatFileGetList]
	@CompanyKey int,
	@Type tinyint = NULL
AS --Encrypt

/*
|| When     Who Rel    What
|| 04/17/12 MFT 10.555 Created
*/

SELECT
	*
FROM
	tFlatFile (nolock)
WHERE
	CompanyKey = @CompanyKey AND
	(
		ISNULL(@Type, 0) = 0 OR
		Type = @Type
	)
ORDER BY
	LayoutName
GO
