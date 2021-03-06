USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptColumnSetDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptColumnSetDelete]
	@ColumnSetKey int
AS --Encrypt

/*
|| When     Who Rel    What
|| 09/28/12 MFT 10.560 Created
*/

DELETE
FROM
	tColumnSetDetail
WHERE
	ColumnSetKey = @ColumnSetKey

DELETE
FROM
	tColumnSet
WHERE
	ColumnSetKey = @ColumnSetKey
GO
