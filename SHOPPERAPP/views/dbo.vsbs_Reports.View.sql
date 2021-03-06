USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vsbs_Reports]    Script Date: 12/21/2015 16:12:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create View [dbo].[vsbs_Reports] as
Select '1' as Position, 
	ReportNbr as ReportNbr, 
	ReportNbr + '00' AS ScreenId, 
	ReportName00 as ReportId, 
	reportformat00 as ReportDescr 
from vs_RptControl where reportname00 >="0" or reportformat00 >= "0"
Union
Select '2' as Position, 
	ReportNbr as ReportNbr, 
	ReportNbr + '00' AS ScreenId, 
	ReportName01 as ReportId, 
	reportformat01 as ReportDescr 
from vs_RptControl where reportname01 >="0" or reportformat01 >= "0"
Union
Select '3' as Position, 
	ReportNbr as ReportNbr, 
	ReportNbr + '00' AS ScreenId, 
	ReportName02 as ReportId, 
	reportformat02 as ReportDescr 
from vs_RptControl where reportname02 >="0" or reportformat02 >= "0"
Union
Select '4' as Position, 
	ReportNbr as ReportNbr, 
	ReportNbr + '00' AS ScreenId, 
	ReportName03 as ReportId, 
	reportformat03 as ReportDescr 
from vs_RptControl where reportname03 >="0" or reportformat03 >= "0"
Union
Select '5' as Position, 
	ReportNbr as ReportNbr, 
	ReportNbr + '00' AS ScreenId, 
	ReportName04 as ReportId, 
	reportformat04 as ReportDescr 
from vs_RptControl where reportname04 >="0" or reportformat04 >= "0"
Union
Select '6' as Position, 
	ReportNbr as ReportNbr, 
	ReportNbr + '00' AS ScreenId, 
	ReportName05 as ReportId, 
	reportformat05 as ReportDescr 
from vs_RptControl where reportname05 >="0" or reportformat05 >= "0"
Union
Select '7' as Position, 
	ReportNbr as ReportNbr, 
	ReportNbr + '00' AS ScreenId, 
	ReportName06 as ReportId, 
	reportformat06 as ReportDescr 
from vs_RptControl where reportname06 >="0" or reportformat06 >= "0"
Union
Select '8' as Position, 
	ReportNbr as ReportNbr, 
	ReportNbr + '00' AS ScreenId, 
	ReportName07 as ReportId, 
	reportformat07 as ReportDescr 
from vs_RptControl where reportname07 >="0" or reportformat07 >= "0"
GO
