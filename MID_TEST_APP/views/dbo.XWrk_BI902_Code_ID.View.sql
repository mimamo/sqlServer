USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[XWrk_BI902_Code_ID]    Script Date: 12/21/2015 14:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[XWrk_BI902_Code_ID] as
Select RI_ID, PM_ID01, Code_ID, round(sum(Amount),2) as Amount
from XWrk_BI902_Proj
group by RI_ID, PM_ID01, Code_ID
GO
