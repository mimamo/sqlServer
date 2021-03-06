USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[vr_apreport_adjpp]    Script Date: 12/21/2015 13:56:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create view [dbo].[vr_apreport_adjpp] as 
SELECT pp.VendID, jp.adjdRefNbr, AdjdDocType = 'PP', Max(jpv.PerAppl) PerAppl, SUM(jpv.AdjAmt) AdjAmt, ri_id, SUM(jpv.curyadjdamt) curyadjdamt, SUM(jpv.curyrgolamt) curyrgolamt
FROM APDOC pp JOIN APDOC d
	      	   ON pp.VendID = d.VendID and pp.RefNbr = d.PrePay_RefNbr AND d.DocType in ('VO','AC')
	      JOIN APAdjust jp
		   ON pp.VendID = jp.VENDID AND pp.DocType = jp.AdjdDocType AND pp.RefNbr = jp.AdjdRefNbr
	      JOIN APAdjust jpv -- adjustment where the pp was applied to the voucher
		   ON pp.VendID = jpv.VENDID AND d.DocType = jpv.AdjdDocType AND d.RefNbr = jpv.AdjdRefNbr
		        AND jp.AdjgRefNbr = jpv.AdjgRefNbr and jp.AdjgDocType = jpv.AdjgDocType AND jpv.AdjgDocType <> 'VC'
	      CROSS JOIN RPTRunTime r
WHERE pp.Doctype = 'PP' AND jpv.perappl <= r.begpernbr
GROUP BY pp.VendID, jp.adjdRefNbr, jp.AdjdDocType, ri_id
GO
