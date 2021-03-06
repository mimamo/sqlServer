USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpbCoorsInv]    Script Date: 12/21/2015 13:45:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/12/2009 JWG & MSB 

CREATE PROC [dbo].[xpbCoorsInv] 
@RI_ID int

AS

DECLARE @RI_ID_Time int
SET @RI_ID_Time = (SELECT RI_ID + CONVERT(int, REPLACE(SUBSTRING(SystemTime, 1, 5), ':', '')) FROM rptRuntime WHERE RI_ID = @RI_ID)

BEGIN --<Clear working TABLE block>
DELETE FROM xwrk_CoorsInvoice
WHERE RI_ID = @RI_ID_Time

DELETE FROM xwrk_CoorsInvoiceException
WHERE RI_ID = @RI_ID_Time
END --</Clear working TABLE block>

--BEGIN
---- SET NOCOUNT ON added to prevent extra result sets from
---- interfering with SELECT statements.
--SET NOCOUNT ON;
           
--BEGIN TRANSACTION

--BEGIN TRY

BEGIN --<Multiple Invoice File block>
DECLARE @Run int

SET @Run = (SELECT Count(1)
FROM xwrk_CoorsInvoice) 

IF @Run > 0 --any records prior to loading the TABLE indicates another Invoice File is being run
RETURN
END --</Multiple Invoice File block>

--PRINT @Run

BEGIN --<Variable declaration and instantiation block>
DECLARE @FinalPrintFlag varchar(5)
DECLARE @Where varchar(255)
DECLARE @DateYN int
DECLARE @Date1 varchar(10)
DECLARE @Date2 varchar(10)
DECLARE @Content varchar(max)
DECLARE @ArchiveTableDup int


SET @FinalPrintFlag = (SELECT RTRIM(ShortAnswer00) FROM rptRuntime WHERE RI_ID = @RI_ID) --Preview or Final
SET @Where = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM rptRuntime WHERE RI_ID = @RI_ID) --load the WHERE clause from the runtime TABLE

SET @Date1 = CASE 
	WHEN CHARINDEX('invoice_date', @Where, 1) <> 0
	THEN SUBSTRING(@Where, 42, 10)
	ELSE '01/01/1900'
	END --load the start date or default to Jan 1, 1900
SET @Date2 = CASE 
	WHEN CHARINDEX('invoice_date', @Where, 1) <> 0
	THEN SUBSTRING(@Where, 59, 10)
	ELSE '01/01/1900'
	END --load the end date or default to Jan 1, 1900

IF @Date1 = '01/01/1900'
RETURN --invalid date entered

IF @Date2 = '01/01/1900'
RETURN --invalid date entered
END --</Variable declaration and instantiation block>

--PRINT @Date1
--PRINT @Date2

BEGIN --<Mojo for loading working TABLE when a valid PO is used block>
INSERT xwrk_CoorsInvoice
SELECT @RI_ID_Time as 'RI_ID'
, rptRuntime.UserId as 'UserID'
, rptRuntime.SystemDate as 'RunDate'
, rptRuntime.SystemTime as 'RunTime'
, rptRuntime.ComputerName as 'TerminalNum'
, PJINVHDR.invoice_num as 'InvoiceNum'
, isnull(PJINVDET.draft_num, '') as 'DraftNum'
, PJINVHDR.invoice_date as 'Invoice_Date'
, PJINVHDR.inv_status 'InvoiceStatus'
, PJINVDET.amount as 'InvoiceAmount'
, PJINVDET.comment as 'InvoiceItemDescription'
, PJINVDET.pjt_entity as 'Function'
, PJINVDET.project as 'Project'
, PJPROJ.project_desc as 'ProjectDescription'
, PJINVDET.source_trx_id as 'SourceTrxID'
, PJPROJ.pm_id01 as 'CustCode'
, PJINVHDR.invoice_type as 'InvoiceType'
, PJINVHDR.ih_id12 as 'OrigInvoiceNum'
, PJPROJ.purchase_order_num as 'PONum'
, PJPROJ.pm_id02 as 'ProductCode'
, xIGProdCode.descr as 'Product'
, Customer.[Name] as 'CustName'
, @Date1 as 'BeginDate'
, @Date2 as 'EndDate'
, '' as 'ArchiveTableDup' --include for later use
, @FinalPrintFlag as 'Action' --Preview or Final
FROM PJINVDET JOIN PJINVHDR ON PJINVDET.draft_num = PJINVHDR.draft_num 
	JOIN PJPROJ ON PJINVDET.project = PJPROJ.project 
	LEFT JOIN Customer ON PJPROJ.pm_id01 = Customer.CustId 
	LEFT JOIN xIGProdCode ON PJPROJ.pm_id02 = xIGProdCode.code_ID 
	JOIN rptRuntime	ON @RI_ID = rptRuntime.RI_ID 
