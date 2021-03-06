USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptColumnSetGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptColumnSetGet]
	@ColumnSetKey int
AS --Encrypt

/*
|| When     Who Rel    What
|| 09/28/12 MFT 10.560 Created
*/

SELECT
	*
FROM
	tColumnSet cs (nolock)
WHERE
	cs.ColumnSetKey = @ColumnSetKey

SELECT
	*
FROM
	tColumnSetDetail csd (nolock)
WHERE
	csd.ColumnSetKey = @ColumnSetKey
GO
