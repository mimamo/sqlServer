USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbWIP]    Script Date: 12/21/2015 14:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xpbWIP]
@RI_ID int

AS

DELETE FROM xwrk_WIPRecon
WHERE RI_ID = @RI_ID

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

DECLARE @EndPerNbr char(6)
DECLARE @UserID	varchar(25)	
DECLARE @RunDate varchar(12)	
DECLARE @RunTime varchar(12)	
DECLARE @TerminalNum varchar(50)

SELECT @UserID = r.UserID
, @RunDate = r.SystemDate
, @RunTime = r.SystemTime
, @TerminalNum = r.ComputerName
, @EndPerNbr = endPerNbr
FROM rptRuntime r
WHERE RI_ID = @RI_ID


BEGIN
--History
INSERT INTO xwrk_WIPRecon (RI_ID, UserID, RunDate, RunTime, TerminalNum, Ledger, SRC, ClientID, Client, FiscalNo, ProductID, Product, JobID, Job, Acct, Amount)
SELECT @RI_ID as RI_ID
, @UserID
, @RunDate
, @RunTime
, @TerminalNum
, CASE WHEN Ledger = 'BEG'
	THEN 'GL'
	ELSE Ledger end as Ledger
, CASE WHEN Ledger = 'BEG'
	THEN 'GLTRAN'
	ELSE SRC end as SRC
, ClientID
, Client
, CASE WHEN FiscalNo = 'BEG'
	THEN '200608'
	ELSE FiscalNo end as FiscalNo
, ProductID
, Product
, JobID
, Job
, Acct
, Amount
FROM xWIPReconHist 
END


BEGIN
--Starting Balance is in NON POST - Run GL Detail Report for WIP for 10-2006 to get to amount
DECLARE @AdjAmt float

-- Changed the query so that all nulls would be 0 to prevent errors DAB 4.18.2013
--SET @AdjAmt = (Select Sum(Amount)*-1 from xWIPReconHist Where Ledger in ('BEG', 'GLn'))
SET @AdjAmt = (Select ISNULL(Sum(Amount)*-1,0) from xWIPReconHist Where Ledger in ('BEG', 'GLn'))

INSERT INTO xwrk_WIPRecon (RI_ID, UserID, RunDate, RunTime, TerminalNum, Ledger, SRC, ClientID, Client, FiscalNo, ProductID, Product, JobID, Job, Acct, Amount)
VALUES (@RI_ID, @UserID, @RunDate, @RunTime, @TerminalNum, 'GL', 'GLTRAN', 'NONE', 'NONE', '200609', 'NONE', 'NONE', 'NON POST', 'NON POST', '1200', @AdjAmt)
END



BEGIN
--(3a)
INSERT INTO xwrk_WIPRecon (RI_ID, UserID, RunDate, RunTime, TerminalNum, Ledger, SRC, ClientID, Client, FiscalNo, ProductID, Product, JobID, Job, Acct, Amount)
SELECT @RI_ID as RI_ID
, @UserID
, @RunDate
, @RunTime
, @TerminalNum
, 'GL' as Ledger
, 'GLTRAN' as SRC
, IsNull(RTRIM(p.pm_id01), 'NONE') as ClientID
, IsNull(c.[Name], 'NONE') as Client
, t.perpost as FiscalNo
, IsNull(rtrim(p.pm_id02), 'NONE') as ProductID
, IsNull(pc.Descr, 'NONE') as Product
, IsNull(t.projectID, 'NONE') as JobID
, IsNull(p.project_desc, 'NONE') as Job
, t.acct as Acct
, sum(t.dramt-cramt) as Amount
FROM GLTRAN t INNER JOIN Batch b ON b.module = t.module and b.batnbr = t.batnbr 
	LEFT OUTER JOIN pjproj p ON  t.projectid = p.project 
	LEFT OUTER JOIN Customer c ON p.pm_id01 = c.CustID
	LEFT OUTER JOIN xIGProdCode pc ON p.pm_id02 = code_ID
WHERE b.glpostopt = 'D'
	AND t.rlsed = '1'
	AND t.acct like  '12%'
	--and t.ProjectID <> 'Non Post'
	AND t.perpost <= @EndPerNbr
GROUP BY p.pm_id01, c.[Name], t.perpost, p.pm_id02, pc.Descr, t.projectID, p.project_desc, t.acct
END


BEGIN
--(2)
INSERT INTO xwrk_WIPRecon (RI_ID, UserID, RunDate, RunTime, TerminalNum, Ledger, SRC, ClientID, Client, FiscalNo, ProductID, Product, JobID, Job, Acct, Amount)
SELECT @RI_ID as RI_ID
, @UserID
, @RunDate
, @RunTime
, @TerminalNum
, 'PA' as Ledger
, 'PJTRAN' as SRC
, rtrim(p.pm_id01) as ClientID
, c.[Name] as Client
, t.fiscalno as FiscalNo
, rtrim(p.pm_id02) as ProductID
, pc.Descr as Product
, t.project as JobID
, p.project_desc as Job
, t.acct as Acct
, sum(t.amount) as Amount
FROM PJTRAN t INNER JOIN PJPROJ p on t.project = p.project
	LEFT OUTER JOIN Customer c ON p.pm_id01 = c.CustID
	LEFT OUTER JOIN xIGProdCode pc ON p.pm_id02 = code_ID
WHERE (t.acct like 'WIP%' or t.acct like 'APS TRANSFER%')--WIP related account categories
	AND t.fiscalno <= @EndPerNbr 	
GROUP BY p.pm_id01, c.[Name], t.fiscalno, p.pm_id02, pc.Descr, t.project, p.project_desc, t.acct
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
GO
