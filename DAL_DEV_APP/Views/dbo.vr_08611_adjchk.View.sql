USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[vr_08611_adjchk]    Script Date: 12/21/2015 13:35:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE view [dbo].[vr_08611_adjchk]
as
SELECT SUM(adjamt- curyrgolamt)  adjamt, 
       SUM(curyadjgamt)  curyadjgamt,
       j.custid,
       j.adjgdoctype,
       j.adjgrefnbr,
       r.RI_ID
  FROM ARAdjust j,
       rptruntime r
 WHERE r.begpernbr >= j.perappl 
 GROUP BY r.ri_id,
       j.custid,
       j.adjgdoctype,
       j.adjgrefnbr
GO
