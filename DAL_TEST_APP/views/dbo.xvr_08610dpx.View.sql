USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_08610dpx]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_08610dpx] 

AS 

SELECT r.RI_ID
, r.ReportDate
, Parent=d.RefNbr
, Ord=1
, cCuryID=c.CuryID
,ClientRefNbr=p.purchase_order_num
, ARAcct =CASE d.DocType WHEN 'PA' 
							THEN c.ARAcct 
							WHEN 'PP' 
							THEN c.PrePayAcct ELSE d.BankAcct END
, ARSub = CASE d.DocType WHEN 'PA' 
							THEN c.ARSub 
							WHEN 'PP' 
							THEN c.PrePaySub ELSE d.BankSub END
, d.CustID
, CName = c.Name
, cStatus = c.Status
, d.RefNbr
, d.CuryID
, d.DueDate
, d.DiscDate
, d.DocDate
, d.DocType
, OrigDocAmt = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') 
					THEN 1 ELSE -1 END * d.OrigDocAmt
, DocBal = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') 
				THEN 1 ELSE -1 END * d.DocBal
, CuryOrigDocAmt = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') 
						THEN 1 ELSE -1 END * d.CuryOrigDocAmt
, CuryDocBal = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') 
					THEN 1 ELSE -1 END * d.CuryDocBal
, c.StmtCycleID
, Descr = ISNULL(t.Descr, '')
, c.BillPhone
, c.BillAttn
, b.AvgDayToPay
, d.CpnyID
, cRI_ID = r.RI_ID
, y.CpnyName
, d.SlsperId
, Cur = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') 
				THEN 1 ELSE -1 END * CASE WHEN d.DocType NOT IN ('CM', 'PA', 'PP') AND r.ReportDate <= d.DueDate OR d.DocType IN ('CM', 'PA', 'PP') AND (r.ReportDate<=d.DocDate OR ARSetup.S4Future09=0) 
											THEN d.DocBal ELSE 0 END
, Past00 = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') 
				THEN 1 ELSE -1 END * CASE WHEN DATEDIFF(Day, CASE WHEN d.DocType IN ('CM', 'PA', 'PP') 
																	THEN d.DocDate ELSE d.DueDate END, r.ReportDate) <= s.AgeDays00 AND DATEDIFF(Day, CASE WHEN d.DocType IN ('CM', 'PA', 'PP') 
																																							THEN d.DocDate ELSE d.DueDate END, r.ReportDate) >= 1 AND (d.DocType NOT IN ('CM', 'PA', 'PP') OR ARSetup.S4Future09=1) 
																																							THEN d.DocBal ELSE 0 END