WHERE PJINVHDR.invoice_type <> 'REVR'
	AND PJPROJ.pm_id01 in ('1CBC00', '1MOLBD', '1MNCGP', '2CBCCO', '2CBCSC', '2CBCSW', '2MOLCO', '2MOLSW')
	AND invoice_date between @Date1 and @Date2
	AND PJINVHDR.draft_num <> ''
	AND len(PJPROJ.purchase_order_num) = 10 -- valid PO

END --</Mojo for loading working TABLE when a valid PO is used block>

--PRINT 'Inserted'

BEGIN --<Determine duplication block>
UPDATE xwrk_CoorsInvoice
SET ArchiveTableDup = CASE WHEN xCoorsInvoiceHistDet.InvoiceNum IS NULL
							THEN 0
							ELSE 1 end
FROM xwrk_CoorsInvoice LEFT JOIN xCoorsInvoiceHistDet ON xwrk_CoorsInvoice.InvoiceNum = xCoorsInvoiceHistDet.InvoiceNum
WHERE xwrk_CoorsInvoice.RI_ID = @RI_ID_Time

--PRINT 'UPDATED ARCHIVETABLEDUP FIELD'

BEGIN --<Mojo for loading exception working TABLE when a valid PO isn't used block>
INSERT xwrk_CoorsInvoiceException 
SELECT @RI_ID_Time as 'RI_ID'
, rptRuntime.UserId as 'UserID'
, rptRuntime.SystemDate as 'RunDate'
, rptRuntime.SystemTime as 'RunTime'
, rptRuntime.ComputerName as 'TerminalNum'
, PJINVHDR.invoice_num as 'InvoiceNum'
, isnull(PJINVDET.draft_num, '') as 'DraftNum'
, PJINVHDR.invoice_date as 'Invoice_Date'
, PJINVHDR.inv_status 'InvoiceStatus'
, PJINVDET.amount as 'InvoiceAmount'
, PJINVDET.comment as 'InvoiceitemDescription'
, PJINVDET.pjt_entity as 'Function'
, PJINVDET.project as 'Project'
, PJPROJ.project_desc as 'ProjectDescription'
, PJINVDET.source_trx_id as 'SourceTrxID'
, PJPROJ.pm_id01 as 'CustCode'
, PJINVHDR.invoice_type as 'InvoiceType'
, PJINVHDR.ih_id12 as 'OrigInvoiceNum'
, PJPROJ.purchase_order_num as 'PONum'
, PJPROJ.pm_id02 as 'ProductCode'
, xIGProdCode.descr as 'Product'
, Customer.[Name] as 'CustName'
, @DATE1 as 'BeginDate'
, @DATE2 as 'EndDate'
, '' as 'ArchiveTableDup'
, @FinalPrintFlag as 'Action'
FROM PJINVDET JOIN PJINVHDR ON PJINVDET.draft_num = PJINVHDR.draft_num 
	JOIN PJPROJ ON PJINVDET.project = PJPROJ.project 
	LEFT JOIN Customer ON PJPROJ.pm_id01 = Customer.CustId 
	LEFT JOIN xIGProdCode ON PJPROJ.pm_id02 = xIGProdCode.code_ID 
	JOIN rptRuntime	ON @RI_ID = rptRuntime.RI_ID 
