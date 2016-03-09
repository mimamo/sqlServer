
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

	@Period CHAR(6),
	@AgingDate date,
--	@AgencyHyperionCode NVARCHAR(15),
	@OverheadClientHyperionCode NVARCHAR(15),
	@SmallClientHyperionCode NVARCHAR(15)
	
 AS


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
	
	execute DEN_DEV_APP.dbo.WorkingCapital @Period = '201601', @AgingDate = '12/01/2015', @OverheadClientHyperionCode = '4_G9_OVRHD', @SmallClientHyperionCode = '4_G9_Small'

		
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
*   Michelle Morales	02/03/2016	Put query into procedure, made it runnable for Denver.
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------

---------------------------------------------
-- create temp tables
---------------------------------------------
-- Drop Temp Tables From Previous Runs
IF OBJECT_ID('tempdb.dbo.##ApAgingBalanceTbl') IS NOT NULL DROP TABLE ##ApAgingBalanceTbl
create table ##ApAgingBalanceTbl
(
	UniqueKey varchar(20) primary key clustered,
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
	JobPercent float,
	primary key clustered (VoucherUniqueKey, ProjectID)
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
	ClientHyperionCode	nvarchar(80),
	primary key clustered (UniqueKey, ProjectID)
)

IF OBJECT_ID('tempdb.dbo.##ApInputBalanceTbl') IS NOT NULL DROP TABLE ##ApInputBalanceTbl
create table ##ApInputBalanceTbl
(
	UniqueKey varchar(12) primary key clustered,
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
	JobPercent float,
	primary key clustered (VoucherUniqueKey, ProjectID)
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
	ClientHyperionCode nvarchar(80),
	primary key clustered (UniqueKey, ProjectID)
)

IF OBJECT_ID('tempdb.dbo.##WorkCapJobUsed') IS NOT NULL DROP TABLE ##WorkCapJobUsed
create table ##WorkCapJobUsed
(
	ProjectID varchar(16) primary key clustered,
	AssetClientHyperionCode	nvarchar(80),
	LiabilityClientHyperionCode	nvarchar(80)
)

-- Create Results Temp Table, Keep The 'Amt' Field As A Char 
IF OBJECT_ID('tempdb.dbo.##ResultsTbl') IS NOT NULL DROP TABLE ##ResultsTbl
CREATE TABLE ##ResultsTbl 
(
	HyperionAccount NVARCHAR(40),
	ClientHyperionCode NVARCHAR(40), 
	Amt NVARCHAR(100),
	primary key clustered (HyperionAccount, ClientHyperionCode)
)


IF OBJECT_ID('tempdb.dbo.##ArAgingBalanceTbl') IS NOT NULL DROP TABLE ##ArAgingBalanceTbl
create table ##ArAgingBalanceTbl
(
	UniqueKey varchar(12),
	CustID varchar(15),
	ProjectID varchar(16),
	PerPost	varchar(6),
	PerClosed varchar(6),
	DueDate	datetime,
	DocDate	datetime,
	Amt	float,
	PaymentAmt float,
	primary key clustered (UniqueKey, ProjectID)
)

IF OBJECT_ID('tempdb.dbo.##ArAgingTbl') IS NOT NULL DROP TABLE ##ArAgingTbl
create table ##ArAgingTbl
(
	CustId	varchar(15),
	Balance	float,
	ClientHyperionCode nvarchar(80),
	HyperionAccount	varchar(7)
)

IF OBJECT_ID('tempdb.dbo.##ArInputTbl') IS NOT NULL DROP TABLE ##ArInputTbl
create table ##ArInputTbl
(
	UniqueKey varchar(12) primary key clustered,
	CustID	varchar(15),
	ProjectID varchar(16),
	Balance	float,
	HyperionAccount	varchar(8),
	ClientHyperionCode nvarchar(80)
)

IF OBJECT_ID('tempdb.dbo.##UnbillBalTbl') IS NOT NULL DROP TABLE ##UnbillBalTbl
create table ##UnbillBalTbl
(
	ProjectID varchar(16) primary key clustered,
	Balance	float,
	HyperionAccount	varchar(11),
	ClientHyperionCode nvarchar(80)
)

