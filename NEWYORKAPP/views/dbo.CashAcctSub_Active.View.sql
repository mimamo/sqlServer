USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[CashAcctSub_Active]    Script Date: 12/21/2015 16:00:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[CashAcctSub_Active]
AS
SELECT c.* FROM CashAcct c INNER JOIN vs_AcctSub v ON v.Acct = c.BankAcct AND
                                                    v.Sub = c.BankSub AND
                                                    v.CpnyID = c.CpnyID AND
                                                    v.Active = 1
GO
