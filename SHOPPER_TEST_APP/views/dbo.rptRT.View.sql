USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[rptRT]    Script Date: 12/21/2015 16:06:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW
[dbo].[rptRT]
as
SELECT RI_ID
, RI_WTITLE
, ShortAnswer00
, UserID
, SystemDate
, RI_REPORT
, RI_DATADIR
, ReportTitle
, ReportName
, ReportNbr
, ReportDate
, ComputerName
, DatabaseName
, CmpnyName
FROM rptRuntime
GO