IF OBJECT_ID('tempdb.dbo.##WipBalTbl') IS NOT NULL DROP TABLE ##WipBalTbl
create table ##WipBalTbl
(
	ProjectID varchar(16) primary key clustered,
	Balance	float,
	HyperionAccount	varchar(4),
	ClientHyperionCode nvarchar(80)
)

IF OBJECT_ID('tempdb.dbo.##PrebillBalTbl') IS NOT NULL DROP TABLE ##PrebillBalTbl
create table ##PrebillBalTbl
(
	ProjectID varchar(16) primary key clustered,
	Balance	float,
	HyperionAccount	varchar(7),
	ClientHyperionCode nvarchar(80)
)

IF OBJECT_ID('tempdb.dbo.##VendorLiabBalTbl') IS NOT NULL DROP TABLE ##VendorLiabBalTbl
create table ##VendorLiabBalTbl
(
	ProjectID varchar(16) primary key clustered,
	Balance	float,
	HyperionAccount	varchar(11),
	ClientHyperionCode	nvarchar(80)
)

IF OBJECT_ID('tempdb.dbo.##WorkCapClientHyperionCodes') IS NOT NULL DROP TABLE ##WorkCapClientHyperionCodes
create table ##WorkCapClientHyperionCodes
(
	CustID	varchar(15) primary key clustered,
	LiabilityClientHyperionCode	nvarchar(60),
	AssetClientHyperionCode	nvarchar(60)
)
IF OBJECT_ID('tempdb.dbo.##JobOverrideTbl') IS NOT NULL DROP TABLE ##JobOverrideTbl
create table ##JobOverrideTbl
(
	ProjectID varchar(16) primary key clustered,
	AssetClientHyperionCode	nvarchar(160),
	LiabilityClientHyperionCode	nvarchar(160)
)
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
	AND Acct IN('2045','2046','2047')  -- Include only AP GL accounts; exclude interco

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
		AND Acct IN('2045','2046','2047')  -- Include only AP GL accounts; exclude interco AP documents

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
	
SELECT	UniqueKey = (DocType + RefNbr),
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
	and PerPost <= @Period 
	and (PerClosed > @Period 
		or PerClosed = '') -- Only include AR documents not closed during the period
	and DocType not in ('VT','RC','NS','RP')
	and RefNbr not like 'P%' -- DALLAS ONLY, exclude certain invoice from 2006 DSL conversion
	and RefNbr not like 'F%' -- DALLAS ONLY, exclude certain invoice from 2006 DSL conversion
	and DocDate >= '10/01/2006' -- DALLAS ONLY, exclude certain invoice from 2006 DSL conversion
	and BankAcct <> '1041' -- Exclude interco AR

-- Payments and Small Balance Adjustments
;with aa as
(
	select Amt = sum(AdjAmt), 
		UniqueKey = (AdjdDocType + AdjdRefNbr)
	from den_dev_app.dbo.ARAdjust
	where AdjgDocType in ('PA','SB','CM') 
		and PerAppl <= @Period
	group by (AdjdDocType + AdjdRefNbr)
)
update arAge
	set	PaymentAmt = PaymentAmt + coalesce(AA.Amt,0)
from ##ArAgingBalanceTbl arAge
left outer join	aa 
	on aa.UniqueKey = arAge.UniqueKey

-- Credit Memo Applications (Needed to Reflect partial use of credit memos)
;with ab as
(
	select Amt = 0 - sum(AdjAmt), 
		UniqueKey = (AdjgDocType + AdjgRefNbr)
	from den_dev_app.dbo.ARAdjust
	where AdjgDocType in ('CM') 
		and PerAppl <= @Period
	group by (AdjgDocType + AdjgRefNbr)
)
update arAge
	set PaymentAmt = arAge.PaymentAmt + coalesce(ab.Amt,0)
from ##ArAgingBalanceTbl arAge
left outer join	ab 
	on ab.UniqueKey = arAge.UniqueKey;

-- Small Credit Adjustments
;with ac as
(
	select Amt = 0 - sum(AdjAmt), 
		UniqueKey = (AdjdDocType + AdjdRefNbr)
	from den_dev_app.dbo.ARAdjust
	where AdjgDocType = 'SC' and PerAppl <= @Period
	group by (AdjdDocType + AdjdRefNbr)
)
update arAge
	set	PaymentAmt = PaymentAmt + coalesce(ac.Amt,0)