, Past01 = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') THEN 1 ELSE -1 END * CASE WHEN DATEDIFF(Day, CASE WHEN d.DocType IN ('CM', 'PA', 'PP') THEN d.DocDate ELSE d.DueDate END, r.ReportDate) <= s.AgeDays01 AND DATEDIFF(Day, CASE WHEN d.DocType IN ('CM', 'PA', 'PP') THEN d.DocDate ELSE d.DueDate END, r.ReportDate) > s.AgeDays00 AND (d.DocType NOT IN ('CM', 'PA', 'PP') OR ARSetup.S4Future09=1) THEN d.DocBal ELSE 0 END
, Past02 = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') THEN 1 ELSE -1 END * CASE WHEN DATEDIFF(Day, CASE WHEN d.DocType IN ('CM', 'PA', 'PP') THEN d.DocDate ELSE d.DueDate END, r.ReportDate) <= s.AgeDays02 AND DATEDIFF(Day, CASE WHEN d.DocType IN ('CM', 'PA', 'PP') THEN d.DocDate ELSE d.DueDate END, r.ReportDate) > s.AgeDays01 AND (d.DocType NOT IN ('CM', 'PA', 'PP') OR ARSetup.S4Future09=1) THEN d.DocBal ELSE 0 END
, Over02 = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') THEN 1 ELSE -1 END * CASE WHEN DATEDIFF(Day, CASE WHEN d.DocType IN ('CM', 'PA', 'PP') THEN d.DocDate ELSE d.DueDate END, r.ReportDate) > s.AgeDays02 AND (d.DocType NOT IN ('CM', 'PA', 'PP') OR ARSetup.S4Future09=1) THEN d.DocBal ELSE 0 END, cCur = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') THEN 1 ELSE -1 END * CASE WHEN d.DocType NOT IN ('CM', 'PA', 'PP') AND r.ReportDate <= d.DueDate OR d.DocType IN ('CM', 'PA', 'PP') AND (r.ReportDate<=d.DocDate OR ARSetup.S4Future09=0 ) THEN d.CuryDocBal ELSE 0 END
, cPast00 = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') THEN 1 ELSE -1 END * CASE WHEN DATEDIFF(Day, CASE WHEN d.DocType IN ('CM', 'PA', 'PP') THEN d.DocDate ELSE d.DueDate END, r.ReportDate) <= s.AgeDays00 AND DATEDIFF(Day, CASE WHEN d.DocType IN ('CM', 'PA', 'PP') THEN d.DocDate ELSE d.DueDate END, r.ReportDate) >= 1 AND (d.DocType NOT IN ('CM', 'PA', 'PP') OR ARSetup.S4Future09=1) THEN d.CuryDocBal ELSE 0 END
, cPast01 = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') THEN 1 ELSE -1 END * CASE WHEN DATEDIFF(Day, CASE WHEN d.DocType IN ('CM', 'PA', 'PP') THEN d.DocDate ELSE d.DueDate END, r.ReportDate) <= s.AgeDays01 AND DATEDIFF(Day, CASE WHEN d.DocType IN ('CM', 'PA', 'PP') THEN d.DocDate ELSE d.DueDate END, r.ReportDate) > s.AgeDays00 AND (d.DocType NOT IN ('CM', 'PA', 'PP') OR ARSetup.S4Future09=1) THEN d.CuryDocBal ELSE 0 END
, cPast02 = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') THEN 1 ELSE -1 END * CASE WHEN DATEDIFF(Day, CASE WHEN d.DocType IN ('CM', 'PA', 'PP') THEN d.DocDate ELSE d.DueDate END, r.ReportDate) <= s.AgeDays02 AND DATEDIFF(Day, CASE WHEN d.DocType IN ('CM', 'PA', 'PP') THEN d.DocDate ELSE d.DueDate END, r.ReportDate) > s.AgeDays01 AND (d.DocType NOT IN ('CM', 'PA', 'PP') OR ARSetup.S4Future09=1) THEN d.CuryDocBal ELSE 0 END
, cOver02 = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') THEN 1 ELSE -1 END * CASE WHEN DATEDIFF(Day, CASE WHEN d.DocType IN ('CM', 'PA', 'PP') THEN d.DocDate ELSE d.DueDate END, r.ReportDate) > s.AgeDays02 AND (d.DocType NOT IN ('CM', 'PA', 'PP') OR ARSetup.S4Future09=1) THEN d.CuryDocBal ELSE 0 END
, AgeDays00 = s.AgeDays00
, AgeDays01 = s.AgeDays01
, AgeDays02 = s.AgeDays02
, c.User1 AS CustUser1
, c.User2 AS CustUser2
, c.User3 AS CustUser3
, c.User4 AS CustUser4
, c.User5 AS CustUser5
, c.User6 AS CustUser6
, c.User7 AS CustUser7
, c.User8 AS CustUser8
, d.User1 AS ARDocUser1
, d.User2 AS ARDocUser2
, d.User3 AS ARDocUser3
, d.User4 AS ARDocUser4
, d.User5 AS ARDocUser5
, d.User6 AS ARDocUser6
, d.User7 AS ARDocUser7
, d.User8 AS ARDocUser8 
FROM RptRuntime r INNER JOIN RptCompany y ON y.RI_ID=r.RI_ID INNER JOIN ARDoc d ON d.CpnyID=y.CpnyID INNER JOIN AR_Balances b ON b.CpnyID=y.CpnyID AND b.CustID=d.CustID INNER JOIN Customer c ON c.CustID=d.CustID INNER JOIN PjProj p ON p.Project=d.ProjectID INNER JOIN (SELECT StmtCycleID, AgeDays00 = CONVERT(INT,AgeDays00), AgeDays01 = CONVERT(INT,AgeDays01), AgeDays02 = CONVERT(INT,AgeDays02) FROM ARStmt) s ON s.StmtCycleID=c.StmtCycleID LEFT JOIN Terms t ON d.Terms <> '' AND t.TermsID=d.Terms CROSS JOIN ARSetup (NOLOCK) 
WHERE r.ReportNbr='08610' AND d.Rlsed=1 AND d.CuryDocBal<>0
GO
