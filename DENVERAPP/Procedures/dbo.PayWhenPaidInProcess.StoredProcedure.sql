USE DENVERAPP; -- <<<< Company databse to search
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'PayWhenPaidInProcess'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[PayWhenPaidInProcess]
GO

CREATE PROCEDURE [dbo].[PayWhenPaidInProcess]     
     @Company varchar(30)
     
 AS
/*******************************************************************************************************
*   DENVERAPP.dbo.PayWhenPaidInProcess 
*
*   Creator:       David Martin
*   Date:          
*   
*
*   Notes:         
*                  
*
*   Usage:

		execute DENVERAPP.dbo.PayWhenPaidInProcess @Company = 'DENVER'
		execute DENVERAPP.dbo.PayWhenPaidInProcess @Company = 'DALLAS'
        execute DENVERAPP.dbo.PayWhenPaidInProcess @Company = 'MIDWEST'
        execute DENVERAPP.dbo.PayWhenPaidInProcess @Company = 'NY'
        execute DENVERAPP.dbo.PayWhenPaidInProcess @Company = 'SHOPPER'
        
       SELECT @@servername  SQLDEV\SQLDEV or SQL1
        
        set statistics io on 
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	01/12/2016	Added @company input to make running this for different companies easier.
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
declare @sql1 nvarchar(max)
declare @sql2 nvarchar(max)
declare @sql nvarchar(max)
declare @serverName varchar(13)
declare @dbName nvarchar(24)

---------------------------------------------
-- create temp table
---------------------------------------------
IF OBJECT_ID('tempdb.dbo.#results') IS NOT NULL DROP TABLE #results
create table #results
(
	Company varchar(30),
	DocType	varchar(2),
	RecordID int,
	RefNbr varchar(10),
	Acct varchar(10),
	Sub	varchar(24),
	VendId varchar(15),
	InvcDate datetime,
	InvcNbr	varchar(15),
	DueDate	datetime,
	ProjectID varchar(20),
	TaskID varchar(32),
	BatNbr varchar(10),
	Amount decimal(20,2),
	ClientInvNum varchar(10),
	ClientInvStatus nvarchar(25),
	JobPrebillBTD decimal(20,2),
	JobActualBTD decimal(20,2),
	JobTotalBTD decimal(20,2),
	JobArPaidToDate decimal(20,2),
	JobCostsToDate decimal(20,2),
	rowId int identity(1,1),
	primary key clustered (ProjectId, RecordID, rowId)
)

---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
select @serverName = (select @@servername)

select @dbName = null

select @dbName = case when @serverName = 'SQLDEV\SQLDEV' and @company = 'DALLAS' then 'DAL_DEV_APP' 
						when @serverName = 'SQL1' and @company = 'DALLAS' then 'DALLASAPP'
						when @serverName = 'SQLDEV\SQLDEV' and @company = 'DENVER' then 'DEN_DEV_APP' 
						when @serverName = 'SQL1' and @company = 'DENVER' then 'DENVERAPP'
						when @serverName = 'SQLDEV\SQLDEV' and @company = 'MIDWEST' then 'MID_DEV_APP' 
						when @serverName = 'SQL1' and @company = 'MIDWEST' then 'MIDWESTAPP'
						when @serverName = 'SQLDEV\SQLDEV' and @company = 'NY' then 'NYC_DEV_APP' 
						when @serverName = 'SQL1' and @company = 'NY' then 'NEWYORKAPP'
						when @serverName = 'SQLDEV\SQLDEV' and @company = 'SHOPPER' then 'SHOPPER_DEV_APP' 
						when @serverName = 'SQL1' and @company = 'SHOPPER' then 'SHOPPERAPP'
					end

select @sql1 = '

---------------------------------------------
-- declare variables
---------------------------------------------
DECLARE @Prebill NVARCHAR(30)
DECLARE @BTD NVARCHAR(30)

SET @Prebill = ''PREBILL''; -- <<<< Project category for prebill
SET @BTD = ''BTD''; -- <<<< Project category for bill-to-date

---------------------------------------------
-- create temp tables
---------------------------------------------
/* Drop existing temp tables */
IF OBJECT_ID(''tempdb..#ApAging'') IS NOT NULL DROP TABLE #ApAging;
create table #ApAging
(
	DocType	varchar(2),
	RecordID int,
	RefNbr varchar(10),
	Acct varchar(10),
	Sub	varchar(24),
	VendId varchar(15),
	InvcDate datetime,
	InvcNbr	varchar(15),
	DueDate	datetime,
	ProjectID varchar(20),
	TaskID varchar(32),
	BatNbr varchar(10),
	Amount decimal(20,2),
	ClientInvNum varchar(10),
	ClientInvStatus nvarchar(25),
	JobPrebillBTD decimal(20,2),
	JobActualBTD decimal(20,2),
	JobTotalBTD decimal(20,2),
	JobArPaidToDate decimal(20,2),
	JobCostsToDate decimal(20,2),
	rowId int identity(1,1),
	primary key clustered (ProjectId, RecordID, rowId)
)

IF object_id(''tempdb.dbo.#aggs'') IS NOT NULL DROP TABLE #aggs
create table #aggs
(
	ProjectID varchar(20),
	RegPayments decimal(20,2),
	CreditMemoUsage decimal(20,2),
	CreditMemoApplication decimal(20,2),
	rowId int identity(1,1),
	primary key clustered (ProjectID, rowId)
)


/* GET AP AGINING DATA */
insert #ApAging
(
	DocType,
	RecordID,
	RefNbr,
	Acct,
	Sub,
	VendId,
	InvcDate,
	InvcNbr,
	DueDate,
	ProjectID,
	TaskID,
	BatNbr,
	Amount
)
SELECT A.DocType,
	A.RecordID,
	A.RefNbr,
	A.Acct,
	A.Sub,
	A.VendId,
	A.InvcDate,
	A.InvcNbr,
	A.DueDate,
	B.ProjectID,
	B.TaskID,
	B.BatNbr,
	Amount = ROUND(SUM(B.TranAmt),2)
FROM ' + @dbName + '.dbo.APDoc A
LEFT OUTER JOIN ' + @dbName + '.dbo.APTran B 
	ON A.RefNbr = B.RefNbr
WHERE A.DocType IN (''VO'', ''AD'', ''AC'') -- Only include A/P documents, not checks
	AND A.PerClosed = '''' -- Only include only open A/P documents
	AND B.LineId <> 0 -- Remove the A/P GL offset detail lines;
GROUP BY A.DocType,
	A.RecordID,
	A.RefNbr,
	A.Acct,
	A.Sub,
	A.VendId,
	A.InvcDate,
	A.InvcNbr,
	A.DueDate,
	B.ProjectID,
	B.TaskID,
	B.BatNbr;

/* GET CLIENT INVOICE DATA */
;with tbl as
(
	SELECT	A.*,
		D.invoice_num
	FROM #ApAging A
	LEFT OUTER JOIN ' + @dbName + '.dbo.PJTRAN B 
		ON B.project = A.ProjectID 
		AND B.pjt_entity = A.TaskID 
		AND B.vendor_num = A.VendId 
		AND B.voucher_num = A.RefNbr 
		AND B.tr_id02 = A.InvcNbr 
		AND B.tr_id04 = A.BatNbr -- Get related PJ transactions
	LEFT OUTER JOIN ' + @dbName + '.dbo.PJINVDET C 
		ON C.in_id12 = B.tr_id23 -- Find related invoice details
	LEFT OUTER JOIN ' + @dbName + '.dbo.PJINVHDR D 
		ON C.draft_num = D.draft_num  -- Get invoice header
	WHERE D.inv_status IN (''PO'') 
		AND D.invoice_type = '''' -- posted and non-reversed invoices only
) 
UPDATE	a 
	SET	[ClientInvNum] = COALESCE(t.invoice_num,''''),
		[ClientInvStatus] = CASE WHEN LTRIM(RTRIM(a.ProjectID)) = '''' THEN ''Non-Client''
								ELSE ''Not Billed''
							END
FROM #ApAging a
left outer join tbl t
	ON a.DocType = t.DocType
	AND a.RecordID = t.RecordID
	AND a.RefNbr = t.RefNbr
	AND a.Acct = t.Acct
	AND a.Sub = t.Sub
	AND a.VendId = t.VendId
	AND a.InvcDate = t.InvcDate
	AND a.InvcNbr = t.InvcNbr
	AND a.DueDate = t.DueDate
	AND a.ProjectID = t.ProjectID
	AND a.TaskID = t.TaskID
	AND a.BatNbr = t.BatNbr
	AND a.Amount = t.Amount;

/* GET PAYMENT STATUS OF INVOICES */
UPDATE ag
	SET	[ClientInvStatus] = CASE WHEN (A.OrigDocAmt - A.DocBal) = 0 THEN ''Unpaid''
								WHEN A.DocBal <> 0 THEN ''Partial Paid''
								ELSE ''Paid''
							END
FROM #ApAging ag
INNER JOIN ' + @dbName + '.dbo.ARDoc A 
	ON ag.[ClientInvNum] = A.RefNbr; '


select @sql2 = ' 

;with tbl as
(
	SELECT project,
		PrebillAmt = sum(case when coalesce(acct,'''') = @prebill then amount else 0 end), /* GET PREBILL AMOUNTS */
		BtdAmt = sum(case when coalesce(acct,'''') = @BTD then amount else 0 end)  /* GET BTD AMOUNTS */
	FROM ' + @dbName + '.dbo.PJTRAN
	WHERE coalesce(Acct,'''') in(@Prebill,@BTD)
	group by project
)
UPDATE a
	SET	JobPrebillBTD = round(COALESCE(Tbl.PrebillAmt,0),2),
		JobActualBTD = round(COALESCE(Tbl.BtdAmt,0) - coalesce(a.JobPrebillBTD,0),2), -- BTD amounts include prebills, subtract out prebills
		JobTotalBTD = round(COALESCE(Tbl.BtdAmt,0),2) /* GET TOTAL BILLED TO DATE */
FROM #ApAging a
LEFT OUTER JOIN	tbl
	ON a.ProjectID = Tbl.project


insert #aggs
(
	ProjectID,
	RegPayments,
	CreditMemoUsage,
	CreditMemoApplication
)
SELECT B.ProjectID,
	RegPayments = case when b.projectId <> '''' and c.doctype = ''PA'' then coalesce(D.CuryAdjgAmt,0) else 0 end, -- Get Regular Payments
	CreditMemoUsage = case when b.docType = ''CM'' and coalesce(d.AdjgDocType,'''') = ''CM'' then - coalesce(d.AdjAmt,0) else 0 end, -- Get Credit Memo Usage
	CreditMemoApplication = case when b.DocType = ''IN'' AND d.AdjgDocType = ''CM'' then coalesce(d.AdjAmt,0) else 0 end -- Get Credit Memo Applications
FROM ' + @dbName + '.dbo.ARDoc B 
INNER JOIN ' + @dbName + '.dbo.PJARPay C 
	ON C.custid = B.custid 
	AND C.invoice_type = B.doctype 
	AND C.invoice_refnbr = B.refnbr 
INNER JOIN ' + @dbName + '.dbo.ARADJUST D 
	ON C.custid = D.custid 
	AND C.invoice_type = D.AdjdDocType 
	AND C.invoice_refnbr = D.AdjdRefNbr
WHERE (B.ProjectID <> '''' AND C.DocType = ''PA'')
	or (b.DocType = ''CM'' AND d.AdjgDocType = ''CM'')
	or (b.DocType = ''IN'' AND d.AdjgDocType = ''CM'')


/* GET AR PAYMENTS TO DATE */
;with sums as
(
	select projectId,
		JobArPaidToDate = ROUND(SUM(RegPayments),2) + ROUND(SUM(CreditMemoUsage),2) - ROUND(SUM(CreditMemoApplication),2)
	FROM #aggs 
	group by ProjectID
)
UPDATE a
	SET JobArPaidToDate = COALESCE(s.JobArPaidToDate,0)
FROM #ApAging a
LEFT OUTER JOIN sums s
	ON A.ProjectID = s.ProjectID


SELECT Company = ''' + @Company + ''',
	DocType,
	RecordID,
	RefNbr,
	Acct,
	Sub,
	VendId,
	InvcDate,
	InvcNbr,
	DueDate,
	ProjectID,
	TaskID,
	BatNbr,
	Amount,
	ClientInvNum,
	ClientInvStatus,
	JobPrebillBTD,
	JobActualBTD,
	JobTotalBTD,
	JobArPaidToDate,
	JobCostsToDate
from #ApAging
order by projectId, recordId

DROP TABLE #ApAging
drop table #aggs '

select @sql = @sql1 + @sql2

insert #Results execute sp_executesql @sql

select Company,
	DocType = ltrim(rtrim(DocType)),
	RecordID = ltrim(rtrim(RecordID)),
	RefNbr = ltrim(rtrim(RefNbr)),
	Acct = ltrim(rtrim(Acct)),
	Sub = ltrim(rtrim(Sub)),
	VendId = ltrim(rtrim(VendId)),
	InvcDate,
	InvcNbr = ltrim(rtrim(InvcNbr)),
	DueDate,
	ProjectID = ltrim(rtrim(ProjectID)),
	TaskID = ltrim(rtrim(TaskID)),
	BatNbr = ltrim(rtrim(BatNbr)),
	Amount = ltrim(rtrim(Amount)),
	ClientInvNum = ltrim(rtrim(ClientInvNum)),
	ClientInvStatus = ltrim(rtrim(ClientInvStatus)),
	JobPrebillBTD = ltrim(rtrim(JobPrebillBTD)),
	JobActualBTD = ltrim(rtrim(JobActualBTD)),
	JobTotalBTD = ltrim(rtrim(JobTotalBTD)),
	JobArPaidToDate = ltrim(rtrim(JobArPaidToDate)),
	JobCostsToDate = ltrim(rtrim(JobCostsToDate))
from #Results

drop table #results

--print @sql1 
print @sql2
--execute sp_executesql @sql

/*
execute DENVERAPP.dbo.PayWhenPaidInProcess 


select Company = len(Company),
	DocType = len(DocType),
	RecordID = len(RecordID),
	RefNbr = len(RefNbr),
	Acct = len(Acct),
	Sub = len(Sub),
	VendId = len(VendId),
	InvcDate = len(InvcDate),
	InvcNbr = len(InvcNbr),
	DueDate = len(DueDate),
	ProjectID = len(ProjectID),
	TaskID = len(TaskID),
	BatNbr = len(BatNbr),
	Amount = len(Amount),
	ClientInvNum = len(ClientInvNum),
	ClientInvStatus = len(ClientInvStatus),
	JobPrebillBTD = len(JobPrebillBTD),
	JobActualBTD = len(JobActualBTD),
	JobTotalBTD = len(JobTotalBTD),
	JobArPaidToDate = len(JobArPaidToDate),
	JobCostsToDate = len(JobCostsToDate)
from #Results
*/