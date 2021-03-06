USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_APAdjust_Ref]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/********* Object:  Stored Procedure dbo.APDoc_APAdjust_Ref  Script Date:  06/07/01 4:27pm  ******/
CREATE PROCEDURE [dbo].[APDoc_APAdjust_Ref]
@parm1 varchar ( 15), @parm2 int
-- @parm1 is vendor, @parm2 is accessnbr
AS
SELECT
        VO.*,
	j.AdjAmt,
        j.AdjdDocType, j.AdjDiscAmt, j.AdjdRefNbr, j.AdjgAcct,
        j.AdjgDocType,
        j.AdjgRefNbr, j.AdjgSub,
	j.CuryAdjdAmt,
        j.CuryAdjdDiscAmt,
	j.CuryRGOLAmt,
      CK.*

FROM WrkApDoc JOIN APDoc VO
                ON WrkApDoc.RefNbr = VO.RefNbr
               AND WrkApDoc.DocType = VO.DocType
          LEFT JOIN APAdjust j
                 ON VO.RefNbr = j.AdjdRefNbr AND
                    VO.DocType = j.AdjdDocType
          LEFT JOIN APDOC CK
                 ON j.AdjgAcct = CK.Acct AND
                    j.AdjgSub = CK.Sub AND
                    j.AdjgDocType = CK.DocType AND
                    j.AdjgRefNbr = CK.RefNbr

WHERE
        WrkApDoc.AccessNbr = @parm2 AND
        VO.VendId = @parm1 AND
        VO.DocClass = 'N' AND
        VO.Rlsed = 1 AND
        VO.DocType <> 'VT'

ORDER BY
        VO.VendId, VO.DocClass, VO.Rlsed, VO.BatNbr, VO.RefNbr
GO
