USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[vi_08990CompareAdjs]    Script Date: 12/21/2015 13:35:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vi_08990CompareAdjs] as

SELECT v.custid, v.doctype, v.refnbr, v.origdocamt, v.docbal,
       SumOfAllAdjs = v.rgolamt + v.adjamt + v.adjdiscamt,
       DocBalPlusAdjs = v.rgolamt + v.adjamt + v.adjdiscamt + v.docbal,
       v.curyorigdocamt,v.curydocbal,
       CurySumOfAllAdjs = v.curyadjamt + v.curyadjdiscamt, 
       CuryDocBalPlusAdjs = v.curyadjamt + v.curyadjdiscamt + v.curydocbal

  FROM vi_08990SumAdjs v
GO
