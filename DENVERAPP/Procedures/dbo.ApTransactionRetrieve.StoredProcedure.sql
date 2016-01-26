USE DENVERAPP; -- <<<< Company databse to search
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'ApTransactionRetrieve'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[ApTransactionRetrieve]
GO

CREATE PROCEDURE [dbo].[ApTransactionRetrieve]     
	@Company varchar(30),
	@StartPeriod NVARCHAR(6),
	@EndPeriod NVARCHAR(6)
	
 AS

/*******************************************************************************************************
*   DENVERAPP.dbo.ApTransactionRetrieve 
*
*   Creator:       David Martin
*   Date:          
*   
*
*   Notes:         
*                  
*
*   Usage:

		execute DENVERAPP.dbo.ApTransactionRetrieve @Company = 'DENVER', @StartPeriod = '201501', @EndPeriod = '201512'													
		execute DENVERAPP.dbo.ApTransactionRetrieve @Company = 'DALLAS', @StartPeriod = '201501', @EndPeriod = '201512'
        execute DENVERAPP.dbo.ApTransactionRetrieve @Company = 'MIDWEST', @StartPeriod = '201501', @EndPeriod = '201512'
        execute DENVERAPP.dbo.ApTransactionRetrieve @Company = 'NY', @StartPeriod = '201501', @EndPeriod = '201512'
        execute DENVERAPP.dbo.ApTransactionRetrieve @Company = 'SHOPPER', @StartPeriod = '201501', @EndPeriod = '201512'
        
       SELECT @@servername  SQLDEV\SQLDEV or SQL1
        
        set statistics io on 
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	01/13/2016	Added @company input to make running this for different companies easier.
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
if object_id('tempdb.dbo.#apTransaction') > 0 drop table #apTransaction
create table #apTransaction
(
	DocType	varchar(2),
	RecordID int,
	BatchNbr varchar(10),
	RefNbr varchar(10),
	PeriodPost varchar(6),
	PeriodClosed varchar(6),
	ApGlAccount	varchar(10),
	ApGlSubAccount varchar(24),
	ExpGlAccount varchar(10),
	ExpGlSubAccount	varchar(24),
	VendorID varchar(15),
	VendorName varchar(60),
	InvoiceDate	varchar(10),
	InvoiceNumber varchar(15),
	DueDate	varchar(10),
	Job	varchar(16),
	JobName	varchar(60),
	FunctionCode varchar(32),
	FunctionCodeName varchar(60),
	Amount decimal(20,2),
	CheckDate varchar(10),
	CheckType varchar(2),
	CheckNumber	varchar(10),
	CheckPeriodPost	varchar(6),
	CheckGlAccount varchar(10),
	constraint pkc_#apTransaction primary key (PeriodPost, RecordId, refNbr, job, ExpGlAccount, functionCode, checkNumber, ExpGlSubAccount)
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

/* GET AP VOUCHER DATA */
SELECT	DocType = A.DocType,
	RecordID = A.RecordID,
	BatchNbr = B.BatNbr,
	RefNbr = A.RefNbr,
	PeriodPost = A.PerPost,
	PeriodClosed = A.PerClosed,
	ApGlAccount = A.Acct,
	ApGlSubAccount = A.Sub,
	ExpGlAccount = B.Acct,
	ExpGlSubAccount = B.Sub,
	VendorID = LTRIM(RTRIM(A.VendId)),
	VendorName = LTRIM(RTRIM(C.Name)),
	InvoiceDate = COALESCE(LEFT(CONVERT(VARCHAR,A.InvcDate, 101), 10),''''),
	InvoiceNumber = LTRIM(RTRIM(A.InvcNbr)),
	DueDate = COALESCE(LEFT(CONVERT(VARCHAR,A.DueDate, 101), 10),''''),
	Job = LTRIM(RTRIM(B.ProjectID)),
	JobName = LTRIM(RTRIM(COALESCE(D.project_desc,''''))),
	FunctionCode = LTRIM(RTRIM(B.TaskID)),
	FunctionCodeName = LTRIM(RTRIM(COALESCE(E.pjt_entity_desc,''''))),
	Amount = ROUND(SUM(B.TranAmt),2),
	CheckDate = COALESCE(LEFT(CONVERT(VARCHAR,F.AdjgDocDate, 101), 10),''''),
	CheckType = LTRIM(RTRIM(COALESCE(F.AdjgDocType,''''))),
	CheckNumber = LTRIM(RTRIM(COALESCE(F.AdjgRefNbr,''''))),
	CheckPeriodPost = LTRIM(RTRIM(COALESCE(F.AdjgPerPost,''''))),
	CheckGlAccount =LTRIM(RTRIM(COALESCE(F.AdjgAcct,'''')))
FROM ' + @dbName + '.dbo.APDoc A
LEFT OUTER JOIN ' + @dbName + '.dbo.APTran B (nolock)
	ON A.RefNbr = B.RefNbr
LEFT OUTER JOIN ' + @dbName + '.dbo.Vendor C (nolock)
	ON A.VendId = C.VendId
LEFT OUTER JOIN ' + @dbName + '.dbo.PJPROJ D (nolock)
	ON B.ProjectID = D.project
LEFT OUTER JOIN ' + @dbName + '.dbo.PJPENT E (nolock)
	ON B.ProjectID = E.project 
	AND B.TaskID = E.pjt_entity
LEFT OUTER JOIN ' + @dbName + '.dbo.APAdjust F (nolock)
	ON F.AdjdRefNbr = A.RefNbr 
	AND F.AdjdDocType = A.DocType 
	AND F.S4Future11 = '''' --No Voids
WHERE A.DocType IN (''VO'', ''AD'', ''AC'') -- Only include A/P documents, not checks
	AND B.LineId <> 0 -- Remove the A/P GL offset detail lines;
	AND A.PerPost >= ' + @StartPeriod + '
	AND A.PerPost <= ' + @EndPeriod + ' -- Only Selected Periods
GROUP BY A.DocType,
	A.RecordID,
	A.RefNbr,
	A.PerPost,
	A.PerClosed,
	A.Acct,
	A.Sub,
	B.Acct,
	B.Sub,
	A.VendId,
	C.Name,
	A.InvcDate,
	A.InvcNbr,
	A.DueDate,
	B.ProjectID,
	D.project_desc,
	B.TaskID,
	E.pjt_entity_desc,
	B.BatNbr,
	F.AdjgDocDate,
	F.AdjgDocType,
	F.AdjgRefNbr,
	F.AdjgPerPost,
	F.AdjgAcct '


--print @sql

insert #apTransaction execute sp_executesql @sql

select DocType = ltrim(rtrim(DocType)),
	RecordID = ltrim(rtrim(RecordID)),
	BatchNbr = ltrim(rtrim(BatchNbr)),
	RefNbr = ltrim(rtrim(RefNbr)),
	PeriodPost = ltrim(rtrim(PeriodPost)),
	PeriodClosed = ltrim(rtrim(PeriodPost)),
	ApGlAccount = ltrim(rtrim(ApGlAccount)),
	ApGlSubAccount = ltrim(rtrim(ApGlSubAccount)),
	ExpGlAccount = ltrim(rtrim(ExpGlAccount)),
	ExpGlSubAccount = ltrim(rtrim(ExpGlSubAccount)),
	VendorID = ltrim(rtrim(VendorID)),
	VendorName = ltrim(rtrim(VendorName)),
	InvoiceDate = ltrim(rtrim(InvoiceDate)),
	InvoiceNumber = ltrim(rtrim(InvoiceNumber)),
	DueDate = ltrim(rtrim(DueDate)),
	Job = ltrim(rtrim(Job)),
	JobName = ltrim(rtrim(JobName)),
	FunctionCode = ltrim(rtrim(FunctionCode)),
	FunctionCodeName = ltrim(rtrim(FunctionCodeName)),
	Amount = ltrim(rtrim(Amount)),
	CheckDate = ltrim(rtrim(CheckDate)),
	CheckType = ltrim(rtrim(CheckType)),
	CheckNumber = ltrim(rtrim(CheckNumber)),
	CheckPeriodPost = ltrim(rtrim(CheckPeriodPost)),
	CheckGlAccount = ltrim(rtrim(CheckGlAccount))
from #apTransaction
order by PeriodPost, RecordId

drop table #apTransaction

/*

execute DENVERAPP.dbo.ApTransactionRetrieve @Company = 'DENVER', @StartPeriod = '201501', @EndPeriod = '201512'
												
*/
