USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[AR_SBal_WO_CpnyCust]    Script Date: 12/21/2015 13:44:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AR_SBal_WO_CpnyCust    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[AR_SBal_WO_CpnyCust] @parm1 varchar(15), @parm2 varchar(10), @parm3 float AS
SELECT d.*
  FROM ARDoc d LEFT OUTER JOIN artran t
                 ON d.CustID = t.CustID AND
                    d.DocType = t.CostType AND
                    d.RefNbr  = t.SiteID AND
                    t.DrCr = 'U'
 WHERE d.CustID = @parm1 AND d.CpnyID = @parm2
   AND d.Doctype IN ('IN', 'DM', 'FI')
   AND d.DocBal <= @parm3 AND d.DocBal <> 0
   AND d.rlsed = 1 AND t.trantype IS NULL
ORDER BY d.CustID, d.Doctype, d.Refnbr
GO
