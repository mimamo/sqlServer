USE DEN_DEV_APP; -- <<<< Company databse to search
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'ArPaymentHistory'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[ArPaymentHistory]
GO

CREATE PROCEDURE [dbo].[ArPaymentHistory]     
	@Company varchar(30),
	@Client varchar(10),	--> Dynamics Client Code
    @BeginDate date,		--> Beginning Date to Run
	@EndDate date,          --> Ending Date to Run
	@IncludeCredits int = 0 --> 1 to Include Credit Memos and 0 to Exclude Credit Memos
	
 AS

/*******************************************************************************************************
*   DEN_DEV_APP.dbo.ArPaymentHistory 
*
*   Creator:       David Martin
*   Date:          
*   
*
*   Notes:         
*                  
*
*   Usage:

		execute DEN_DEV_APP.dbo.ArPaymentHistory @Company = 'DENVER', 
													@client = '1PGBBY',
													@BeginDate = '1/1/2015', 
													@EndDate = '12/31/2015', 
													@IncludeCredits = 0 
													
		execute DEN_DEV_APP.dbo.ArPaymentHistory @Company = 'DALLAS',		
													@client = 'CIN',
													@BeginDate = '1/1/2015', 
													@EndDate = '12/31/2015', 
													@IncludeCredits = 0 
													
        execute DEN_DEV_APP.dbo.ArPaymentHistory @Company = 'MIDWEST'
        execute DEN_DEV_APP.dbo.ArPaymentHistory @Company = 'NY'
        execute DEN_DEV_APP.dbo.ArPaymentHistory @Company = 'SHOPPER'
        
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
declare @sql nvarchar(max)
declare @serverName varchar(13)
declare @dbName nvarchar(24)

---------------------------------------------
-- create temp tables
---------------------------------------------
if object_id('tempdb.dbo.##arPmtHistory') is not null drop table ##arPmtHistory
create table ##arPmtHistory
(
	Invoice	varchar(10),
	Job	varchar(16),
	JobName	varchar(60),
	InvoiceContact varchar(20),
	ClientContactName varchar(30),
	InvoiceDate	varchar(10),
	DueDate	varchar(10),
	PaidDate varchar(10),
	InvoiceAmount decimal(20,2),
	PaidAmount decimal(20,2),
	Balance	decimal(20,2),
	PaymentDays	int
)

if object_id('tempdb.dbo.##client') is not null drop table ##client
create table ##client
(
	client varchar(15)
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

select @sql = '

SELECT Invoice = LTRIM(RTRIM(A.invoice_num)),
	Job = LTRIM(RTRIM(A.project_billwith)),
	JobName	= LTRIM(RTRIM(D.project_desc)),
	InvoiceContact = LTRIM(RTRIM(D.purchase_order_num)),
	ClientContactName = CASE WHEN COALESCE(LTRIM(RTRIM(E.CName)),'''') = '''' THEN ''''  
							WHEN COALESCE(LTRIM(RTRIM(E.CName)),'''') = ''BLANK'' THEN '''' 
							ELSE COALESCE(LTRIM(RTRIM(E.CName)),'''') 
						END,
	InvoiceDate = COALESCE(LEFT(CONVERT(VARCHAR,A.invoice_date, 101), 10),''''), 
	DueDate = COALESCE(LEFT(CONVERT(VARCHAR,DATEADD(DAY,CAST(A.ih_id18 AS INT),A.invoice_date), 101), 10),''''),
	PaidDate = COALESCE(LEFT(CONVERT(VARCHAR,COALESCE(MAX(B.AdjgDocDate),MAX(C.DateAppl)), 101), 10),''''),
	InvoiceAmount = SUM(A.gross_amt),
	PaidAmount = COALESCE(COALESCE(SUM(B.Amt),SUM(C.Amt)),0),
	Balance = ROUND(SUM(A.gross_amt) - COALESCE(COALESCE(SUM(B.Amt),SUM(C.Amt)),0),2),
	PaymentDays = CASE WHEN ROUND(SUM(A.gross_amt) - COALESCE(COALESCE(SUM(B.Amt),SUM(C.Amt)),0),2) <> 0 THEN '''' 
						ELSE DATEDIFF(DAY,A.invoice_date,COALESCE(COALESCE(MAX(B.AdjgDocDate),MAX(C.DateAppl)),'''')) 
					END
FROM ' + @dbName + '.dbo.pjinvhdr A
LEFT OUTER JOIN (SELECT AdjdRefNbr, 
					AdjdDocType, 
					AdjgDocDate = MAX(AdjgDocDate), 
					Amt = SUM(AdjAmt) 
				FROM ' + @dbName + '.dbo.ARAdjust 
				GROUP BY AdjdRefNbr, AdjdDocType) B 
	ON A.doctype = B.AdjdDocType 
	AND A.invoice_num = B.AdjdRefNbr -- Get Regular Payments
LEFT OUTER JOIN (SELECT AdjgRefNbr, 
					DateAppl = MAX(DateAppl), 
					Amt = SUM(AdjAmt*-1) 
				FROM ' + @dbName + '.dbo.ARAdjust 
				WHERE AdjgDocType = ''CM'' 
				GROUP BY AdjgRefNbr) C 
	ON A.invoice_num = C.AdjgRefNbr -- Get Credit Memos Application
LEFT OUTER JOIN ' + @dbName + '.dbo.pjproj D 
	ON A.project_billwith = D.project
LEFT OUTER JOIN ' + @dbName + '.dbo.xClientContact E 
	ON D.user2 = E.EA_ID
WHERE A.invoice_type = '''' -- Only Non-Reversed Invoices
	AND A.invoice_date BETWEEN ''' + cast(@BeginDate as varchar) + ''' AND ''' + cast(@EndDate as varchar) -- Invoices Between Start/End Date 
+ '''	AND A.inv_status = ''PO'' -- Only Posted Invoices
	and ltrim(rtrim(A.customer)) = ''' + ltrim(rtrim(@Client)) + '''
GROUP BY A.invoice_num, A.project_billwith, A.invoice_date, A.ih_id18, D.project_desc, E.CName, D.purchase_order_num
HAVING SUM(A.gross_amt) <> 0
	AND CASE WHEN ' + cast(@IncludeCredits as nvarchar) + ' = 0 AND SUM(A.gross_amt) < 0 THEN 0 
			ELSE 1 
		END = 1
ORDER BY A.invoice_num '


insert ##arPmtHistory execute sp_executesql @sql

select Invoice,
	Job,
	JobName,
	InvoiceContact,
	ClientContactName,
	InvoiceDate,
	DueDate,
	PaidDate,
	InvoiceAmount,
	PaidAmount,
	Balance,
	PaymentDays
from ##arPmtHistory
order by invoice, job

drop table ##arPmtHistory

