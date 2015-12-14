USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutItemsGet]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutItemsGet]
	@LayoutReportKey int
AS

/*
|| When      Who Rel      What
|| 3/18/10   CRG 10.5.2.0 Created
*/

	SELECT	*
	FROM	tLayoutItems (nolock)
	WHERE	LayoutReportKey = @LayoutReportKey
	ORDER BY ReportTag, ElementID
GO
