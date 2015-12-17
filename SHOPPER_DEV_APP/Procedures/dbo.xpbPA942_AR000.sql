USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbPA942_AR000]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 03/25/2009 MSB

CREATE PROC [dbo].[xpbPA942_AR000]
@RI_ID int


as

DELETE FROM xwrk_PA942_AR000
WHERE RI_ID = @RI_ID

--DECLARE @RI_ID int
--SET @RI_ID = 5

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @sql3 nvarchar(MAX)

SET @sql1 = CAST('BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY
DECLARE @AgingDate datetime

SET @AgingDate = (SELECT ReportDate FROM rptRuntime WHERE RI_ID = @RRI_ID)

BEGIN
INSERT xwrk_PA942_AR000
SELECT @RRI_ID as ''RI_ID''
, r.UserID as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum'' 
, CustID
, ProjectID
, ClientRefNum
, JobDescr
, ProdCode
, RefNbr
, DueDate
, DocDate
, DocType
, CuryOrigDocAmt
, CuryDocBal
, AvgDayToPay
, a.CpnyID
, 0 as ''TotalAdjdAmt''
, '''' as ''AdjdRefNbr''
, '''' as ''AdjgDocType''
, 0 as ''RecordID''
, ''1900/01/01'' as ''DateAppl''
, ClassID 
, 0 as ''CurrentAmt''
, 0 as ''Past1''
, 0 as ''Past2''
, 0 as ''Past3''
, 0 as ''Past4''
, 0 as ''Past5''
, 0 as ''Over180''
, 0 as ''Total''
, DateDiff(d, DocDate, @AgingDate) as ''DateDiffDocDate''
, DateDiff(d, DueDate, @AgingDate) as ''DateDiffDueDate''
, a.BatNbr
, a.BatSeq
FROM xvr_PA942_AR000_Aged a JOIN rptRuntime r on @RRI_ID = RI_ID
END ' as nvarchar(max))

--PRINT @sql1

SET @sql2 = CAST('BEGIN
UPDATE xwrk_PA942_AR000
SET TotalAdjdAmt = ISNULL(a.TotalAdjdAmt,0)
, AdjdRefNbr = ISNULL(a.AdjdRefNbr, '''')
FROM xwrk_PA942_AR000 LEFT JOIN (SELECT AdjdRefNbr
						, SUM(CuryAdjdAmt) as ''TotalAdjdAmt''
						FROM ARAdjust
						WHERE DateAppl <= @AgingDate
						GROUP BY AdjdRefNbr) a ON xwrk_PA942_AR000.RefNbr = a.AdjdRefNbr
WHERE RI_ID = @RRI_ID
END

BEGIN
UPDATE xwrk_PA942_AR000
SET AdjgDocType = ISNULL(a.AdjgDocType, '''')
, RecordID = ISNULL(a.RecordID, 0)
, DateAppl = ISNULL(a.DateAppl, ''1900/01/01'')
FROM xwrk_PA942_AR000 LEFT JOIN ARAdjust a on xwrk_PA942_AR000.RefNbr = a.AdjdRefNbr
WHERE RI_ID = @RRI_ID
END

BEGIN
UPDATE xwrk_PA942_AR000
SET TotalAdjdAmt = ISNULL(CuryOrigDocAmt - CuryDocBal, 0)
	, AdjgDocType = ''DV'' --derived
WHERE AdjdRefNbr = ''''
	AND AdjgDocType = ''''
	AND DateAppl = ''1900/01/01''
	AND RecordID = 0
	AND CuryOrigDocAmt <> CuryDocBal
	AND RI_ID = @RRI_ID
END


BEGIN
UPDATE xwrk_PA942_AR000
SET CurrentAmt = CASE WHEN DateDiffDocDate <= 30
						THEN CuryOrigDocAmt - TotalAdjdAmt
						ELSE 0 end
, Past1 = CASE WHEN DateDiffDocDate between 31 and 60
						THEN CuryOrigDocAmt - TotalAdjdAmt
						ELSE 0 end 
, Past2 = CASE WHEN DateDiffDocDate between 61 and 90
						THEN CuryOrigDocAmt - TotalAdjdAmt
						ELSE 0 end
, Past3 = CASE WHEN DateDiffDocDate between 91 and 120
						THEN CuryOrigDocAmt - TotalAdjdAmt
						ELSE 0 end
, Past4 = CASE WHEN DateDiffDocDate between 121 and 150
						THEN CuryOrigDocAmt - TotalAdjdAmt
						ELSE 0 end
, Past5 = CASE WHEN DateDiffDocDate between 151 and 180
						THEN CuryOrigDocAmt - TotalAdjdAmt
						ELSE 0 end
, Over180 = CASE WHEN DateDiffDocDate > 180
						THEN CuryOrigDocAmt - TotalAdjdAmt
						ELSE 0 end
WHERE RI_ID = @RRI_ID
END ' as nvarchar(max))

--PRINT @sql2

SET @sql3 = CAST('

BEGIN
UPDATE xwrk_PA942_AR000
SET Total = CurrentAmt + Past1 + Past2 + Past3 + Past4 + Past5 + Over180
WHERE RI_ID = @RRI_ID
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
--PRINT @sql3

DECLARE @sql5 nvarchar(MAX)

SET @sql5 = @sql1+@sql2+@sql3

--xPrintMax @sql5
--PRINT @sql5

DECLARE @ParmDef nvarchar(100)
SET @ParmDef = N'@RRI_ID int'

EXEC sp_executesql @sql5, @ParmDef, @RRI_ID = @RI_ID
GO
