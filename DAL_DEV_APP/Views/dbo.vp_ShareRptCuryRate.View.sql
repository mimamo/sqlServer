USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[vp_ShareRptCuryRate]    Script Date: 12/21/2015 13:35:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create view [dbo].[vp_ShareRptCuryRate] as
select t.ri_id, t.reportdate, r.*  
from curyrate r inner join (select r.fromcuryid, r.tocuryid, r.ratetype, u.ri_id, u.reportdate, effdate=max(r.effdate) from curyrate r, rptruntime u, glsetup s where s.basecuryid = r.tocuryid and r.effdate<=u.reportdate group by r.fromcuryid, r.tocuryid, r.ratetype, u.ri_id, u.reportdate) t 
on r.fromcuryid = t.fromcuryid and r.tocuryid = t.tocuryid and r.ratetype = t.ratetype and r.effdate=t.effdate
GO
