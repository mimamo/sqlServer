USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[BPV_CSDDetail]    Script Date: 12/21/2015 16:12:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BPV_CSDDetail] 
AS
SELECT CpnyID, BankAcct, BankSub, TranDate, PerNbr, Receipts, Disbursements, 
       Closing_Balance = ISNULL((SELECT SUM(Receipts - Disbursements)
                                 FROM CashSumD cd2, CASetup cas
		                 WHERE (cd2.TranDate < cd.TranDate OR (cd2.TranDate = cd.TranDate AND cd2.PerNbr < cd.PerNbr)) AND
			                cd2.BankAcct = cd.BankAcct AND
			                cd2.BankSub = cd.BankSub AND
			                cd2.CpnyID = cd.CpnyID AND
                                        cd2.Trandate >= cas.AcceptTransDate),0) 
                         + (Receipts - Disbursements)
                        
FROM CashSumD cd 
WHERE cd.TranDate >= (Select AcceptTransDate From CASetup)
GO
