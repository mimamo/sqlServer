USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xqwip_summary_1200_to_1299]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xqwip_summary_1200_to_1299] 
as 
select ri_id, projectid, proj_amt --+ isnull(wipamt,0) proj_amt 
from xqwip_summary_prelim_1200_to_1299 sp 
left outer join xqwip_denver dw on sp.projectid = dw.project
GO
