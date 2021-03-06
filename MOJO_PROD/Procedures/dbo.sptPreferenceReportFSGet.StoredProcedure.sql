USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceReportFSGet]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceReportFSGet]
 @CompanyKey int
AS --Encrypt

  SELECT ReportFont, ReportTitleFontSize, ReportConditionsFontSize, ReportTopLabelsFontSize,
	 ReportGroupFontSize, ReportDetailFontSize, ReportSubTotalFontSize, ReportGrandTotalFontSize, 
         ReportPageFooterFontSize
  FROM tPreference (NOLOCK) 
  WHERE
   CompanyKey = @CompanyKey
   
 RETURN 1
GO
