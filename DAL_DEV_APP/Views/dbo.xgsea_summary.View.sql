USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[xgsea_summary]    Script Date: 12/21/2015 13:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xgsea_summary]
as
Select

RI_ID             = d.ri_id,
FYear             = d.fyear,
Client            = d.client,
Func              = d.func,
Jan_Amt           = sum(d.Jan_Amt),
Feb_Amt           = sum(d.Feb_Amt),
Mar_Amt           = sum(d.Mar_Amt),
Apr_Amt           = sum(d.Apr_Amt),
May_Amt           = sum(d.May_Amt),
Jun_Amt           = sum(d.Jun_Amt),
Jul_Amt           = sum(d.Jul_Amt),
Aug_Amt           = sum(d.Aug_Amt),
Sep_Amt           = sum(d.Sep_Amt),
Oct_Amt           = sum(d.Oct_Amt),
Nov_Amt           = sum(d.Nov_Amt),
Dec_Amt           = sum(d.Dec_Amt)

from xgsea_detail d

group by d.ri_id, d.fyear,d.client,d.func
GO
