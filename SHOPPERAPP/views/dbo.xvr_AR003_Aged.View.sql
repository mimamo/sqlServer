USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[xvr_AR003_Aged]    Script Date: 12/21/2015 16:12:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_AR003_Aged]

as
SELECT d.CustID
, d.ProjectID
, ISNULL(p.purchase_order_num, '') as 'ClientRefNum'
, ISNULL(p.project_desc, '') as 'JobDescr' 
, ISNULL(p.pm_id02,'') AS 'ProdCode'
, d.RefNbr
, c.ClassID
, d.DueDate
, d.DocDate
, d.DocType
, CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') 
		THEN 1 
		ELSE -1 END * d.CuryOrigDocAmt as 'CuryOrigDocAmt'
, CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') 
		THEN 1 
		ELSE -1 END * d.CuryDocBal as 'CuryDocBal'
, b.AvgDayToPay
, d.CpnyID
, d.BatSeq
, d.BatNbr
FROM ARDoc d JOIN AR_Balances b ON d.CustID = b.CustID 
	LEFT JOIN PJPROJ p ON d.ProjectID = p.Project
	LEFT JOIN Customer c ON d.CustID = c.CustID
WHERE d.Rlsed = 1 --Released
	AND d.CuryDocBal <> 0
GO
