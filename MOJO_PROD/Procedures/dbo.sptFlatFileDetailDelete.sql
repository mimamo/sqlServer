USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFlatFileDetailDelete]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFlatFileDetailDelete]
	@FlatFileDetailKey int
AS --Encrypt

/*
|| When     Who Rel    What
|| 04/17/12 MFT 10.555 Created
*/

DELETE
FROM
	tFlatFileDetail
WHERE
	FlatFileDetailKey = @FlatFileDetailKey
GO
