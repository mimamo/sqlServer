USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutItemsDeleteReportItems]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutItemsDeleteReportItems]
	@LayoutReportKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 03/11/10  MFT 10.5.2.0 Created
*/

DELETE
FROM
	tLayoutItems
WHERE
	LayoutReportKey = @LayoutReportKey
GO
