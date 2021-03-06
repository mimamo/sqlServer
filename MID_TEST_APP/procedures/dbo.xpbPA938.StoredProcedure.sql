USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbPA938]    Script Date: 12/21/2015 15:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/09/2009 JWG & MSB

CREATE PROC [dbo].[xpbPA938] (
@RI_ID int
)

AS

DELETE FROM xwrk_PA938
WHERE RI_ID = @RI_ID


--DECLARE @RI_ID int
--SET @RI_ID = 1611

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @RI_WHERE varchar(MAX)

SET @RI_WHERE = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM rptRuntime WHERE RI_ID = @RI_ID)
--PRINT @RI_WHERE
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_PA938.', '')

--PRINT @RI_WHERE

SET @sql1 = CAST('
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY


DECLARE @FunctCode varchar(255)

SET @FunctCode = '''' + (SELECT RTRIM(LongAnswer00) FROM rptRuntime WHERE RI_ID = @RRI_ID) + ''''

INSERT xwrk_PA938 ([RI_ID],[UserID],[RunDate],[RunTime],[TerminalNum],[CustomerCode],[CustomerName],[ProductCode],[ProductDesc],[Project]
,[JobCat],[ExtCost],[CostVouched],[ProjectDesc],[PONumber],[StatusPA],[StartDate],[OnShelfDate],[CloseDate],[Type],[SubType],[ECD],[OfferNum]
,[ClientContact],[ContactEmailAddress],[Differentiator],[PTODesignator],[PM],[FJ_Estimate],[EstimateAmountEAC],[EstimateAmountFAC],[EstimateAmountTotal]
,[ActAcct],[Amount01],[Amount02],[Amount03],[Amount04],[Amount05],[Amount06],[Amount07],[Amount08],[Amount09],[Amount10],[Amount11]
,[Amount12],[Amount13],[Amount14],[Amount15],[AmountBF],[FSYearNum],[AcctGroupCode],[ControlCode],[FunctionsEntered])
SELECT a.*
FROM(
SELECT @RRI_ID as ''RI_ID''
, r.UserId as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, p.pm_id01 as ''CustomerCode''
, isnull(c.[name],''Customer Name Unavailable'') as ''CustomerName''
, p.pm_id02 as ''ProductCode''
, isnull(bcyc.code_value_desc,'''') as ''ProductDesc''
, p.project as ''Project''
, p.contract_type as ''JobCat''
, po.ExtCost as ''ExtCost''
, po.CostVouched as ''CostVouched''
, p.project_desc as ''ProjectDesc''
, p.purchase_order_num as ''PONumber''
, p.status_pa as ''StatusPA''
, p.start_date as ''StartDate''
, p.end_date AS ''OnShelfDate''
, p.pm_id08 AS ''CloseDate''
, p.pm_id04 AS ''[Type]''
, p.pm_id05 AS ''SubType''
, x.pm_id28 AS ''ECD''
, p.pm_id32 AS ''OfferNum''
, ISNULL(xc.CName, '''') as ''ClientContact''
, ISNULL(xc.EmailAddress, '''') as ''ContactEmailAddress''
, p.user3 as ''Differentiator''
, p.user4 as ''PTODesignator''
, p.manager1 as ''PM''
, isnull(x.pm_id26,0) as ''FJ_Estimate''
, isnull(est.EstimateAmountEAC,0) as ''EstimateAmountEAC''
, isnull(est.EstimateAmountFAC,0) as ''EstimateAmountFAC''
, isnull(est.EstimateAmountTotal,0) as ''EstimateAmountTotal''
, isnull(act.Acct,'''') as ''ActAcct''
, isnull(act.Amount01,0) as ''Amount01''
, isnull(act.Amount02,0) as ''Amount02''
, isnull(act.Amount03,0) as ''Amount03''
, isnull(act.Amount04,0) as ''Amount04''
, isnull(act.Amount05,0) as ''Amount05''
, isnull(act.Amount06,0) as ''Amount06''
, isnull(act.Amount07,0) as ''Amount07''
, isnull(act.Amount08,0) as ''Amount08''
, isnull(act.Amount09,0) as ''Amount09''
, isnull(act.Amount10,0) as ''Amount10''
, isnull(act.Amount11,0) as ''Amount11''
, isnull(act.Amount12,0) as ''Amount12''
, isnull(act.Amount13,0) as ''Amount13''' as nvarchar(max)) + char(13)
SET @sql2 = CAST('
, isnull(act.Amount14,0) as ''Amount14''
, isnull(act.Amount15,0) as ''Amount15''
, isnull(act.AmountBF,0) as ''AmountBF''
, isnull(act.FSYearNum,''1900'') as ''FSYearNum''
, isnull(act.AcctGroupCode,'''') as ''AcctGroupCode''
, isnull(act.ControlCode,'''') as ''ControlCode''
, @FunctCode as ''FunctionsEntered''
FROM PJPROJ p LEFT JOIN Customer c on p.pm_id01 = c.custid
	LEFT JOIN PJCODE bcyc on p.pm_id02 = bcyc.code_value and bcyc.code_type = ''BCYC''
	LEFT JOIN xvr_PA938_Estimates est on p.project = est.project
	LEFT JOIN xvr_PA938_Actuals act on p.project = act.project
	LEFT JOIN xvr_PA938_PO po on p.project = po.ProjectID
	LEFT JOIN PJPROJEX x ON p.project = x.project
	LEFT JOIN xClientContact xc ON p.user2 = xc.EA_ID
	LEFT JOIN rptRuntime r ON @RRI_ID = RI_ID
WHERE p.project in (SELECT DISTINCT Project
FROM PJPENT WHERE pjt_entity in (SELECT theValue FROM dbo.[xfn_DelimitedToTable2](@FunctCode, '',''))) ) a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + '


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

' as nvarchar(max))

DECLARE @sql3 nvarchar(max)
SET @sql3 = @sql1 + @sql2

--EXEC xPrintMax @sql3

DECLARE @ParmDef nvarchar(100)
SET @ParmDef = N'@RRI_ID int'

EXEC sp_executesql @sql3, @ParmDef, @RRI_ID = @RI_ID
GO
