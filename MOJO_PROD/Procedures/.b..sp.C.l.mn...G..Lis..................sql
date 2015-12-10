USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptColumnSetGetList]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptColumnSetGetList]
	@CompanyKey int
AS --Encrypt

/*
|| When     Who Rel    What
|| 09/27/12 MFT 10.560 Created
*/

SELECT
	*
FROM
	tColumnSet (nolock)
WHERE
	CompanyKey = @CompanyKey
ORDER BY
	SetName
GO
