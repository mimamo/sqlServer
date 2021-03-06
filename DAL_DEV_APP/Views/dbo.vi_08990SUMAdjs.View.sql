USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[vi_08990SUMAdjs]    Script Date: 12/21/2015 13:35:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create View [dbo].[vi_08990SUMAdjs] as

SELECT v.custid, v.doctype, v.refnbr, 
       origdocamt = MIN(v.origdocamt),
       docbal = MIN(v.docbal),
       rgolamt = MIN(v.rgolamt),
       adjamt = SUM(v.adjamt),
       adjdiscamt = (CASE WHEN v.doctype IN ('IN', 'DM', 'NC') 
                          THEN SUM(v.adjdiscamt) 
                          ELSE 0 END),
       curyorigdocamt = MIN(v.curyorigdocamt),
       curydocbal = MIN(v.curydocbal),
       curyadjamt = SUM(v.curyadjamt),
       curyadjdiscamt = (CASE WHEN v.doctype IN ('IN', 'DM', 'NC') 
                              THEN SUM(v.curyadjdiscamt) 
                              ELSE 0 END)
  FROM vi_08990SelectAdjs v
 GROUP BY v.custid, v.doctype, v.refnbr
GO
