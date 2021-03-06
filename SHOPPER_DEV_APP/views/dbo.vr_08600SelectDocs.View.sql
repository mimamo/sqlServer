USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[vr_08600SelectDocs]    Script Date: 12/21/2015 14:33:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create view [dbo].[vr_08600SelectDocs] as

        SELECT  d.cpnyid,
d.CustId,
                d.DocType,
                d.RefNbr,
                d.DocClass
        FROM    ARDoc d, vr_08600SelectCust v, rptcompany r
        WHERE   d.CustId = v.CustId
        AND     (d.DocBal > 0.0 or d.StmtBal > 0.0)
        AND     d.Rlsed = 1
        AND     v.StmtType = "O"
        AND     d.StmtDate <> "01/01/1900"
	AND 	d.docclass <> "R"
	AND 	d.doctype Not In ('VT', 'RP')
        AND     d.cpnyid = r.cpnyid

Union

        SELECT  d.cpnyid,
d.CustId,
                d.DocType,
                d.RefNbr,
                d.DocClass
        FROM    ARDoc d, vr_08600SelectCust v, ARStmt s, rptcompany r
        WHERE   d.CustId = v.CustId
        AND     v.StmtType = "B"
        AND     d.StmtDate = s.LastStmtDate
        AND     v.stmtcycleid = s.stmtcycleid
	AND 	d.DocClass <> "R"
	AND 	d.doctype Not In ('VT', 'RP')
	AND     d.cpnyid = r.cpnyid
GO
