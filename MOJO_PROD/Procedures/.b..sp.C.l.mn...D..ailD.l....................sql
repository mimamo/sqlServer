USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptColumnSetDetailDelete]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptColumnSetDetailDelete]
	@ColumnSetDetailKey int
AS --Encrypt

/*
|| When     Who Rel    What
|| 09/28/12 MFT 10.560 Created
*/

DELETE
FROM
	tColumnSetDetail
WHERE
	ColumnSetDetailKey = @ColumnSetDetailKey
GO
