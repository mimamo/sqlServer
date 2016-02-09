/*
USE DEN_DEV_APP; 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'WorkingCapital'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[WorkingCapital]
GO

CREATE PROCEDURE [dbo].[WorkingCapital]     
	
	
 AS
*/

/*******************************************************************************************************
*   DEN_DEV_APP.dbo.WorkingCapital 
*
*   Creator: David Martin    
*   Date:          
*   
*
*   Notes:         
*                  
*
*   Usage:	
	
		execute DEN_DEV_APP.dbo.WorkingCapital @iCurMonth = 12, @iCurYear = 2015
		
		select businessUnit, Department, fMonth, count(1)
		from DEN_DEV_APP.dbo.xwrk_MC_Forecast
		group by businessUnit, Department, fMonth
		having count(1) > 1
		
		select businessUnit, Department, fMonth, *
		from DEN_DEV_APP.dbo.xwrk_MC_Forecast
		where businessUnit = 'Batch 19'
			and department = 'Account Leadership'
			and fmonth = 1
		
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/03/2016	Put query into procedure
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
-- Variables
DECLARE @Period CHAR(6);
DECLARE @AgingDate date;
DECLARE @AgencyHyperionCode NVARCHAR(15);
DECLARE @OverheadClientHyperionCode NVARCHAR(15);
DECLARE @SmallClientHyperionCode NVARCHAR(15);
SET @Period = '201509';
SET @AgingDate = '09/30/2015';
SET @AgencyHyperionCode = '4usINDAL';
SET @OverheadClientHyperionCode = '4_G9_OVRHD';
SET @SmallClientHyperionCode = '4_G9_Small';

---------------------------------------------
-- create temp tables
---------------------------------------------
-- Drop Temp Tables From Previous Runs
IF OBJECT_ID('tempdb.dbo.##ApAgingBalanceTbl') IS NOT NULL DROP TABLE ##ApAgingBalanceTbl
create table ##ApAgingBalanceTbl
(
	UniqueKey varchar(20),
	VendId varchar(15),
	InvcNbr	varchar(15),
	InvcDate datetime,
	DueDate	datetime,
	PerPost	varchar(6),
	PerClosed varchar(6),
	Amt	float,
	PaymentAmt float
)


IF OBJECT_ID('tempdb.dbo.##ApAgingJobsTbl') IS NOT NULL DROP TABLE ##ApAgingJobsTbl
create table ##ApAgingJobsTbl
(
	VoucherUniqueKey varchar(12),
	ProjectID varchar(16),
	JobAmt float,
	TotalJobAmt float,
	JobPercent float
)

IF OBJECT_ID('tempdb.dbo.##ApAgingTbl') IS NOT NULL DROP TABLE ##ApAgingTbl
create table ##ApAgingTbl
(
	UniqueKey varchar(20),
	VendId varchar(15),
	InvcNbr	varchar(15),
	InvcDate datetime,
	DueDate	datetime,
	ProjectID varchar(16),
	Balance	float,
	HyperionAccount	varchar(2),
	ClientHyperionCode	nvarchar(80)
)

IF OBJECT_ID('tempdb.dbo.##ApInputBalanceTbl') IS NOT NULL DROP TABLE ##ApInputBalanceTbl
create table ##ApInputBalanceTbl
(
	UniqueKey varchar(12),
	VendId varchar(15),
	InvcNbr	varchar(15),
	Amt	float
)

IF OBJECT_ID('tempdb.dbo.##ApInputJobsTbl') IS NOT NULL DROP TABLE ##ApInputJobsTbl
create table ##ApInputJobsTbl
(
	VoucherUniqueKey varchar(12),
	ProjectID varchar(16),
	JobAmt float,
	TotalJobAmt	float,
	JobPercent float
)

IF OBJECT_ID('tempdb.dbo.##ApInputTbl') IS NOT NULL DROP TABLE ##ApInputTbl
create table ##ApInputTbl
(
	UniqueKey varchar(12),
	VendId	varchar(15),
	InvcNbr	varchar(15),
	ProjectID varchar(16),
	Balance	float,
	HyperionAccount	varchar(8),
	ClientHyperionCode nvarchar(80)
)

IF OBJECT_ID('tempdb..#WorkCapJobUsed') IS NOT NULL DROP TABLE #WorkCapJobUsed
IF OBJECT_ID('tempdb..#ResultsTbl') IS NOT NULL DROP TABLE #ResultsTbl;

IF OBJECT_ID('tempdb.dbo.##ArAgingBalanceTbl') IS NOT NULL DROP TABLE ##ArAgingBalanceTbl
create table 
(
	UniqueKey varchar(12),
	CustID varchar(15),
	ProjectID varchar(16),
	PerPost	varchar(6),
	PerClosed varchar(6),
	DueDate	datetime,
	DocDate	datetime,
	Amt	float,
	PaymentAmt float
)

IF OBJECT_ID('tempdb..#ArAgingTbl') IS NOT NULL DROP TABLE #ArAgingTbl;
IF OBJECT_ID('tempdb..#ArInputTbl') IS NOT NULL DROP TABLE #ArInputTbl;
IF OBJECT_ID('tempdb..#UnbillBalTbl') IS NOT NULL DROP TABLE #UnbillBalTbl;
IF OBJECT_ID('tempdb..#WipBalTbl') IS NOT NULL DROP TABLE #WipBalTbl;
IF OBJECT_ID('tempdb..#PrebillBalTbl') IS NOT NULL DROP TABLE #PrebillBalTbl;
IF OBJECT_ID('tempdb..#VendorLiabBalTbl') IS NOT NULL DROP TABLE #VendorLiabBalTbl;
IF OBJECT_ID('tempdb..#WorkCapClientHyperionCodes') IS NOT NULL DROP TABLE #WorkCapClientHyperionCodes;
IF OBJECT_ID('tempdb..#JobOverrideTbl') IS NOT NULL DROP TABLE #JobOverrideTbl;

---------------------------------------------
-- set session variables
---------------------------------------------
-- SET NOCOUNT ON to prevent row count messages
SET NOCOUNT ON;


/*-------------------------------------------------------*/
/*	GET A/P AGING DATA									 */
/*-------------------------------------------------------*/

