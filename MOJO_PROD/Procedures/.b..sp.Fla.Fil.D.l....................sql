USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFlatFileDelete]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFlatFileDelete]
	@FlatFileKey int
AS --Encrypt

/*
|| When     Who Rel    What
|| 04/17/12 MFT 10.555 Created
*/

DELETE
FROM
	tFlatFileDetail
WHERE
	FlatFileKey = @FlatFileKey

DELETE
FROM
	tFlatFile
WHERE
	FlatFileKey = @FlatFileKey
GO
