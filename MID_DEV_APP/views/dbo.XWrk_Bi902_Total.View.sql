USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[XWrk_Bi902_Total]    Script Date: 12/21/2015 14:17:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[XWrk_Bi902_Total] as
select RI_ID, Sum(amount) as Amount
from XWrk_BI902_PROJ
GROUP BY RI_ID
GO
