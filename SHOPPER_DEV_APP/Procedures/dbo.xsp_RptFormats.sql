USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xsp_RptFormats]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xsp_RptFormats]WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'ASSelect ReportFormat00 as ReportFormat, ReportName00 as ReportName From vs_RptControl Where ReportNbr ='KBAUR'Union AllSelect ReportFormat01 as ReportFormat, ReportName01 as ReportName From vs_RptControl Where ReportNbr ='KBAUR'Union AllSelect ReportFormat02 as ReportFormat, ReportName02 as ReportName From vs_RptControl Where ReportNbr ='KBAUR'Union AllSelect ReportFormat03 as ReportFormat, ReportName03 as ReportName From vs_RptControl Where ReportNbr ='KBAUR'Union AllSelect ReportFormat04 as ReportFormat, ReportName04 as ReportName From vs_RptControl Where ReportNbr ='KBAUR'Union AllSelect ReportFormat05 as ReportFormat, ReportName05 as ReportName From vs_RptControl Where ReportNbr ='KBAUR'Union AllSelect ReportFormat06 as ReportFormat, ReportName06 as ReportName From vs_RptControl Where ReportNbr ='KBAUR'Union AllSelect ReportFormat07 as ReportFormat, ReportName07 as ReportName From vs_RptControl Where ReportNbr ='KBAUR'
GO
