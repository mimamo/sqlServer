USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpbBI904]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpbBI904] (
@RI_ID int
)

AS


--DECLARE @RI_ID int
--SET @RI_ID = 1012

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @sql3 nvarchar(MAX)
DECLARE @sql4 nvarchar(MAX) --many variables have to be declared to get around the db compaitibility 80 issue
--DSL doesn''t function correctly with the current SP on compatibility 90

DECLARE @RI_WHERE varchar(MAX)

SET @RI_WHERE = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM rptRuntime WHERE RI_ID = @RI_ID)
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_BI904.', '')

SET @sql1 = CAST('
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

BEGIN
DELETE FROM xwrk_BI904
WHERE RI_ID = @RRI_ID

DECLARE @BegPerNbr char(6)
DECLARE @AgingDate smalldatetime

SET @BegPerNbr = (SELECT LTRIM(RTRIM(BegPerNbr)) FROM rptRuntime WHERE RI_ID = @RRI_ID)
SET @AgingDate = (SELECT LongAnswer00 FROM rptRuntime WHERE RI_ID = @RRI_ID)

IF @AgingDate = ''01/01/1900''
BEGIN
SET @AgingDate = GetDate()
END

INSERT xwrk_BI904 (RI_ID, UserID, RunDate, RunTime, TerminalNum, Status, project_billwith, hold_status, acct, source_trx_date, amount, JobID
, Job, sort_num, fiscalno, ClientID, ProductID, Product, OnShelfDate, PM, ClientRefNum, OpenDate, CloseDate, ECD
, OfferNum, li_type, Client, AcctGroupCode, Bill_Status, EstAmount, OpenPO, BTD, Actuals, ActualsToBill, EstAmountRem, ClientContactID,
ClientContactName, ClientIdentifier, Brand, Director, AcctService, CurrLockedEst, UnlockedEst, ClassID, CurrentAmt, Past1, Past2, Past3, Over120, Total)
SELECT RI_ID, UserID, RunDate, RunTime, TerminalNum, Status, project_billwith, hold_status, acct, source_trx_date, amount, JobID
, Job, sort_num, fiscalno, ISNULL(ClientID, '''') as ''ClientID'', ISNULL(ProductID, '''') as ''ProductID''
, ISNULL(Product, '''') as ''Product'', ISNULL(OnShelfDate, ''01/01/1900'') as ''OnShelfDate'', PM, ClientRefNum, ISNULL(OpenDate, ''01/01/1900'') as ''OpenDate''
, ISNULL(CloseDate, ''01/01/1900'') as ''CloseDate'', ISNULL(ECD, ''01/01/1900'') as ''ECD'', OfferNum, li_type, ISNULL(Client, '''') as ''Client''
, acct_group_cd as ''AcctGroupCode'', Bill_Status, ISNULL(EstAmount, 0) as ''EstAmount'', ISNULL(OpenPO, 0) as ''OpenPO'', ISNULL(BTD, 0) as ''BTD''
, ISNULL(Actuals, 0) as ''Actuals'', ISNULL(ActualsToBill, 0) as ''ActualsToBill'', ISNULL(EstAmountRem, 0) as ''EstAmountRem'', ClientContactID
, ClientContactName, ClientIdentifier, Brand, Director, AcctService, CurrLockedEst, UnlockedEst, ClassID, CurrentAmt, Past1, Past2, Past3, Over120, Total
FROM(
SELECT @RRI_ID as ''RI_ID''
, r.UserId as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, p.status_pa as ''Status''
, d.project_billwith
, d.hold_status
, d.acct
, d.source_trx_date
, d.amount
, d.project as ''JobID''
, p.project_desc as ''Job''
, a.sort_num
, d.fiscalno
, p.pm_id01 as ''ClientID''
, p.pm_id02 as ''ProductID''
, x.descr as ''Product''
, p.end_date as ''OnShelfDate''
, p.manager1 as ''PM''
, p.purchase_order_num as ''ClientRefNum''
, p.[start_date] as ''OpenDate''
, p.pm_id08 as ''CloseDate''
, ex.PM_ID28 as ''ECD''
, p.pm_id32 as ''OfferNum''
, d.li_type
, c.[Name] as ''Client''
, a.acct_group_cd
, CASE WHEN ISNULL(h.fiscalno, '''') > @BegPerNbr
		THEN ''U''
		WHEN ISNULL(h.fiscalno, '''') = ''''
		THEN ''U''
		ELSE ''B''end as ''Bill_Status''
, 0 as ''EstAmount'' 
, 0 as ''OpenPO'' ' as nvarchar(MAX)) + char(13) 
SET @sql2 = CAST('
, 0 as ''BTD''
, 0 as ''Actuals''
, 0 as ''ActualsToBill''
, 0 as ''EstAmountRem''
, p.user2 as ''ClientContactID''
, ISNULL(xc.CName, '''') as ''ClientContactName''
, ISNULL(xR.ClientIdentifier, '''') as ''ClientIdentifier''
, ISNULL(xR.Brand, '''') as ''Brand''
, ISNULL(xR.Director, '''') as ''Director''
, ISNULL(p.Manager2, '''') as ''AcctService''
, 0 as ''CurrLockedEst'' 
, 0 as ''UnlockedEst'' 
, c.classid as ''ClassID''
, 0 as ''CurrentAmt'' -- 0 to 30
, 0 as ''Past1'' -- 31 to 60
, 0 as ''Past2'' -- 61 to 90
, 0 as ''Past3'' -- 91 to 120
, 0 as ''Over120'' -- >120
, 0 as ''Total''
FROM PJINVDET d (nolock) LEFT JOIN PJINVHDR h (nolock) ON d.draft_num = h.draft_num
	JOIN PJPROJ p (nolock) ON d.project = p.project 
	JOIN PJACCT a (nolock) ON d.acct = a.acct
	LEFT JOIN xIGProdCode x (nolock) ON p.pm_id02 = x.code_ID
	LEFT JOIN Customer c (nolock) ON p.pm_id01 = c.CustId
	JOIN rptRuntime r (nolock) ON r.RI_ID = @RRI_ID	
	LEFT JOIN PJPROJEX ex (nolock) ON d.project = ex.project
	LEFT JOIN xIGProdReporting xR (nolock) ON p.pm_id02 = xR.ProdID
	LEFT JOIN xClientContact xc (nolock) ON p.user2 = xc.EA_ID
WHERE d.hold_status <> ''PG'' 
	AND d.fiscalno <= @BegPerNbr
	AND a.acct_group_cd NOT IN (''CM'', ''FE'')
	AND p.project NOT IN (SELECT JobID FROM xWIPAgingException)
	AND p.contract_type <> ''APS''
	AND (substring(d.acct, 1, 6) <> ''OFFSET'' OR d.acct = ''OFFSET PREBILL'')
	AND d.amount <> 0
) a
WHERE '+ CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + '

BEGIN
UPDATE x3
SET BTD = ISNULL(act.BTD, 0)
, Actuals = ISNULL(act.Actuals, 0)
, EstAmount = ISNULL(e.EstimateAmountTotal, 0)
, OpenPO = ISNULL(po.OpenPO, 0)
, CurrLockedEst = ISNULL(cle.CLEAmount, 0)
, UnlockedEst = ISNULL(ule.ULEAmount, 0)
FROM xwrk_BI904 x3 LEFT JOIN xvr_BI904_Actuals act ON x3.JobID = act.project
	AND act.RI_ID = @RRI_ID
	LEFT JOIN xvr_BI904_Estimates e ON x3.JobID = e.project
	LEFT JOIN xvr_BI904_PO po ON x3.JobID = po.ProjectID
	LEFT JOIN xvr_Est_CLE_Project cle ON x3.JobID = cle.project
	LEFT JOIN xvr_Est_ULE_Project ule ON x3.JobID = ule.project
	JOIN rptruntime r ON r.RI_ID = @RRI_ID
WHERE x3.RI_ID = @RRI_ID
	AND act.FSYearNum = LEFT(@BegPerNbr, 4)
END


BEGIN
UPDATE x3
SET ActualsToBill = Actuals - BTD
, EstAmountRem = EstAmount - Actuals - OpenPO
FROM xwrk_BI904 x3 JOIN rptRuntime r ON r.RI_ID = @RRI_ID
WHERE x3.RI_ID = @RRI_ID
END


BEGIN
UPDATE xwrk_BI904
SET CurrentAmt = CASE WHEN (DateDiff(d, source_trx_date, @AgingDate) <= 30) AND li_type NOT IN (''D'', ''A'') AND Bill_Status <> ''B''
						THEN amount
						ELSE 0 end
, Past1 = CASE WHEN (DateDiff(d, source_trx_date, @AgingDate) BETWEEN 31 AND 60) AND li_type NOT IN (''D'', ''A'') AND Bill_Status <> ''B'' 
				THEN amount
				ELSE 0 end
, Past2 = CASE WHEN (DateDiff(d, source_trx_date, @AgingDate) BETWEEN 61 AND 90) AND li_type NOT IN (''D'', ''A'') AND Bill_Status <> ''B'' 
				THEN amount
				ELSE 0 end
, Past3 = CASE WHEN (DateDiff(d, source_trx_date, @AgingDate) BETWEEN 91 AND 120) AND li_type NOT IN (''D'', ''A'') AND Bill_Status <> ''B''
				THEN amount
				ELSE 0 end
, Over120 = CASE WHEN (DateDiff(d, source_trx_date, @AgingDate) > 120) AND li_type NOT IN (''D'', ''A'') AND Bill_Status <> ''B''
				THEN amount
				ELSE 0 end
WHERE RI_ID = @RRI_ID
END 

BEGIN
UPDATE xwrk_BI904
SET Total = CurrentAmt + Past1 + Past2 + Past3 + Over120
WHERE RI_ID = @RRI_ID
END

BEGIN
DELETE FROM xwrk_BI904
WHERE ROUND(Total, 2) = 0
	AND ROUND(CurrentAmt, 2) = 0
	AND ROUND(Past1, 2) = 0
	AND ROUND(Past2, 2) = 0
	AND ROUND(Past3, 2) = 0
	AND ROUND(Over120, 2) = 0
	AND RI_ID = @RRI_ID
END


END

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



DECLARE @sql5 nvarchar(MAX)

SET @sql5 = @sql1 + @sql2 + @sql3 + @sql4

--EXEC xPrintMax @sql5

DECLARE @ParmDef nvarchar(100)
SET @ParmDef = N'@RRI_ID int'

EXEC sp_executesql @sql5, @ParmDef, @RRI_ID = @RI_ID
GO