from  ##ArAgingBalanceTbl arAge
left outer join	ac 
	ON ac.UniqueKey = arAge.UniqueKey

-- On Account Payments Applied
;with ad as
(
	select Amt = 0 - sum(AdjAmt), 
		UniqueKey = (AdjgDocType + AdjgRefNbr), 
		CustID
	from den_dev_app.dbo.ARAdjust
	where AdjgDocType = 'PA' 
		and PerAppl <= @Period
	group by (AdjgDocType + AdjgRefNbr), CustID
)
update arAge
	set	PaymentAmt = PaymentAmt + coalesce(ad.Amt,0)
from ##ArAgingBalanceTbl arAge
left outer join ad 
	on ad.UniqueKey = arAge.UniqueKey 
	and ad.CustID = arAge.CustId


-- Update the Due Date for On Account Balances to a Default of 30 Days
update ##ArAgingBalanceTbl
	set DueDate = DATEADD(d, 30, DocDate)
where DueDate = '01/01/1900'

-- Age the Invoice into Buckets by Due Date
insert ##ArAgingTbl
(
	CustId,
	Balance,
	ClientHyperionCode,
	HyperionAccount
)
SELECT CustId,
	Balance = sum(round(Amt - PaymentAmt,2)),
	ClientHyperionCode = cast('' as nvarchar(40)),
	HyperionAccount = case -- Put into aging buckets
							when DATEDIFF(d,DueDate, @AgingDate) <= 0 THEN 'ARCTCUR'
							when DATEDIFF(d,DueDate, @AgingDate) BETWEEN 1 AND 30 THEN 'ARCT1'
							when DATEDIFF(d,DueDate, @AgingDate) BETWEEN 31 AND 60 THEN 'ARCT31'
							when DATEDIFF(d,DueDate, @AgingDate) BETWEEN 61 AND 90 THEN 'ARCT61'
							when DATEDIFF(d,DueDate, @AgingDate) BETWEEN 91 AND 120 THEN 'ARCT91'
							when DATEDIFF(d,DueDate, @AgingDate) BETWEEN 121 AND 150 THEN 'ARCT121'
							when DATEDIFF(d,DueDate, @AgingDate) BETWEEN 151 AND 180 THEN 'ARCT151'
							else 'ARCT180'
						end
from ##ArAgingBalanceTbl
GROUP BY CustId, case when DATEDIFF(d,DueDate, @AgingDate) <= 0 THEN 'ARCTCUR'
						when DATEDIFF(d,DueDate, @AgingDate) BETWEEN 1 AND 30 THEN 'ARCT1'
						when DATEDIFF(d,DueDate, @AgingDate) BETWEEN 31 AND 60 THEN 'ARCT31'
						when DATEDIFF(d,DueDate, @AgingDate) BETWEEN 61 AND 90 THEN 'ARCT61'
						when DATEDIFF(d,DueDate, @AgingDate) BETWEEN 91 AND 120 THEN 'ARCT91'
						when DATEDIFF(d,DueDate, @AgingDate) BETWEEN 121 AND 150 THEN 'ARCT121'
						when DATEDIFF(d,DueDate, @AgingDate) BETWEEN 151 AND 180 THEN 'ARCT151'
						else 'ARCT180'
					end

/*-------------------------------------------------------*/
/*	GET A/R INPUT DATA									 */
/*-------------------------------------------------------*/

-- Populate AR Aging Documents Entered in Current Period
insert ##ArInputTbl
(
	UniqueKey,
	CustID,
	ProjectID,
	Balance,
	HyperionAccount,
	ClientHyperionCode
)

select UniqueKey = (DocType + RefNbr),
	CustID,
	ProjectID,
	Balance = case when DocType IN ('IN','DM','FI','NC','AD') then 1 
					else -1 
				end * OrigDocAmt,
	HyperionAccount = 'CurMonAR',
	ClientHyperionCode = cast('' as nvarchar(40))
