USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xqcaa_summary]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xqcaa_summary] 
as 
select rp.ri_id, projectid, sum(cramt - dramt) proj_amt 
from rptruntime rp 
cross join gltran 
where gltran.perpost <= begpernbr 
and gltran.acct = '2105' 
and posted = 'P' 
group by ri_id, projectid
GO
