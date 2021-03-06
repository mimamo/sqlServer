USE [DALLASAPP]
GO
/****** Object:  View [dbo].[vr_08611_adjinv]    Script Date: 12/21/2015 13:44:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create view [dbo].[vr_08611_adjinv] as

SELECT SUM(adjamt + adjdiscamt)  adjamt,  
       SUM(curyadjdamt + curyadjddiscamt) curyadjdamt,
       j.custid,
       j.adjddoctype,
       j.adjdrefnbr,
       r.RI_ID
  FROM ARAdjust j, rptruntime r
 WHERE r.begpernbr >= j.perappl 
 GROUP BY r.ri_id,
       j.custid,
       j.adjddoctype,
       j.adjdrefnbr
GO