from den_dev_app.dbo.ARDoc
where Rlsed = 1 --Released
	and PerPost = @Period -- Only include AR documents entered in current period
	and DocType not in ('VT','RC','NS','RP')
	and RefNbr not like 'P%' -- DALLAS ONLY, exclude certain invoice from 2006 DSL conversion
	and RefNbr not like 'F%' -- DALLAS ONLY, exclude certain invoice from 2006 DSL conversion
	and DocDate >= '10/01/2006' -- DALLAS ONLY, exclude certain invoice from 2006 DSL conversion
	and BankAcct = '1040' -- Include only AR GL accounts to get documents generated; exclude interco AR

/*-------------------------------------------------------*/
/*	GET UNBILLED A/R DATA								 */
/*-------------------------------------------------------*/

-- Get the Data from GL Tran Table
insert ##UnbillBalTbl
(
	ProjectID,
	Balance,
	HyperionAccount,
	ClientHyperionCode
)
select ProjectID = case when ProjectID = 'NON POST' then '' else LTRIM(RTRIM(ProjectID)) end,
	Balance = round(sum(DrAmt - CrAmt),2),
	HyperionAccount = 'UnbilledAR1',
	ClientHyperionCode = cast('' as nvarchar(40))
from den_dev_app.dbo.GLTran
where Acct = '1310'
	and PerPost <= @Period
group by case when ProjectID = 'NON POST' then '' else LTRIM(RTRIM(ProjectID)) end
having round(sum(DrAmt - CrAmt),2) <> 0

/*-------------------------------------------------------*/
/*	GET WIP DATA										 */
/*-------------------------------------------------------*/

-- Get the Data from GL Tran Table
insert ##WipBalTbl
(
	ProjectID,
	Balance,
	HyperionAccount,
	ClientHyperionCode
)
select ProjectID = case when ProjectID = 'NON POST' then '' else ltrim(rtrim(ProjectID)) end,
		Balance = round(sum(DrAmt - CrAmt),2),
		HyperionAccount = 'WIP1',
		ClientHyperionCode = cast('' as nvarchar(40))
from den_dev_app.dbo.GLTran
where (Acct like '12%' 
		or Acct = ('1321'))
	and PerPost <= @Period
group by case when ProjectID = 'NON POST' then '' else ltrim(rtrim(ProjectID)) end
having round(sum(DrAmt - CrAmt),2) <> 0

/*-------------------------------------------------------*/
/*	GET PREBILL DATA									 */
/*-------------------------------------------------------*/

-- Get the Data from GL Tran Table FOR AGENCY
insert ##PrebillBalTbl
(
	ProjectId,
	Balance,
	HyperionAccount,
	ClientHyperionCode
)
select ProjectID = case when ProjectID = 'NON POST' then '' else ltrim(rtrim(ProjectID)) end,
	Balance = round(sum(CrAmt - DrAmt),2),
	HyperionAccount = 'CustAdv',
	ClientHyperionCode = cast('' as nvarchar(40))
from den_dev_app.dbo.GLTran
where Acct in ('2100','2115')
	and PerPost <= @Period
group by case when ProjectID = 'NON POST' then '' else ltrim(rtrim(ProjectID)) end
having round(sum(CrAmt - DrAmt),2) <> 0

/*
-- Get the Data from GL Tran Table FOR STUDIO
INSERT INTO	##PrebillBalTbl
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
insert ##VendorLiabBalTbl
(
	ProjectID,
	Balance,
	HyperionAccount,
	ClientHyperionCode
)
select ProjectID = case when ProjectID = 'NON POST' THEN '' ELSE ltrim(rtrim(ProjectID)) end,
	Balance = round(sum(CrAmt - DrAmt),2),
	HyperionAccount = 'AccrVenLiab',
	ClientHyperionCode = cast('' as nvarchar(40))
from den_dev_app.dbo.GLTran
where Acct in ('2290','2292')
	and PerPost <= @Period
group by case when ProjectID = 'NON POST' THEN '' ELSE ltrim(rtrim(ProjectID)) end
having round(sum(CrAmt - DrAmt),2) <> 0

/*-------------------------------------------------------*/
/*	ASSIGN CLIENT HYPERION CODES						 */
/*-------------------------------------------------------*/

