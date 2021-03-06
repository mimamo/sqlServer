USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[vr_08600SelectCust]    Script Date: 12/21/2015 16:00:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create view [dbo].[vr_08600SelectCust] as

        SELECT  a.AgeBal01,        
                a.AgeBal02,        
                a.AgeBal03,        
                a.AgeBal04,
                c.BillAddr1,
                c.BillAddr2,
                c.BillAttn,
                c.BillCity,
                c.BillCountry,
                c.BillName,
                c.BillState,
                c.BillZip,
                c.CustID,
                c.DunMsg,
                a.LastStmtBal00,
                a.LastStmtBal01,
                a.LastStmtBal02,
                a.LastStmtBal03,
                a.LastStmtBal04,
                a.LastStmtBegBal,
                a.LastStmtDate,
                c.PrtStmt,
                c.StmtCycleID,
                c.StmtType,
		a.currbal,
		a.futurebal
        FROM    Customer c, AR_Balances a

        WHERE   c.custid = a.custid and 
		((c.StmtType = "O" AND c.PrtStmt = 1
--                  	AND a.CurrBal <> 0
		) OR (c.StmtType = "B"))
GO
