USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFlatFileGet]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFlatFileGet]
	@FlatFileKey int
AS --Encrypt

/*
|| When     Who Rel    What
|| 04/17/12 MFT 10.555 Created
|| 07/10/12 MFT 10.558 Added VoidOverride
|| 10/10/13 MFT 10.573 Added ORDER BY to detail set
*/

SELECT *
FROM tFlatFile ff (nolock)
WHERE ff.FlatFileKey = @FlatFileKey

SELECT
	*,
	CASE WHEN VoidOverrideValue IS NOT NULL THEN 1 ELSE 0 END AS VoidOverride
FROM tFlatFileDetail ffd (nolock)
WHERE ffd.FlatFileKey = @FlatFileKey
ORDER BY StartIndex
GO