-- Populate AP Aging Documents Still Open at Period End
insert ##ApAgingBalanceTbl
(
	UniqueKey,
	VendId,
	InvcNbr,
	InvcDate,
	DueDate,
	PerPost,
	PerClosed,
	Amt,
	PaymentAmt
)
SELECT UniqueKey = DocType + LTRIM(RTRIM(cast(RefNbr as varchar(10)))),
	VendId,
	InvcNbr,
	InvcDate,
	DueDate,
	PerPost,
	PerClosed, 
	Amt = CASE WHEN DocType = 'AD' THEN OrigDocAmt * - 1
			ELSE OrigDocAmt
		END,
	PaymentAmt = CAST(0.00 AS FLOAT)
FROM den_dev_app.dbo.APDoc
WHERE PerPost <= @Period 
		AND (PerClosed > @Period 
			OR PerClosed= '') -- Only include AP documents not closed during the period 
	AND DocType IN ('VO', 'AD', 'AC') -- Only include specific AP document types
	AND Acct IN('2045','2047')  -- Include only AP GL accounts; exclude interco

-- Add Period-To-Date Payments Made to AP Aging Documents Still Open at Period End
;with a
as
(
	select UniqueKey = X.AdjdDocType + LTRIM(RTRIM(cast(X.AdjdRefNbr as varchar(10)))) ,
		Amt = ROUND(SUM(CASE WHEN X.AdjdDocType = 'AD' THEN X.AdjAmt * - 1
							ELSE X.AdjAmt
						END),2)
	from den_dev_app.dbo.APAdjust X
	inner join den_dev_app.dbo.APDoc XX 
		on (X.AdjgDocType + LTRIM(RTRIM(cast(X.AdjgRefNbr as varchar(10)))) + LTRIM(RTRIM(cast(X.AdjgAcct as varchar(10)))) + LTRIM(RTRIM(CONVERT(varchar(10), X.AdjgSub)))) = (XX.DocType + LTRIM(RTRIM(cast(XX.RefNbr as varchar(10)))) + LTRIM(RTRIM(cast(XX.Acct as varchar(10)))) + LTRIM(RTRIM(cast(XX.Sub as varchar(10))))) 
	where X.AdjdDocType IN ('VO', 'AD', 'AC')
		and XX.DocType IN ('CK', 'VC', 'ZC', 'HC', 'SC') --Payment doc types
		and XX.PerPost <= @Period --Payments made in current and prior periods
	group by (X.AdjdDocType + LTRIM(RTRIM(cast(X.AdjdRefNbr as varchar(10)))))
)
update age 
	set	PaymentAmt = COALESCE(A.Amt,0)
from ##ApAgingBalanceTbl age
left outer join	a
	ON A.UniqueKey = age.UniqueKey
		
-- Get Job Detail of AP Aging Documents Still Open at Period End
insert ##ApAgingJobsTbl
(
	VoucherUniqueKey,
	ProjectID,
	JobAmt,
	TotalJobAmt,
	JobPercent
)
SELECT VoucherUniqueKey = A.DocType + LTRIM(RTRIM(cast(A.RefNbr as varchar(10)) )),
	B.ProjectID,
	JobAmt = SUM(CASE WHEN B.DrCr = 'C' THEN B.TranAmt * - 1
						ELSE B.TranAmt
					END),
	TotalJobAmt = CAST(0.00 AS FLOAT),
	JobPercent = CAST(0.00 AS FLOAT)
FROM den_dev_app.dbo.APDoc A
-- Get detail of AP Tran lines only for lines with projects
LEFT OUTER JOIN den_dev_app.dbo.APTran B 
	ON A.RefNbr = B.RefNbr 
	AND B.ProjectID <> ''
WHERE A.DocType IN ('VO', 'AD', 'AC')
	AND A.PerPost <= @Period 
	AND (A.PerClosed > @Period 
		OR A.PerClosed= '') --Only include AP documents not closed during the period 
	AND B.LineId <> 0 -- Remove the A/P GL offset detail lines
GROUP BY A.DocType + LTRIM(RTRIM(cast(A.RefNbr as varchar(10)))), B.ProjectID

-- Caluclate Total Of For Invoice Lines Per Job
;with sums
as
(
	select VoucherUniqueKey, TotalJobAmt = SUM(JobAmt) 
	from ##ApAgingJobsTbl 
	group by VoucherUniqueKey
)
update a
	set	TotalJobAmt = sums.TotalJobAmt
from ##ApAgingJobsTbl a
left outer join sums
	ON sums.VoucherUniqueKey = A.VoucherUniqueKey


-- Caluclate % Of  For Invoice Lines Per Job
update ##ApAgingJobsTbl
	set	JobPercent = JobAmt / TotalJobAmt
where TotalJobAmt <> 0

-- Combined AP Jobs and Balance Data to Combined Aging Table
insert ##ApAgingTbl
(
	UniqueKey,
	VendId,
	InvcNbr,
	InvcDate,
	DueDate,
	ProjectID,
	Balance,
	HyperionAccount,
	ClientHyperionCode
)
select A.UniqueKey,
	A.VendId,
	A.InvcNbr,
	A.InvcDate,
	A.DueDate,
	ProjectID = COALESCE(B.ProjectID,''),
	Balance = ROUND((A.Amt - A.PaymentAmt) * COALESCE(B.JobPercent,1),2),
	HyperionAccount = 'AP',
	ClientHyperionCode = CAST('' AS NVARCHAR(40))
FROM ##ApAgingBalanceTbl A
LEFT OUTER JOIN ##ApAgingJobsTbl B 
	ON A.UniqueKey = B.VoucherUniqueKey

