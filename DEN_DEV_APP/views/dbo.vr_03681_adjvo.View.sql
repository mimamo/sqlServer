USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[vr_03681_adjvo]    Script Date: 12/21/2015 14:05:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create view [dbo].[vr_03681_adjvo] as

SELECT SUM((adjamt+adjdiscamt)* CASE WHEN adjddoctype = 'AD' then -1 ELSE 1 END)  adjamt,  
       SUM((curyadjdamt+curyadjddiscamt)* CASE WHEN adjddoctype = 'AD' then -1 ELSE 1 END)  curyadjdamt,
       j.vendid,
       j.adjddoctype,
       j.adjdrefnbr,
       r.RI_ID
  FROM ApAdjust j, rptruntime r
 WHERE r.begpernbr >= j.perappl 
 GROUP BY r.ri_id,
       j.vendid,
       j.adjddoctype,
       j.adjdrefnbr
GO
