USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[vp_08400SumPATrans]    Script Date: 12/21/2015 13:56:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_08400SumPATrans] AS

SELECT t.batnbr, t.Refnbr, t.Custid, t.trantype, 
        SumTranAmt = Sum(convert(dec(28,3),Tranamt)), 
       SumCuryTranAmt = Sum(Convert(dec(28,3),curytranamt))
  FROM ARTran t
 WHERE t.rlsed = 0  And drcr = 'U' and t.trantype IN ('PA','CM','PP')
GROUP BY t.batnbr, t.refnbr, t.custid, t.trantype
GO