/*
-- Drop Completed AP Aging Tables
IF OBJECT_ID('tempdb..##ApAgingBalanceTbl') IS NOT NULL DROP TABLE ##ApAgingBalanceTbl;
IF OBJECT_ID('tempdb..##ApAgingJobsTbl') IS NOT NULL DROP TABLE ##ApAgingJobsTbl;
*/
/*-------------------------------------------------------*/
/*	GET A/P INPUT DATA									 */
/*-------------------------------------------------------*/

-- Populate AP Documents Entered In the Current Period
insert ##ApInputBalanceTbl
(
	UniqueKey,
	VendId,
	InvcNbr,
	Amt
)
SELECT	UniqueKey = DocType + LTRIM(RTRIM(cast(RefNbr as varchar(10)))),
	VendId,
	InvcNbr,
	Amt = CASE WHEN DocType = 'AD' THEN OrigDocAmt * - 1
			ELSE OrigDocAmt
		END
FROM den_dev_app.dbo.APDoc
WHERE PerPost = @Period -- Only include AP documents entered during the period 
		AND DocType IN ('VO', 'AD', 'AC') -- Only include specific AP document types
		AND Acct IN('2045','2047')  -- Include only AP GL accounts; exclude interco AP documents

-- Get Job Detail of AP Entered In the Current Period
insert ##ApInputJobsTbl
(
	VoucherUniqueKey,
	ProjectID,
	JobAmt,
	TotalJobAmt,
	JobPercent
)
SELECT  VoucherUniqueKey = A.DocType + LTRIM(RTRIM(CONVERT(varchar(10), A.RefNbr))),
	B.ProjectID,
	JobAmt = SUM(CASE WHEN B.DrCr = 'C' THEN B.TranAmt * - 1
					ELSE B.TranAmt
				END),
	TotalJobAmt = CAST(0.00 AS FLOAT),
	JobPercent = CAST(0.00 AS FLOAT)
FROM den_dev_app.dbo.APDoc A
-- Get detail of AP Tran lines only for lines with projects
LEFT OUTER JOIN den_dev_app.dbo.APTran B 
	ON A.RefNbr = B.RefNbr AND B.ProjectID <> ''
WHERE A.DocType IN ('VO', 'AD', 'AC')
	AND A.PerPost = @Period -- Only include AP documents entered during the period 
	AND B.LineId <> 0 -- Remove the A/P GL offset detail lines
GROUP BY A.DocType + LTRIM(RTRIM(cast(A.RefNbr as varchar(10)))), B.ProjectID;

-- Caluclate Total Of For Invoice Lines Per Job
;with sums as
(
	select VoucherUniqueKey, 
		TotalJobAmt = SUM(JobAmt) 
	from ##ApInputJobsTbl 
	group by VoucherUniqueKey
)
update a
	set	TotalJobAmt = COALESCE(B.TotalJobAmt,0)
from ##ApInputJobsTbl A 
left outer join sums B 
	on B.VoucherUniqueKey = A.VoucherUniqueKey

-- Caluclate % Of  For Invoice Lines Per Job
update ##ApInputJobsTbl
	set	JobPercent = JobAmt / TotalJobAmt
where TotalJobAmt <> 0


-- Combined AP Jobs and Balance Data to Combined AP Input Table
insert ##ApInputTbl
(
	UniqueKey,
	VendId,
	InvcNbr,
	ProjectID,
	Balance,
	HyperionAccount,
	ClientHyperionCode
)
SELECT A.UniqueKey,
	A.VendId,
	A.InvcNbr,
	ProjectID = COALESCE(B.ProjectID,''),
	Balance = ROUND((A.Amt) * COALESCE(B.JobPercent,1),2),
	HyperionAccount = 'CurMonAP',
	ClientHyperionCode = CAST('' AS NVARCHAR(40))
FROM ##ApInputBalanceTbl A
LEFT OUTER JOIN ##ApInputJobsTbl B 
	ON A.UniqueKey = B.VoucherUniqueKey

/*
-- Drop Completed AP Input Tables
IF OBJECT_ID('tempdb..##ApInputBalanceTbl') IS NOT NULL DROP TABLE ##ApInputBalanceTbl;
IF OBJECT_ID('tempdb..##ApInputJobsTbl') IS NOT NULL DROP TABLE ##ApInputJobsTbl;
*/
/*-------------------------------------------------------*/
/*	GET A/R AGING DATA									 */
/*-------------------------------------------------------*/

-- Populate AR Aging Documents Still Open at Period End
insert ##ArAgingBalanceTbl
(
	UniqueKey,
	CustID,
	ProjectID,
	PerPost,
	PerClosed,
	DueDate,
	DocDate,
	Amt,
	PaymentAmt
)
	
SELECT	(DocType + RefNbr) AS 'UniqueKey',
	CustID,
	ProjectID,
	PerPost,
	PerClosed,				
	DueDate,
	DocDate,
	Amt = CASE WHEN DocType IN ('IN','DM','FI','NC','AD') THEN 1 
				ELSE -1 
			END * OrigDocAmt,
	PaymentAmt = CAST(0.00 AS FLOAT)
FROM den_dev_app.dbo.ARDoc
WHERE Rlsed = 1 --Released
	AND PerPost <= @Period 
	AND (PerClosed > @Period 
		OR PerClosed = '') -- Only include AR documents not closed during the period
	AND DocType NOT IN ('VT','RC','NS','RP')
	AND RefNbr NOT LIKE 'P%' -- DALLAS ONLY, exclude certain invoice from 2006 DSL conversion
	AND RefNbr NOT LIKE 'F%' -- DALLAS ONLY, exclude certain invoice from 2006 DSL conversion
	AND DocDate >= '10/01/2006' -- DALLAS ONLY, exclude certain invoice from 2006 DSL conversion
	AND BankAcct NOT IN('1041')) AS Tbl; -- Exclude interco AR

-- Payments and Small Balance Adjustments
UPDATE	##ArAgingBalanceTbl
SET		##ArAgingBalanceTbl.PaymentAmt = ##ArAgingBalanceTbl.PaymentAmt + COALESCE(AA.Amt,0)
FROM	##ArAgingBalanceTbl
		LEFT OUTER JOIN	(SELECT		SUM(AdjAmt) AS 'Amt', (AdjdDocType + AdjdRefNbr) AS 'UniqueKey'
						FROM        den_dev_app.dbo.ARAdjust
						WHERE		AdjgDocType IN ('PA','SB','CM') and PerAppl <= @Period
						GROUP BY	(AdjdDocType + AdjdRefNbr)) AA ON AA.UniqueKey = ##ArAgingBalanceTbl.UniqueKey;