-- Generate a Table of All Clients and Hyperion Codes
insert ##WorkCapClientHyperionCodes
(
	CustID,
	LiabilityClientHyperionCode,
	AssetClientHyperionCode
)
select CustID,
	LiabilityClientHyperionCode = case when CustID in('INT','BGT') then @OverheadClientHyperionCode --Override the interal client codes to overhead DALLAS ONLY
										when User2 is null then @OverheadClientHyperionCode -- If no client, assume overhead
										else LTRIM(RTRIM(User2))
									end,	
	AssetClientHyperionCode = case when CustID in('INT','BGT') then @SmallClientHyperionCode --Override the interal client codes to overhead DALLAS ONLY
									when User2 is null then @SmallClientHyperionCode -- If no client, assume overhead
									else ltrim(rtrim(User2))
								end
from den_dev_app.dbo.Customer

-- Generate a Table of All Jobs Used in This Extract From The Temp Tables
insert ##WorkCapJobUsed
(
	ProjectID,
	AssetClientHyperionCode,
	LiabilityClientHyperionCode
)
SELECT DISTINCT	ProjectID,
	AssetClientHyperionCode = cast('' as nvarchar(40)),
	LiabilityClientHyperionCode = cast('' as nvarchar(40))
FROM ##ApAgingTbl

UNION 

SELECT DISTINCT	ProjectID,
	AssetClientHyperionCode = cast('' as nvarchar(40)),
	LiabilityClientHyperionCode = cast('' as nvarchar(40))
FROM ##ApInputTbl

UNION

SELECT DISTINCT	ProjectID,
	AssetClientHyperionCode = cast('' as nvarchar(40)),
	LiabilityClientHyperionCode = cast('' as nvarchar(40))
FROM ##UnbillBalTbl

UNION

SELECT DISTINCT	ProjectID,
	AssetClientHyperionCode = cast('' as nvarchar(40)),
	LiabilityClientHyperionCode = cast('' as nvarchar(40))
FROM ##WipBalTbl

UNION

SELECT DISTINCT	ProjectID,
	AssetClientHyperionCode = cast('' as nvarchar(40)),
	LiabilityClientHyperionCode = cast('' as nvarchar(40))
FROM ##PrebillBalTbl

UNION

SELECT DISTINCT	ProjectID,
	AssetClientHyperionCode = cast('' as nvarchar(40)),
	LiabilityClientHyperionCode = cast('' as nvarchar(40))
FROM ##VendorLiabBalTbl

-- Get Add Client Hyperion Codes to Job List
UPDATE wcj
	SET LiabilityClientHyperionCode = c.LiabilityClientHyperionCode,
		AssetClientHyperionCode = c.AssetClientHyperionCode
FROM ##WorkCapJobUsed wcj
LEFT OUTER JOIN	den_dev_app.dbo.PJPROJ B 
	ON wcj.ProjectID = B.project
LEFT OUTER JOIN ##WorkCapClientHyperionCodes C 
	ON B.customer = C.CustId

-- Generate Job Manual Override List

-------------------------
-- Job Override Values --
-------------------------
INSERT ##JobOverrideTbl 
(
	ProjectID,
	AssetClientHyperionCode,
	LiabilityClientHyperionCode
)
select '',
	@SmallClientHyperionCode, 
	@OverheadClientHyperionCode
	
INSERT ##JobOverrideTbl 
(
	ProjectID,
	AssetClientHyperionCode,
	LiabilityClientHyperionCode
)
select 'ZZZZZZ00000ZZ', 
	@SmallClientHyperionCode, 
	@OverheadClientHyperionCode

-- Populate the Manual Override List into the Job Used Table
UPDATE wcj -- Populate override values
	SET	AssetClientHyperionCode = jo.AssetClientHyperionCode,
		LiabilityClientHyperionCode = jo.LiabilityClientHyperionCode
FROM ##WorkCapJobUsed wcj
LEFT OUTER JOIN ##JobOverrideTbl jo
	ON wcj.ProjectID = jo.ProjectID
WHERE jo.ProjectID IS NOT NULL

