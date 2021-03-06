USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[vi_08990SumTrans]    Script Date: 12/21/2015 16:06:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE View [dbo].[vi_08990SumTrans]
AS 
SELECT Batnbr,custid,trantype,refnbr, 
       SUM(CASE WHEN TranClass = 'D' AND Trantype IN ('IN','DM') 
                 THEN -Tranamt -- Include Discounts from OM
                WHEN TranClass = 'D' AND Trantype NOT IN ('IN','DM')
                 THEN 0 --Exclude Discounts from AR
                ELSE TranAmt
            END) TranAmtTot
  FROM ARTran 
 WHERE (DRCR = 'C' or (DrCr = 'D' and TranClass='D')) AND 
       NOT (Tranamt <> 0 AND CuryTranamt = 0) --Exclude RGOL
 GROUP BY Batnbr,Custid,trantype,Refnbr
GO