-- Credit Memo Applications (Needed to Reflect partial use of credit memos)
UPDATE	##ArAgingBalanceTbl
SET		##ArAgingBalanceTbl.PaymentAmt = ##ArAgingBalanceTbl.PaymentAmt + COALESCE(AA.Amt,0)
FROM	##ArAgingBalanceTbl
		LEFT OUTER JOIN	(SELECT		0 - SUM(AdjAmt) AS 'Amt', (AdjgDocType + AdjgRefNbr) AS 'UniqueKey'
						FROM        den_dev_app.dbo.ARAdjust
						WHERE		AdjgDocType IN ('CM') and PerAppl <= @Period
						GROUP BY	(AdjgDocType + AdjgRefNbr)) AA ON AA.UniqueKey = ##ArAgingBalanceTbl.UniqueKey;

-- Small Credit Adjustments
UPDATE	##ArAgingBalanceTbl
SET		##ArAgingBalanceTbl.PaymentAmt = ##ArAgingBalanceTbl.PaymentAmt + COALESCE(AA.Amt,0)
FROM	##ArAgingBalanceTbl
		LEFT OUTER JOIN	(SELECT		0 - SUM(AdjAmt) AS 'Amt', (AdjdDocType + AdjdRefNbr) AS 'UniqueKey'
						FROM        den_dev_app.dbo.ARAdjust
						WHERE		AdjgDocType = 'SC' and PerAppl <= @Period
						GROUP BY	(AdjdDocType + AdjdRefNbr)) AA ON AA.UniqueKey = ##ArAgingBalanceTbl.UniqueKey

-- On Account Payments Applied
UPDATE	##ArAgingBalanceTbl
SET		##ArAgingBalanceTbl.PaymentAmt = ##ArAgingBalanceTbl.PaymentAmt + COALESCE(AA.Amt,0)
FROM	##ArAgingBalanceTbl
		LEFT OUTER JOIN	(SELECT		0 - SUM(AdjAmt) AS 'Amt', (AdjgDocType + AdjgRefNbr) AS 'UniqueKey', CustID
						FROM        den_dev_app.dbo.ARAdjust
						WHERE		AdjgDocType = 'PA' and PerAppl <= @Period
						GROUP BY	(AdjgDocType + AdjgRefNbr), CustID) AA ON AA.UniqueKey = ##ArAgingBalanceTbl.UniqueKey AND AA.CustID = ##ArAgingBalanceTbl.CustId

-- Update the Due Date for On Account Balances to a Default of 30 Days
UPDATE	##ArAgingBalanceTbl
SET		##ArAgingBalanceTbl.DueDate = DATEADD(d,30,##ArAgingBalanceTbl.DocDate)
WHERE	##ArAgingBalanceTbl.DueDate = '01/01/1900'

-- Age the Invoice into Buckets by Due Date
SELECT		Tbl.CustId,
			SUM(Tbl.Balance) AS 'Balance',
			Tbl.ClientHyperionCode,
			Tbl.HyperionAccount
