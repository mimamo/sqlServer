USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[AR_SBal_WO_Limit]    Script Date: 12/21/2015 13:44:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[AR_SBal_WO_Limit] @parm1 float, @parm2 varchar(47), @parm3 varchar(7), @parm4 varchar(1)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
SELECT d.*
  FROM ardoc d LEFT OUTER JOIN artran t
                 ON d.CustID = t.CustID AND
                    d.DocType = t.CostType AND
                    d.RefNbr  = t.SiteID AND
                    t.DrCr = 'U'
 WHERE d.Doctype IN ('IN', 'DM', 'FI')
   AND d.DocBal <= @parm1 AND d.DocBal <> 0
   AND d.rlsed = 1 AND d.cpnyid in

      (SELECT Cpnyid
         FROM vs_share_usercpny
        WHERE userid = @parm2
          AND scrn = @parm3
          AND seclevel >= @parm4)
   AND t.trantype IS NULL

 ORDER BY d.CpnyID, d.Doctype, d.Refnbr
GO
