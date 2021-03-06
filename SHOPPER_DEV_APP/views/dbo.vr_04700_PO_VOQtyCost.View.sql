USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[vr_04700_PO_VOQtyCost]    Script Date: 12/21/2015 14:33:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vr_04700_PO_VOQtyCost] AS 

Select r.RI_ID, t.rcptnbr, t.rcptlineref,
qty = Sum(CONVERT(DEC(25,9),t.qty)),
tranamt = Sum(CONVERT(DEC(28,3),t.tranamt)),
curytranamt = Sum(CONVERT(DEC(28,3),t.curytranamt))

From APTran t 
     Join APDoc a
     on t.refnbr = a.refnbr
     And t.batnbr = a.batnbr 
     Join RptRuntime r
     On r.ReportNbr = '04700' And r.EndPerNbr < t.PerPost
Where a.DocType <> 'VC'
      And t.Rlsed = 1
      And t.rcptnbr <> ''
      And t.rcptlineref <> ''
Group By r.RI_ID, t.rcptnbr, t.rcptlineref
GO