WHERE PJINVHDR.invoice_type <> 'REVR'
	AND PJPROJ.pm_id01 in ('1CBC00', '1MOLBD', '1MNCGP', '2CBCCO', '2CBCSC', '2CBCSW', '2MOLCO', '2MOLSW')
	AND invoice_date between @Date1 and @Date2
	AND PJINVHDR.draft_num <> ''
	AND len(PJPROJ.purchase_order_num) <> 10 --invalid PO
END --</Mojo for loading exception working TABLE when a valid PO isn't used block>

--PRINT @RI_ID_Time

SET @ArchiveTableDup = (SELECT SUM(ArchiveTableDup)
FROM xwrk_CoorsInvoice
WHERE RI_ID = @RI_ID_Time)

--PRINT @ArchiveTableDup

INSERT xwrk_CoorsInvoiceDups (InvoiceNum, RI_ID)
	SELECT DISTINCT InvoiceNum, @RI_ID
	FROM xwrk_CoorsInvoice 
	WHERE ArchiveTableDup = 1

IF @ArchiveTableDup > 0 --duplicate InvoiceNum detected in Archive TABLE
BEGIN --<Arbitrary Error Message block>
	PRINT 'Duplicate InvoiceNum detected in Archive TABLE ' + CONVERT(varchar, @RI_ID)
	RETURN
END --</Arbitrary Error Message block
END --</Determine duplication block>

BEGIN --<Preview or Final block>
--PRINT @FinalPrintFlag

IF @FinalPrintFlag = 'FALSE' --means just looking at a preview
RETURN
END --</Preview or Final block>

BEGIN --<Final Mojo block>
DECLARE @FileNaming varchar(255)

SET @FileNaming = '\\Sql1\ClientInvoiceAutomation\MillerCoors\MC_SendFile_' + REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(varchar,GetDate(), 126), '-', ''), ':', ''), 'T', ''), '.', '') + '.xml'

BEGIN --<Populate Historical Header TABLE block>
INSERT xCoorsInvoiceHistHdr
SELECT RI_ID
, UserID
, RunDate
, RunTime
, TerminalNum
, REVERSE(SUBSTRING(REVERSE(@FileNaming), 5, 17)) as 'Batch'
, @FileNaming as 'File'
, sum(InvoiceAmount) as 'BatchTotal'
, (SELECT count(a.InvoiceNum) FROM (SELECT DISTINCT InvoiceNum FROM xwrk_CoorsInvoice) a) as 'InvoiceCount'
, count(SourceTrxID) as 'RowCount'
, BeginDate
, EndDate
, '' as 'xmlFile'
, 0 as 'xmlBatchTotal'
, 0 as 'xmlInvoiceCount'
FROM xwrk_CoorsInvoice
WHERE RI_ID = @RI_ID_Time
GROUP BY RI_ID, UserID, RunDate, RunTime, TerminalNum, BeginDate, EndDate
END --</Populate Historical Header TABLE block>

BEGIN --<Populate Historical Detail TABLE block>
INSERT xCoorsInvoiceHistDet
SELECT REVERSE(SUBSTRING(REVERSE(@FileNaming), 5, 17)) as 'Batch'
, InvoiceNum
, DraftNum
, Invoice_Date
, InvoiceStatus
, InvoiceAmount
, InvoiceItemDescription
, [Function]
, Project
, ProjectDescription
, SourceTrxID
, CustCode
, InvoiceType
, OrigInvoiceNum
, PONum
, ProductCode
, Product
, CustName
, ArchiveTableDup
FROM xwrk_CoorsInvoice
WHERE RI_ID = @RI_ID_Time
	AND ArchiveTableDup = 0
END --</Populate Historical Detail TABLE block>

BEGIN --<Set Write_To_File mojo block>
SET @Content = (SELECT '808524920' as 'senderID'
, '622406635' as 'receiverID'
, RTrim(d.PONum) AS 'purchaseOrderNumber'
, d.Project
, RTrim(d.InvoiceNum) as 'integerInvoiceNumber'
, d.ProjectDescription as 'invoiceDescription'
, CONVERT(varchar, CONVERT(money, SUM(d.InvoiceAmount)), 1) as 'amount'
, GetDate() as 'invoiceDate'
FROM xCoorsInvoiceHistHdr h JOIN xCoorsInvoiceHistDet d ON h.Batch = d.Batch
WHERE h.RI_ID = @RI_ID_Time
GROUP BY d.PONum, d.Project, d.InvoiceNum, d.ProjectDescription
FOR XML RAW('integerInvoice'), ROOT('integerInvoice'), ELEMENTS)
EXEC xSQL_Write_To_File @Content, @FileNaming
END --</Set Write_To_File mojo block>