--Assign Hyperion Codes to AP Aging Table
UPDATE apa
	SET	ClientHyperionCode = COALESCE(wcj.LiabilityClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM ##ApAgingTbl apa
LEFT OUTER JOIN ##WorkCapJobUsed wcj
	ON apa.ProjectID = wcj.ProjectID;

--Assign Hyperion Codes to AP Input Table
UPDATE api
	SET	ClientHyperionCode = COALESCE(wcj.LiabilityClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM ##ApInputTbl api
LEFT OUTER JOIN ##WorkCapJobUsed wcj
	ON api.ProjectID = wcj.ProjectID;

--Assign Hyperion Codes to AR Aging Table
UPDATE ara
	SET	ClientHyperionCode = COALESCE(wcchc.AssetClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM ##ArAgingTbl ara 
LEFT OUTER JOIN ##WorkCapClientHyperionCodes wcchc 
	ON ara.CustId = wcchc.CustId

--Assign Hyperion Codes to AR Input Table
UPDATE ari
	SET	ClientHyperionCode = COALESCE(wcchc.AssetClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM ##ArInputTbl ari
LEFT OUTER JOIN ##WorkCapClientHyperionCodes wcchc
	ON ari.CustId = wcchc.CustId

--Assign Hyperion Codes to Unbilled AR Table
UPDATE ubb
	SET	ClientHyperionCode = COALESCE(wcj.AssetClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM ##UnbillBalTbl ubb
LEFT OUTER JOIN ##WorkCapJobUsed wcj
	ON ubb.ProjectID = wcj.ProjectID

--Assign Hyperion Codes to WIP Table
UPDATE wb
	SET	ClientHyperionCode = COALESCE(wcj.AssetClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM ##WipBalTbl wb
LEFT OUTER JOIN ##WorkCapJobUsed wcj
	ON wb.ProjectID = wcj.ProjectID

--Assign Hyperion Codes to Prebill Table
UPDATE pb
	SET ClientHyperionCode = COALESCE(wcj.LiabilityClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM ##PrebillBalTbl pb
LEFT OUTER JOIN ##WorkCapJobUsed wcj
	ON pb.ProjectID = wcj.ProjectID

--Assign Hyperion Codes to Vendor Table
UPDATE vlb
	SET	ClientHyperionCode = COALESCE(wcj.LiabilityClientHyperionCode,'NO CLIENT HYPERION CODE')
FROM ##VendorLiabBalTbl vlb
LEFT OUTER JOIN ##WorkCapJobUsed wcj
	ON vlb.ProjectID = wcj.ProjectID


/*-------------------------------------------------------*/
/*	BUILD RESULTS TABLE WITH DATA						 */
/*-------------------------------------------------------*/

-- Add Control Totals
INSERT INTO ##ResultsTbl VALUES ('WCCurMonAR','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM ##ArInputTbl));
INSERT INTO ##ResultsTbl VALUES ('WCAR','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM ##ArAgingTbl));
INSERT INTO ##ResultsTbl VALUES ('WCAccrInc','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM ##UnbillBalTbl));
INSERT INTO ##ResultsTbl VALUES ('WCWIP','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM ##WipBalTbl));
INSERT INTO ##ResultsTbl VALUES ('WCCurMonAP','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM ##ApInputTbl));
INSERT INTO ##ResultsTbl VALUES ('WCAP','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM ##ApAgingTbl));
INSERT INTO ##ResultsTbl VALUES ('WCAccrCOS','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM ##VendorLiabBalTbl));
INSERT INTO ##ResultsTbl VALUES ('WCCustAdv','[None]',(SELECT LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) FROM ##PrebillBalTbl));

-- Populate Results Table From Detail Temp Tables
INSERT INTO ##ResultsTbl 
(
	HyperionAccount, 
	ClientHyperionCode, 
	Amt
) 
SELECT coalesce(HyperionAccount,''), 
	coalesce(ClientHyperionCode,''), 
	LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) 
FROM ##ApAgingTbl 
GROUP BY coalesce(HyperionAccount,''), coalesce(ClientHyperionCode,'') 
HAVING ROUND(SUM(Balance),2) <> 0;

INSERT INTO ##ResultsTbl 
(
	HyperionAccount, 
	ClientHyperionCode, 
	Amt
) 
SELECT coalesce(HyperionAccount,''),
	coalesce(ClientHyperionCode,''), 
	LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) 
FROM ##ApInputTbl 
GROUP BY coalesce(HyperionAccount,''), coalesce(ClientHyperionCode,'')
HAVING ROUND(SUM(Balance),2) <> 0;

INSERT INTO ##ResultsTbl 
(
	HyperionAccount, 
	ClientHyperionCode, 
	Amt
) 
SELECT coalesce(HyperionAccount,''),
	coalesce(ClientHyperionCode,''), 
	LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) 
FROM ##ArAgingTbl 
GROUP BY coalesce(HyperionAccount,''), coalesce(ClientHyperionCode,'')
HAVING ROUND(SUM(Balance),2) <> 0;

INSERT INTO ##ResultsTbl 
(
	HyperionAccount, 
	ClientHyperionCode, 
	Amt
) 
SELECT coalesce(HyperionAccount,''),
	coalesce(ClientHyperionCode,''), 
	LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) 
FROM ##ArInputTbl 
GROUP BY coalesce(HyperionAccount,''), coalesce(ClientHyperionCode,'')
HAVING ROUND(SUM(Balance),2) <> 0;

INSERT INTO ##ResultsTbl 
(
	HyperionAccount, 
	ClientHyperionCode, 
	Amt
) 
SELECT coalesce(HyperionAccount,''),
	coalesce(ClientHyperionCode,''),  
	LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) 
FROM ##UnbillBalTbl 
GROUP BY coalesce(HyperionAccount,''), coalesce(ClientHyperionCode,'')
HAVING ROUND(SUM(Balance),2) <> 0;

INSERT INTO ##ResultsTbl 
(	
	HyperionAccount, 
	ClientHyperionCode, 
	Amt
) 
SELECT coalesce(HyperionAccount,''),
	coalesce(ClientHyperionCode,''),  
	LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) 
FROM ##WipBalTbl 
GROUP BY coalesce(HyperionAccount,''), coalesce(ClientHyperionCode,'')
HAVING ROUND(SUM(Balance),2) <> 0;

INSERT INTO ##ResultsTbl 
(
	HyperionAccount, 
	ClientHyperionCode, 
	Amt
) 
SELECT coalesce(HyperionAccount,''),
	coalesce(ClientHyperionCode,''), 
	LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) 
