USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceUpdateReportFontSizes]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceUpdateReportFontSizes]
	@CompanyKey int,
	@ReportFont varchar(100),
	@ReportTitleFontSize int,
	@ReportConditionsFontSize int,
	@ReportTopLabelsFontSize int,
	@ReportGroupFontSize int,
	@ReportDetailFontSize int,
	@ReportSubTotalFontSize int,
	@ReportGrandTotalFontSize int,
	@ReportPageFooterFontSize int
AS

	UPDATE
		tPreference
	SET
		ReportFont = @ReportFont,
		ReportTitleFontSize = @ReportTitleFontSize,
		ReportConditionsFontSize = @ReportConditionsFontSize,
		ReportTopLabelsFontSize = @ReportTopLabelsFontSize,
		ReportGroupFontSize = @ReportGroupFontSize,
		ReportDetailFontSize = @ReportDetailFontSize,
		ReportSubTotalFontSize = @ReportSubTotalFontSize,
		ReportGrandTotalFontSize = @ReportGrandTotalFontSize,
		ReportPageFooterFontSize = @ReportPageFooterFontSize
	WHERE
		CompanyKey = @CompanyKey 

	RETURN 1
GO
