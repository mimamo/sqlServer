USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xqwip_summary]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xqwip_summary] 
as 
select ri_id, projectid, proj_amt --+ isnull(wipamt,0) proj_amt 
from xqwip_summary_prelim sp 
left outer join xqwip_denver dw on sp.projectid = dw.project
GO