FROM ##PrebillBalTbl 
GROUP BY coalesce(HyperionAccount,''), coalesce(ClientHyperionCode,'')
HAVING ROUND(SUM(Balance),2) <> 0;

INSERT INTO ##ResultsTbl 
(
	HyperionAccount, 
	ClientHyperionCode, 
	Amt
) 
SELECT coalesce(HyperionAccount,''),
	coalesce(ClientHyperionCode,''), 
	LTRIM(RTRIM(Str(ROUND(SUM(Balance),2),20,2))) 
FROM ##VendorLiabBalTbl 
GROUP BY coalesce(HyperionAccount,''), coalesce(ClientHyperionCode,'')
HAVING ROUND(SUM(Balance),2) <> 0;

-- Populate Client Terms, Default 30 Days Unless Overridden
INSERT ##ResultsTbl 
(
	Amt, 
	HyperionAccount, 
	ClientHyperionCode
)
SELECT distinct Amt = CASE WHEN ClientHyperionCode = '4_B4_SBC' THEN '60' -- AT&T retainer is on 60 days
			ELSE '30'
		END,
	HyperionAccount = 'PayTerms',
	coalesce(ClientHyperionCode,'') 
FROM ##ArAgingTbl

-- Populate Fund Balance Reservation Type, Default 4 (Not Reserved) Unless Overridden
INSERT ##ResultsTbl 
(
	Amt, 
	HyperionAccount, 
	ClientHyperionCode
)
SELECT distinct Amt = CASE WHEN ClientHyperionCode = '4_B4_SBC' THEN '4' -- Sample override
				ELSE '4'
			END,
	HyperionAccount = 'ReserveType',
	coalesce(ClientHyperionCode,'')
FROM ##ArAgingTbl

