USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AR_SCred_WO_Cpny]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AR_SCred_WO_Cpny    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[AR_SCred_WO_Cpny] @parm1 varchar(10), @parm2 float AS
SELECT d.*
  FROM ARDoc d LEFT OUTER JOIN artran t
                 ON d.custid = t.custid AND
                    d.DocType = t.TranType AND
                    d.RefNbr = t.RefNbr AND
                    t.drcr = 'U'
 WHERE d.CpnyID = @parm1
   AND d.Doctype IN ('PA', 'CM', 'PP')
   AND d.DocBal <= @parm2 AND d.DocBal <> 0
   AND d.rlsed = 1 AND t.trantype IS NULL
 ORDER BY d.CpnyID, d.Doctype, d.Refnbr
GO
