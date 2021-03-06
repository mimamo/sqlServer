USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vr_08600SelectDocInfo]    Script Date: 12/21/2015 16:12:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create view [dbo].[vr_08600SelectDocInfo] as

SELECT DISTINCT 
		d.CpnyID,
                d.CuryDocBal,
                d.CuryID,
                d.CuryOrigDocAmt,
                d.CuryStmtBal,
                d.CustID,
                d.DocBal,
                d.DocClass,
                d.DocDate,
                d.DocDesc,
                d.DocType,
                d.OrigDocAmt,
                d.RefNbr,
                d.Rlsed,
                d.StmtBal,
                d.StmtDate
        FROM    vr_08600SelectDocs v, ARDoc d
        WHERE   d.CustId = v.CustId
        AND     d.DocType = v.DocType
        AND     d.RefNbr = v.RefNbr
GO
