USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA920_main_with_ri_id]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xvr_PA920_main_with_ri_id] 
as 
select rp.ri_id, xvr_PA920_main.* 
from rptruntime rp 
cross join xvr_PA920_main
GO