-- Populate Client Term Yes/No, Default 1 (Terms Exist) Unless Overridden
INSERT ##ResultsTbl 
(
	Amt, 
	HyperionAccount, 
	ClientHyperionCode
)
SELECT distinct Amt = CASE WHEN ClientHyperionCode = '4_B4_SBC' THEN '1' -- Sample override
				ELSE '1'
			END,
		HyperionAccount = 'CreTerms',
		coalesce(ClientHyperionCode,'')
FROM ##ArAgingTbl
		
-- Populate Receivable Type, Default 4 (Combinations) Unless Overridden
INSERT ##ResultsTbl 
(
	Amt, 
	HyperionAccount, 
	ClientHyperionCode
)
SELECT distinct Amt = CASE WHEN ClientHyperionCode = '4_B4_SBC' THEN '4' -- Sample override
				ELSE '4'
			END,
		HyperionAccount = 'RecType',
		coalesce(ClientHyperionCode,'')
FROM ##ArAgingTbl
		
-- Populate Credit Insurance Yes/No, Default 2 (No) Unless Overridden
INSERT ##ResultsTbl 
(
	Amt, 
	HyperionAccount, 
	ClientHyperionCode
)
SELECT distinct Amt = CASE WHEN ClientHyperionCode = '4_B4_SBC' THEN '2' -- Sample override
				ELSE '2'
			END,
		HyperionAccount = 'ClientIns',
		coalesce(ClientHyperionCode,'')
FROM ##ArAgingTbl

UNION 

SELECT distinct Amt = CASE WHEN ClientHyperionCode = '4_B4_SBC' THEN '2' -- Sample override
				ELSE '2'
			END,
		HyperionAccount = 'ClientIns',
		coalesce(ClientHyperionCode,'')
FROM ##UnbillBalTbl

UNION

SELECT distinct Amt = CASE WHEN ClientHyperionCode = '4_B4_SBC' THEN '2' -- Sample override
				ELSE '2'
			END,
		HyperionAccount = 'ClientIns',
		coalesce(ClientHyperionCode,'')
FROM ##WipBalTbl

		
-- Populate the Month-End AP Adjustment Amount for the Balance in the Cash Accounts
INSERT ##ResultsTbl 
(
	Amt, 
	HyperionAccount,
	ClientHyperionCode
)
SELECT Amt = LTRIM(RTRIM(Str(ROUND(SUM(DrAmt - CrAmt) * -1, 2), 20, 2))), --Reverse the sign for Hyperion Upload
	HyperionAccount = 'WCAPUndepChecks',
	ClientHyperionCode = ''
FROM den_dev_app.dbo.GLTran
WHERE Acct IN ('1003','1004','1006','1015') -- Bank Account GLs
	AND PerPost <= @Period

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
FROM	##ResultsTbl


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
IF OBJECT_ID('tempdb..##WorkCapJobUsed') IS NOT NULL DROP TABLE ##WorkCapJobUsed;
IF OBJECT_ID('tempdb..##ResultsTbl') IS NOT NULL DROP TABLE ##ResultsTbl;
IF OBJECT_ID('tempdb..##ArAgingBalanceTbl') IS NOT NULL DROP TABLE ##ArAgingBalanceTbl;
IF OBJECT_ID('tempdb..##ArAgingTbl') IS NOT NULL DROP TABLE ##ArAgingTbl;
IF OBJECT_ID('tempdb..##ArInputTbl') IS NOT NULL DROP TABLE ##ArInputTbl;
IF OBJECT_ID('tempdb..##UnbillBalTbl') IS NOT NULL DROP TABLE ##UnbillBalTbl;
IF OBJECT_ID('tempdb..##WipBalTbl') IS NOT NULL DROP TABLE ##WipBalTbl;
IF OBJECT_ID('tempdb..##PrebillBalTbl') IS NOT NULL DROP TABLE ##PrebillBalTbl;
IF OBJECT_ID('tempdb..##VendorLiabBalTbl') IS NOT NULL DROP TABLE ##VendorLiabBalTbl;
IF OBJECT_ID('tempdb..##WorkCapClientHyperionCodes') IS NOT NULL DROP TABLE ##WorkCapClientHyperionCodes;
IF OBJECT_ID('tempdb..##JobOverrideTbl') IS NOT NULL DROP TABLE ##JobOverrideTbl;

