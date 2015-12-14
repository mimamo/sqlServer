USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutSectionDeleteReportSections]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutSectionDeleteReportSections]
	@LayoutReportKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 03/11/10  MFT 10.5.2.0 Created
*/

DELETE
FROM
	tLayoutSection
WHERE
	LayoutReportKey = @LayoutReportKey
GO
