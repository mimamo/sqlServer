USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[vp_SOPrintQueue_FromTemp]    Script Date: 12/21/2015 14:10:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create view [dbo].[vp_SOPrintQueue_FromTemp] as
select RptNbr = ReportName, S4Future01 = '', S4Future02 = '', S4Future03 = 0, S4Future04 = 0, S4Future05 = 0, S4Future06 = 0, S4Future07 = '',
S4Future08 = '', S4Future09 = 0, S4Future10 = 0, S4Future11 = ReportName, S4Future12 = '', *
from SOPrintQueue_Temp
GO