INTO		#ArAgingTbl
FROM		(SELECT		CustId,
						ROUND(Amt - PaymentAmt,2) AS 'Balance',
						CASE -- Put into aging buckets
							WHEN DATEDIFF(d,DueDate, @AgingDate) <= 0 THEN 'ARCTCUR'
							WHEN DATEDIFF(d,DueDate, @AgingDate) BETWEEN 1 AND 30 THEN 'ARCT1'
							WHEN DATEDIFF(d,DueDate, @AgingDate) BETWEEN 31 AND 60 THEN 'ARCT31'
							WHEN DATEDIFF(d,DueDate, @AgingDate) BETWEEN 61 AND 90 THEN 'ARCT61'
							WHEN DATEDIFF(d,DueDate, @AgingDate) BETWEEN 91 AND 120 THEN 'ARCT91'
							WHEN DATEDIFF(d,DueDate, @AgingDate) BETWEEN 121 AND 150 THEN 'ARCT121'
							WHEN DATEDIFF(d,DueDate, @AgingDate) BETWEEN 151 AND 180 THEN 'ARCT151'
							ELSE 'ARCT180'
						END AS 'HyperionAccount',
						CAST('' AS NVARCHAR(40)) AS 'ClientHyperionCode'
			FROM		##ArAgingBalanceTbl) AS Tbl
GROUP BY	Tbl.CustId, Tbl.ClientHyperionCode, Tbl.HyperionAccount;

/*
-- Drop AR Tables
IF OBJECT_ID('tempdb..##ArAgingBalanceTbl') IS NOT NULL DROP TABLE ##ArAgingBalanceTbl;
*/
/*-------------------------------------------------------*/
/*	GET A/R INPUT DATA									 */
/*-------------------------------------------------------*/

-- Populate AR Aging Documents Entered in Current Period
SELECT	*
INTO	#ArInputTbl
FROM	(SELECT	(DocType + RefNbr) AS 'UniqueKey',
				CustID,
				ProjectID,
				CASE 
					WHEN DocType IN ('IN','DM','FI','NC','AD') THEN 1 
					ELSE -1 
				END * OrigDocAmt AS 'Balance',
				'CurMonAR' AS 'HyperionAccount',
				CAST('' AS NVARCHAR(40)) AS 'ClientHyperionCode'
		FROM	den_dev_app.dbo.ARDoc
		WHERE	Rlsed = 1 --Released
				AND PerPost = @Period -- Only include AR documents entered in current period
				AND DocType NOT IN ('VT','RC','NS','RP')
				AND RefNbr NOT LIKE 'P%' -- DALLAS ONLY, exclude certain invoice from 2006 DSL conversion
				AND RefNbr NOT LIKE 'F%' -- DALLAS ONLY, exclude certain invoice from 2006 DSL conversion
				AND DocDate >= '10/01/2006' -- DALLAS ONLY, exclude certain invoice from 2006 DSL conversion
				AND BankAcct IN('1040')) AS Tbl; -- Include only AR GL accounts to get documents generated; exclude interco AR

/*-------------------------------------------------------*/
/*	GET UNBILLED A/R DATA								 */
/*-------------------------------------------------------*/

-- Get the Data from GL Tran Table
SELECT	CASE WHEN Tbl.ProjectID = 'NON POST' THEN '' ELSE LTRIM(RTRIM(Tbl.ProjectID)) END AS 'ProjectID',
		Tbl.Balance,
		Tbl.HyperionAccount,
		Tbl.ClientHyperionCode
INTO	#UnbillBalTbl
FROM	(SELECT		ProjectID,
					ROUND(SUM(DrAmt - CrAmt),2) AS 'Balance',
					'UnbilledAR1' AS 'HyperionAccount',
					CAST('' AS NVARCHAR(40)) AS 'ClientHyperionCode'
		FROM		den_dev_app.dbo.GLTran
		WHERE		Acct IN ('1310')
					AND PerPost <= @Period
		GROUP BY	ProjectID
		HAVING		ROUND(SUM(DrAmt - CrAmt),2) <> 0) AS Tbl;

/*-------------------------------------------------------*/
/*	GET WIP DATA										 */
/*-------------------------------------------------------*/

-- Get the Data from GL Tran Table
SELECT	CASE WHEN Tbl.ProjectID = 'NON POST' THEN '' ELSE LTRIM(RTRIM(Tbl.ProjectID)) END AS 'ProjectID',
		Tbl.Balance,
		Tbl.HyperionAccount,
		Tbl.ClientHyperionCode
INTO	#WipBalTbl
FROM	(SELECT		ProjectID,
					ROUND(SUM(DrAmt - CrAmt),2) AS 'Balance',
					'WIP1' AS 'HyperionAccount',
					CAST('' AS NVARCHAR(40)) AS 'ClientHyperionCode'
		FROM		den_dev_app.dbo.GLTran
		WHERE		(Acct LIKE '12%' OR Acct IN ('1321'))
					AND PerPost <= @Period
		GROUP BY	ProjectID
		HAVING		ROUND(SUM(DrAmt - CrAmt),2) <> 0) AS Tbl;

/*-------------------------------------------------------*/
/*	GET PREBILL DATA									 */
/*-------------------------------------------------------*/

-- Get the Data from GL Tran Table FOR AGENCY
SELECT	CASE WHEN Tbl.ProjectID = 'NON POST' THEN '' ELSE LTRIM(RTRIM(Tbl.ProjectID)) END AS 'ProjectID',
		Tbl.Balance,
		Tbl.HyperionAccount,
		Tbl.ClientHyperionCode
INTO	#PrebillBalTbl
FROM	(SELECT		ProjectID,
					ROUND(SUM(CrAmt - DrAmt),2) AS 'Balance',
					'CustAdv' AS 'HyperionAccount',
					CAST('' AS NVARCHAR(40)) AS 'ClientHyperionCode'
		FROM		den_dev_app.dbo.GLTran
		WHERE		Acct IN ('2100','2120')
					AND PerPost <= @Period
		GROUP BY	ProjectID
		HAVING		ROUND(SUM(CrAmt - DrAmt),2) <> 0) AS Tbl;

/*
-- Get the Data from GL Tran Table FOR STUDIO
INSERT INTO	#PrebillBalTbl
SELECT		CASE WHEN Tbl.ProjectID = 'NON POST' THEN '' ELSE LEFT(LTRIM(RTRIM(Tbl.ProjectID)),11) + 'AG' END AS 'ProjectID', -- Change Studio Job Suffix to AG to Project Mapping Table
			Tbl.Balance,
			Tbl.HyperionAccount,
			Tbl.ClientHyperionCode
FROM		(SELECT		ProjectID,
						ROUND(SUM(CrAmt - DrAmt),2) AS 'Balance',
						'CustAdv' AS 'HyperionAccount',
						CAST('' AS NVARCHAR(40)) AS 'ClientHyperionCode'
			FROM		DALLASSTUDIOAPP.dbo.GLTran
			WHERE		Acct IN ('2100','2120')
						AND PerPost <= @Period
			GROUP BY	ProjectID
			HAVING		ROUND(SUM(CrAmt - DrAmt),2) <> 0) AS Tbl;
*/

/*-------------------------------------------------------*/
/*	GET VENDOR LIABILITY								 */
/*-------------------------------------------------------*/

-- Get the Data from GL Tran Table
SELECT	CASE WHEN Tbl.ProjectID = 'NON POST' THEN '' ELSE LTRIM(RTRIM(Tbl.ProjectID)) END AS 'ProjectID',
		Tbl.Balance,
		Tbl.HyperionAccount,
		Tbl.ClientHyperionCode
INTO	#VendorLiabBalTbl
FROM	(SELECT		ProjectID,
					ROUND(SUM(CrAmt - DrAmt),2) AS 'Balance',
					'AccrVenLiab' AS 'HyperionAccount',
					CAST('' AS NVARCHAR(40)) AS 'ClientHyperionCode'
		FROM		den_dev_app.dbo.GLTran
		WHERE		Acct IN ('2290','2295','2298','2300')
					AND PerPost <= @Period
		GROUP BY	ProjectID
		HAVING		ROUND(SUM(CrAmt - DrAmt),2) <> 0) AS Tbl;

/*-------------------------------------------------------*/
/*	ASSIGN CLIENT HYPERION CODES						 */
/*-------------------------------------------------------*/

-- Generate a Table of All Clients and Hyperion Codes
SELECT		*
INTO		#WorkCapClientHyperionCodes
FROM		(SELECT CustID,
					(CASE
						WHEN CustID IN('INT','BGT') THEN @OverheadClientHyperionCode --Override the interal client codes to overhead DALLAS ONLY
						WHEN User2 IS NULL THEN @OverheadClientHyperionCode -- If no client, assume overhead
						ELSE LTRIM(RTRIM(User2))
					END) AS 'LiabilityClientHyperionCode',	
					(CASE
						WHEN CustID IN('INT','BGT') THEN @SmallClientHyperionCode --Override the interal client codes to overhead DALLAS ONLY
						WHEN User2 IS NULL THEN @SmallClientHyperionCode -- If no client, assume overhead
						ELSE LTRIM(RTRIM(User2))
					END) AS 'AssetClientHyperionCode'
			FROM	den_dev_app.dbo.Customer) AS Tbl;

-- Generate a Table of All Jobs Used in This Extract From The Temp Tables
SELECT DISTINCT	Tbl.ProjectID,
				CAST('' AS NVARCHAR(40)) AS 'AssetClientHyperionCode',
				CAST('' AS NVARCHAR(40)) AS 'LiabilityClientHyperionCode'
INTO			#WorkCapJobUsed
FROM			(SELECT ProjectID FROM ##ApAgingTbl
				UNION ALL
				SELECT ProjectID FROM ##ApInputTbl
				UNION ALL
				SELECT ProjectID FROM #UnbillBalTbl
				UNION ALL
				SELECT ProjectID FROM #WipBalTbl
				UNION ALL
				SELECT ProjectID FROM #PrebillBalTbl
				UNION ALL
				SELECT ProjectID FROM #VendorLiabBalTbl) AS Tbl;

-- Get Add Client Hyperion Codes to Job List
UPDATE	#WorkCapJobUsed
SET		#WorkCapJobUsed.LiabilityClientHyperionCode = D.LiabilityClientHyperionCode,
		#WorkCapJobUsed.AssetClientHyperionCode = D.AssetClientHyperionCode
FROM	#WorkCapJobUsed LEFT OUTER JOIN
		(SELECT	A.ProjectID, C.CustId, C.AssetClientHyperionCode, C.LiabilityClientHyperionCode
		FROM	#WorkCapJobUsed A
				LEFT OUTER JOIN den_dev_app.dbo.PJPROJ B ON A.ProjectID = B.project
				LEFT OUTER JOIN #WorkCapClientHyperionCodes C ON B.customer = C.CustId) AS D ON #WorkCapJobUsed.ProjectID = D.ProjectID;

-- Generate Job Manual Override List
SELECT * INTO #JobOverrideTbl FROM #WorkCapJobUsed WHERE 1 = 0; -- Copy the structure of the job table

-------------------------
-- Job Override Values --
-------------------------
INSERT INTO #JobOverrideTbl VALUES ('', @SmallClientHyperionCode, @OverheadClientHyperionCode);
INSERT INTO #JobOverrideTbl VALUES ('ZZZZZZ00000ZZ', @SmallClientHyperionCode, @OverheadClientHyperionCode);

-- Populate the Manual Override List into the Job Used Table
UPDATE	#WorkCapJobUsed -- Populate override values
SET		#WorkCapJobUsed.AssetClientHyperionCode = #JobOverrideTbl.AssetClientHyperionCode,
		#WorkCapJobUsed.LiabilityClientHyperionCode = #JobOverrideTbl.LiabilityClientHyperionCode
FROM	#WorkCapJobUsed
		LEFT OUTER JOIN #JobOverrideTbl ON #WorkCapJobUsed.ProjectID = #JobOverrideTbl.ProjectID
WHERE	#JobOverrideTbl.ProjectID IS NOT NULL;

-- Drop Job Override List Table
DROP TABLE #JobOverrideTbl;

--Assign Hyperion Codes to AP Aging Table
UPDATE	##ApAgingTbl
SET		##ApAgingTbl.ClientHyperionCode = COALESCE(#WorkCapJobUsed.LiabilityClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM	##ApAgingTbl LEFT OUTER JOIN #WorkCapJobUsed ON ##ApAgingTbl.ProjectID = #WorkCapJobUsed.ProjectID;

--Assign Hyperion Codes to AP Input Table
UPDATE	##ApInputTbl
SET		##ApInputTbl.ClientHyperionCode = COALESCE(#WorkCapJobUsed.LiabilityClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM	##ApInputTbl LEFT OUTER JOIN #WorkCapJobUsed ON ##ApInputTbl.ProjectID = #WorkCapJobUsed.ProjectID;

--Assign Hyperion Codes to AR Aging Table
UPDATE	#ArAgingTbl
SET		#ArAgingTbl.ClientHyperionCode = COALESCE(#WorkCapClientHyperionCodes.AssetClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM	#ArAgingTbl LEFT OUTER JOIN #WorkCapClientHyperionCodes ON #ArAgingTbl.CustId = #WorkCapClientHyperionCodes.CustId;

--Assign Hyperion Codes to AR Input Table
UPDATE	#ArInputTbl
SET		#ArInputTbl.ClientHyperionCode = COALESCE(#WorkCapClientHyperionCodes.AssetClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM	#ArInputTbl LEFT OUTER JOIN #WorkCapClientHyperionCodes ON #ArInputTbl.CustId = #WorkCapClientHyperionCodes.CustId;

--Assign Hyperion Codes to Unbilled AR Table
UPDATE	#UnbillBalTbl
SET		#UnbillBalTbl.ClientHyperionCode = COALESCE(#WorkCapJobUsed.AssetClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM	#UnbillBalTbl LEFT OUTER JOIN #WorkCapJobUsed ON #UnbillBalTbl.ProjectID = #WorkCapJobUsed.ProjectID;

--Assign Hyperion Codes to WIP Table
UPDATE	#WipBalTbl
SET		#WipBalTbl.ClientHyperionCode = COALESCE(#WorkCapJobUsed.AssetClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM	#WipBalTbl LEFT OUTER JOIN #WorkCapJobUsed ON #WipBalTbl.ProjectID = #WorkCapJobUsed.ProjectID;

--Assign Hyperion Codes to Prebill Table
UPDATE	#PrebillBalTbl
SET		#PrebillBalTbl.ClientHyperionCode = COALESCE(#WorkCapJobUsed.LiabilityClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM	#PrebillBalTbl LEFT OUTER JOIN #WorkCapJobUsed ON #PrebillBalTbl.ProjectID = #WorkCapJobUsed.ProjectID;

--Assign Hyperion Codes to Vendor Table
UPDATE	#VendorLiabBalTbl
SET		#VendorLiabBalTbl.ClientHyperionCode = COALESCE(#WorkCapJobUsed.LiabilityClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM	#VendorLiabBalTbl LEFT OUTER JOIN #WorkCapJobUsed ON #VendorLiabBalTbl.ProjectID = #WorkCapJobUsed.ProjectID;


/*-------------------------------------------------------*/
/*	BUILD RESULTS TABLE WITH DATA						 */
/*-------------------------------------------------------*/

-- Create Results Temp Table, Keep The 'Amt' Field As A Char 
CREATE TABLE #ResultsTbl (HyperionAccount NVARCHAR(40), ClientHyperionCode NVARCHAR(40), Amt NVARCHAR(100));

-- Add Control Totals
INSERT INTO #ResultsTbl VALUES ('WCCurMonAR','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM #ArInputTbl));
INSERT INTO #ResultsTbl VALUES ('WCAR','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM #ArAgingTbl));
INSERT INTO #ResultsTbl VALUES ('WCAccrInc','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM #UnbillBalTbl));
INSERT INTO #ResultsTbl VALUES ('WCWIP','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM #WipBalTbl));
INSERT INTO #ResultsTbl VALUES ('WCCurMonAP','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM ##ApInputTbl));
INSERT INTO #ResultsTbl VALUES ('WCAP','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM ##ApAgingTbl));
INSERT INTO #ResultsTbl VALUES ('WCAccrCOS','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM #VendorLiabBalTbl));
INSERT INTO #ResultsTbl VALUES ('WCCustAdv','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM #PrebillBalTbl));

-- Populate Results Table From Detail Temp Tables
INSERT INTO #ResultsTbl (HyperionAccount, ClientHyperionCode, Amt) SELECT HyperionAccount, ClientHyperionCode, LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM ##ApAgingTbl GROUP BY HyperionAccount, ClientHyperionCode HAVING ROUND(SUM(Balance),2) <> 0;
INSERT INTO #ResultsTbl (HyperionAccount, ClientHyperionCode, Amt) SELECT HyperionAccount, ClientHyperionCode, LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM ##ApInputTbl GROUP BY HyperionAccount, ClientHyperionCode HAVING ROUND(SUM(Balance),2) <> 0;
INSERT INTO #ResultsTbl (HyperionAccount, ClientHyperionCode, Amt) SELECT HyperionAccount, ClientHyperionCode, LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM #ArAgingTbl GROUP BY HyperionAccount, ClientHyperionCode HAVING ROUND(SUM(Balance),2) <> 0;
INSERT INTO #ResultsTbl (HyperionAccount, ClientHyperionCode, Amt) SELECT HyperionAccount, ClientHyperionCode, LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM #ArInputTbl GROUP BY HyperionAccount, ClientHyperionCode HAVING ROUND(SUM(Balance),2) <> 0;
INSERT INTO #ResultsTbl (HyperionAccount, ClientHyperionCode, Amt) SELECT HyperionAccount, ClientHyperionCode, LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM #UnbillBalTbl GROUP BY HyperionAccount, ClientHyperionCode HAVING ROUND(SUM(Balance),2) <> 0;
INSERT INTO #ResultsTbl (HyperionAccount, ClientHyperionCode, Amt) SELECT HyperionAccount, ClientHyperionCode, LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM #WipBalTbl GROUP BY HyperionAccount, ClientHyperionCode HAVING ROUND(SUM(Balance),2) <> 0;
INSERT INTO #ResultsTbl (HyperionAccount, ClientHyperionCode, Amt) SELECT HyperionAccount, ClientHyperionCode, LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM #PrebillBalTbl GROUP BY HyperionAccount, ClientHyperionCode HAVING ROUND(SUM(Balance),2) <> 0;
INSERT INTO #ResultsTbl (HyperionAccount, ClientHyperionCode, Amt) SELECT HyperionAccount, ClientHyperionCode, LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM #VendorLiabBalTbl GROUP BY HyperionAccount, ClientHyperionCode HAVING ROUND(SUM(Balance),2) <> 0;

-- Populate Client Terms, Default 30 Days Unless Overridden
INSERT INTO #ResultsTbl (Amt, HyperionAccount, ClientHyperionCode)
SELECT	CASE
			WHEN A.ClientHyperionCode = '4_B4_SBC' THEN '60' -- AT&T retainer is on 60 days
			ELSE '30'
		END AS 'Amt',
		'PayTerms' As 'HyperionAccount',
		A.ClientHyperionCode
FROM	(SELECT DISTINCT ClientHyperionCode
		FROM	#ArAgingTbl) A;

-- Populate Fund Balance Reservation Type, Default 4 (Not Reserved) Unless Overridden
INSERT INTO #ResultsTbl (Amt, HyperionAccount, ClientHyperionCode)
SELECT	CASE
			WHEN A.ClientHyperionCode = '4_B4_SBC' THEN '4' -- Sample override
			ELSE '4'
		END AS 'Amt',
		'ReserveType' As 'HyperionAccount',
		A.ClientHyperionCode
FROM	(SELECT DISTINCT ClientHyperionCode
		FROM	#ArAgingTbl) A;

-- Populate Client Term Yes/No, Default 1 (Terms Exist) Unless Overridden
INSERT INTO #ResultsTbl (Amt, HyperionAccount, ClientHyperionCode)
SELECT	CASE
			WHEN A.ClientHyperionCode = '4_B4_SBC' THEN '1' -- Sample override
			ELSE '1'
		END AS 'Amt',
		'CreTerms' As 'HyperionAccount',
		A.ClientHyperionCode
FROM	(SELECT DISTINCT ClientHyperionCode
		FROM	#ArAgingTbl) A;
		
-- Populate Receivable Type, Default 4 (Combinations) Unless Overridden
INSERT INTO #ResultsTbl (Amt, HyperionAccount, ClientHyperionCode)
SELECT	CASE
			WHEN A.ClientHyperionCode = '4_B4_SBC' THEN '4' -- Sample override
			ELSE '4'
		END AS 'Amt',
		'RecType' As 'HyperionAccount',
		A.ClientHyperionCode
FROM	(SELECT DISTINCT ClientHyperionCode
		FROM	#ArAgingTbl) A;
		
-- Populate Credit Insurance Yes/No, Default 2 (No) Unless Overridden
INSERT INTO #ResultsTbl (Amt, HyperionAccount, ClientHyperionCode)
SELECT	CASE
			WHEN A.ClientHyperionCode = '4_B4_SBC' THEN '2' -- Sample override
			ELSE '2'
		END AS 'Amt',
		'ClientIns' As 'HyperionAccount',
		A.ClientHyperionCode
FROM	(SELECT DISTINCT ClientHyperionCode
		FROM	#ArAgingTbl
		UNION 
		SELECT DISTINCT ClientHyperionCode
		FROM #UnbillBalTbl
		UNION
		SELECT DISTINCT ClientHyperionCode
		FROM #WipBalTbl) A;
		
-- Populate the Month-End AP Adjustment Amount for the Balance in the Cash Accounts
INSERT INTO #ResultsTbl (Amt, HyperionAccount)
SELECT	LTRIM(RTRIM(Str(ROUND(SUM(DrAmt-CrAmt)*-1,2),20,2))) AS 'Amt', --Reverse the sign for Hyperion Upload
		'WCAPUndepChecks' As 'HyperionAccount'
FROM	den_dev_app.dbo.GLTran A
WHERE	A.Acct IN ('1003','1004','1006','1015') -- Bank Account GLs
		AND A.PerPost <= @Period

/*-------------------------------------------------------*/
/*	OUTPUT RESULTS TABLE IN CSV FORMAT					 */
/*-------------------------------------------------------*/
SELECT '!DATA' AS 'Output'
UNION ALL	
SELECT	'Actual; ' +
		LEFT(@Period,4) + '; ' +
		CASE
			WHEN RIGHT(@Period,2) = '01' THEN 'Jan'
			WHEN RIGHT(@Period,2) = '02' THEN 'Feb'
			WHEN RIGHT(@Period,2) = '03' THEN 'Mar'
			WHEN RIGHT(@Period,2) = '04' THEN 'Apr'
			WHEN RIGHT(@Period,2) = '05' THEN 'May'
			WHEN RIGHT(@Period,2) = '06' THEN 'Jun'
			WHEN RIGHT(@Period,2) = '07' THEN 'Jul'
			WHEN RIGHT(@Period,2) = '08' THEN 'Aug'
			WHEN RIGHT(@Period,2) = '09' THEN 'Sep'
			WHEN RIGHT(@Period,2) = '10' THEN 'Oct'
			WHEN RIGHT(@Period,2) = '11' THEN 'Nov'
			ELSE 'Dec'
		END + '; ' +
		'Periodic; ' +
		'4usINDAL; ' +
		'USD; ' +
		HyperionAccount + '; ' +
		'[ICP None]; ' +
		'[None]; ' +
		'[None]; ' +
		COALESCE(LTRIM(RTRIM(ClientHyperionCode)) + '; ','[None]; ') +
		'[None]; ' +
		Amt
FROM	#ResultsTbl

/*
/*-------------------------------------------------------*/
/*	CLEAN UP											 */
/*-------------------------------------------------------*/
-- Drop Temp Tables
IF OBJECT_ID('tempdb..##ApAgingBalanceTbl') IS NOT NULL DROP TABLE ##ApAgingBalanceTbl;
IF OBJECT_ID('tempdb..##ApAgingJobsTbl') IS NOT NULL DROP TABLE ##ApAgingJobsTbl;
IF OBJECT_ID('tempdb..##ApAgingTbl') IS NOT NULL DROP TABLE ##ApAgingTbl;
IF OBJECT_ID('tempdb..##ApInputBalanceTbl') IS NOT NULL DROP TABLE ##ApInputBalanceTbl;
IF OBJECT_ID('tempdb..##ApInputJobsTbl') IS NOT NULL DROP TABLE ##ApInputJobsTbl;
IF OBJECT_ID('tempdb..##ApInputTbl') IS NOT NULL DROP TABLE ##ApInputTbl;
IF OBJECT_ID('tempdb..#WorkCapJobUsed') IS NOT NULL DROP TABLE #WorkCapJobUsed;
IF OBJECT_ID('tempdb..#ResultsTbl') IS NOT NULL DROP TABLE #ResultsTbl;
IF OBJECT_ID('tempdb..##ArAgingBalanceTbl') IS NOT NULL DROP TABLE ##ArAgingBalanceTbl;
IF OBJECT_ID('tempdb..#ArAgingTbl') IS NOT NULL DROP TABLE #ArAgingTbl;
IF OBJECT_ID('tempdb..#ArInputTbl') IS NOT NULL DROP TABLE #ArInputTbl;
IF OBJECT_ID('tempdb..#UnbillBalTbl') IS NOT NULL DROP TABLE #UnbillBalTbl;
IF OBJECT_ID('tempdb..#WipBalTbl') IS NOT NULL DROP TABLE #WipBalTbl;
IF OBJECT_ID('tempdb..#PrebillBalTbl') IS NOT NULL DROP TABLE #PrebillBalTbl;
IF OBJECT_ID('tempdb..#VendorLiabBalTbl') IS NOT NULL DROP TABLE #VendorLiabBalTbl;
IF OBJECT_ID('tempdb..#WorkCapClientHyperionCodes') IS NOT NULL DROP TABLE #WorkCapClientHyperionCodes;
IF OBJECT_ID('tempdb..#JobOverrideTbl') IS NOT NULL DROP TABLE #JobOverrideTbl;
*/