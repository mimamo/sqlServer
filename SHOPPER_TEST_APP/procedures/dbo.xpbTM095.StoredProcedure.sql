USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbTM095]    Script Date: 12/21/2015 16:07:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/12/2009 JWG & MSB

CREATE PROC [dbo].[xpbTM095](
@RI_ID int
)

AS

DELETE FROM xwrk_TM095
WHERE RI_ID = @RI_ID

BEGIN
--SET NOCOUNT ON added to prevent extra result sets from
--interfering with SELECT statements.
SET NOCOUNT ON;

BEGIN TRAN

BEGIN TRY

DECLARE @YearWorked int
DECLARE @YearPosted int

SET @YearWorked = CASE WHEN (SELECT Len(LongAnswer00) FROM rptRuntime WHERE RI_ID = @RI_ID) = 0
					THEN year(GetDate()) - 1
					ELSE (SELECT LongAnswer00 FROM rptRuntime WHERE RI_ID = @RI_ID) end

SET @YearPosted = CASE WHEN (SELECT Len(LongAnswer01) FROM rptRuntime WHERE RI_ID = @RI_ID) = 0
					THEN year(GetDate())
					ELSE (SELECT LongAnswer01 FROM rptRuntime WHERE RI_ID = @RI_ID) end

INSERT xwrk_TM095 ( [RI_ID], [UserID], [RunDate], [RunTime], [TerminalNum], [Account], [Employee_ID], [Employee_Name], [Sub_Account]
, [Department], [Job], [Job_Description], [Timecard_Status], [Week_Ending_Date], [DocNbr], [BatchID], [Date_Entered]
, [CreatedDateTime], [Hours], [Client_ID], [ClassID], [Client_Name], [Fiscal_No], [DetailNum], [Product_ID], [xTrans_Date], [Product]
, [Title], [ProdGroup], [xConDate], [YearWorked], [YearPosted], [System_cd])
SELECT DISTINCT @RI_ID as 'RI_ID'
, rptRuntime.UserID as 'UserID'
, rptRuntime.SystemDate as 'RunDate'
, rptRuntime.SystemTime as 'RunTime'
, rptRuntime.ComputerName as 'TerminalNum'
, PJTRAN.acct as 'Account'
, PJEMPLOY.employee as 'Employee_ID'
, REPLACE(PJEMPLOY.emp_name, '~', ', ') as 'Employee_Name'
, PJTRAN.gl_subacct as 'Sub_Account'
, SubAcct.Descr as 'Department'
, PJTRAN.project as 'Job'
, PJPROJ.project_desc as 'Job_Description'
, PJLABHDR.le_status as 'Timecard_Status'
, PJLABHDR.pe_date as 'Week_Ending_Date'
, PJTRAN.bill_batch_id as 'DocNbr'
, PJTRAN.batch_id as 'BatchID'
, PJTRAN.trans_date as 'Date_Entered'
, PJLABHDR.crtd_datetime as 'CreatedDateTime'
, PJTRAN.units as 'Hours'
, Customer.custID as 'Client_ID'
, PJPROJ.contract_type as 'ClassID'
, Customer.[Name] as 'Client_Name'
, PJTRAN.fiscalno as 'Fiscal_No'
, PJTRAN.detail_num as 'DetailNum'
, xIGProdCode.code_ID as 'Product_ID'
, CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date)) as 'xTrans_Date'
, xIGProdCode.descr as 'Product'
, PJTITLE.code_value_desc as 'Title'
, xIGProdCode.code_group as 'ProdGroup'
, CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + '/' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
		WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1') as smalldatetime) end as 'xConDate' 
, @YearWorked as 'YearWorked'
, @YearPosted as 'YearPosted'
, PJTRAN.system_cd as 'System_cd'
FROM PJTRAN (nolock) JOIN PJPROJ (nolock) ON PJTRAN.project = PJPROJ.project 
	LEFT JOIN PJLABHDR (nolock) ON PJTRAN.employee = PJLABHDR.employee and PJTRAN.bill_batch_id = PJLABHDR.docnbr 
	JOIN PJEMPLOY (nolock) ON PJTRAN.employee = PJEMPLOY.employee 
	LEFT JOIN Customer ON PJPROJ.pm_id01 = Customer.CustID 
	LEFT JOIN xIGProdCode ON PJPROJ.pm_id02 = xIGProdCode.code_ID 
	LEFT JOIN SubAcct ON PJTRAN.gl_subacct = SubAcct.sub 
	LEFT JOIN xPJEMPPJT ON PJTRAN.employee = xPJEMPPJT.employee 
	LEFT JOIN PJCODE AS PJTITLE (nolock) ON xPJEMPPJT.labor_class_cd = PJTITLE.code_value 
	JOIN rptRuntime	ON @RI_ID = rptRuntime.RI_ID
WHERE PJTRAN.acct = 'LABOR'
	AND PJEMPLOY.emp_type_cd <> 'PROD'
	AND PJTITLE.code_type = 'LABC'
	AND YEAR(PJTRAN.trans_date) = @YearWorked --Date_Entered
	AND SUBSTRING(PJTRAN.fiscalno, 1, 4) = @YearPosted --Fiscal_No
	AND PJLABHDR.le_status in ('A', 'C', 'I', 'P')

END TRY
    
BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK

DECLARE @ErrorNumberA int
DECLARE @ErrorSeverityA int
DECLARE @ErrorStateA varchar(255)
DECLARE @ErrorProcedureA varchar(255)
DECLARE @ErrorLineA int
DECLARE @ErrorMessageA varchar(max)
DECLARE @ErrorDateA smalldatetime
DECLARE @UserNameA varchar(50)
DECLARE @ErrorAppA varchar(50)
DECLARE @UserMachineName varchar(50)

SET @ErrorNumberA = Error_number()
SET @ErrorSeverityA = Error_severity()
SET @ErrorStateA = Error_state()
SET @ErrorProcedureA = Error_procedure()
SET @ErrorLineA = Error_line()
SET @ErrorMessageA = Error_message()
SET @ErrorDateA = GetDate()
SET @UserNameA = suser_sname() 
SET @ErrorAppA = app_name()
SET @UserMachineName = host_name()

EXEC dbo.xLogErrorandEmail @ErrorNumberA, @ErrorSeverityA, @ErrorStateA , @ErrorProcedureA, @ErrorLineA, @ErrorMessageA
, @ErrorDateA, @UserNameA, @ErrorAppA, @UserMachineName

END CATCH

IF @@TRANCOUNT > 0
COMMIT TRANSACTION

END
GO
