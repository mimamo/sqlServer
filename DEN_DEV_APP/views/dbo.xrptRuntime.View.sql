USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[xrptRuntime]    Script Date: 12/21/2015 14:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xrptRuntime]
as
SELECT UserID, RI_ID, SystemDate, SystemTime, ReportTitle, ReportFormat, ReportName, ReportNbr, AccessNbr, BatNbr, PerNbr
, BegPerNbr, EndPerNbr, BusinessDate, CmpnyName, ComputerName, DatabaseName, LongAnswer00, LongAnswer01, LongAnswer02
, LongAnswer03, LongAnswer04, ShortAnswer00, ShortAnswer01, ShortAnswer02, ShortAnswer03, ShortAnswer04, RI_REPLACE, RI_WHERE
, RI_WPTR  
FROM rptRuntime
GO