BEGIN --<xml block>
DECLARE @xmldata xml

SET @xmldata = (SELECT '808524920' as 'senderID'
, '622406635' as 'receiverID'
, RTrim(d.PONum) AS 'purchaseOrderNumber'
, d.Project
, RTrim(d.InvoiceNum) as 'integerInvoiceNumber'
, d.ProjectDescription as 'invoiceDescription'
, CONVERT(varchar, CONVERT(money, SUM(d.InvoiceAmount)), 1) as 'amount'
, GetDate() as 'invoiceDate'
FROM xCoorsInvoiceHistHdr h JOIN xCoorsInvoiceHistDet d ON h.Batch = d.Batch
WHERE h.RI_ID =  @RI_ID_Time
GROUP BY d.PONum, d.Project, d.InvoiceNum, d.ProjectDescription
FOR XML RAW('integerInvoice'), ROOT('integerInvoice'), ELEMENTS)

UPDATE xCoorsInvoiceHistHdr
SET xmlFile =  @xmldata 
WHERE RI_ID = @RI_ID_Time

BEGIN --<Retreive hash totals from xml file block>
UPDATE xCoorsInvoiceHistHdr
SET xmlBatchTotal = (SELECT xmlFile.value('sum(/integerInvoice/integerInvoice/amount)','float')
						FROM xCoorsInvoiceHistHdr)
, xmlInvoiceCount = (SELECT xmlFile.value('count(/integerInvoice/integerInvoice/integerInvoiceNumber)','int')
						FROM xCoorsInvoiceHistHdr)
WHERE RI_ID = @RI_ID_Time
END --</Retreive hash totals from xml file block>

END --</xml block>

BEGIN --<ServiceJob block>

INSERT INTO IntegerService..ServiceJob(JobType, Status, Text1, Text2, Text4)
VALUES(0 --coors ServiceJob
, 0 --0 open queued, 99 in progress, 100 error, 32 do nothing, 6 send successfull
, REVERSE(SUBSTRING(REVERSE(@FileNaming), 5, 17)) --BatchID 
, @FileNaming
, 'DALLASAPP')

END --</ServiceJob block>

END --</Final Mojo block>

--END TRY

--BEGIN CATCH

--IF @@TRANCOUNT > 0
--ROLLBACK

--DECLARE @ErrorNumberA int
--DECLARE @ErrorSeverityA int
--DECLARE @ErrorStateA varchar(255)
--DECLARE @ErrorProcedureA varchar(255)
--DECLARE @ErrorLineA int
--DECLARE @ErrorMessageA varchar(max)
--DECLARE @ErrorDateA smalldatetime
--DECLARE @UserNameA varchar(50)
--DECLARE @ErrorAppA varchar(50)
--DECLARE @UserMachineName varchar(50)

--SET @ErrorNumberA = Error_number()
--SET @ErrorSeverityA = Error_severity()
--SET @ErrorStateA = Error_state()
--SET @ErrorProcedureA = Error_procedure()
--SET @ErrorLineA = Error_line()
--SET @ErrorMessageA = Error_message()
--SET @ErrorDateA = GetDate()
--SET @UserNameA = suser_sname() 
--SET @ErrorAppA = app_name()
--SET @UserMachineName = host_name()

--EXEC dbo.xLogErrorandEmail @ErrorNumberA, @ErrorSeverityA, @ErrorStateA , @ErrorProcedureA, @ErrorLineA, @ErrorMessageA
--, @ErrorDateA, @UserNameA, @ErrorAppA, @UserMachineName

--END CATCH


--IF @@TRANCOUNT > 0
--COMMIT TRANSACTION

--END
GO
