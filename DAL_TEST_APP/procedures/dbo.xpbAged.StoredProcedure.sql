USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbAged]    Script Date: 12/21/2015 13:57:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpbAged]
	@RI_ID int

as

DECLARE @AgingDate smalldatetime

DELETE FROM xwrk_AgedTwo
WHERE RI_ID = @RI_ID

SET @AgingDate = (SELECT ReportDate FROM rptRuntime WHERE RI_ID = @RI_ID)

BEGIN
INSERT	xwrk_AgedTwo
SELECT	@RI_ID as 'RI_ID'
		, r.UserID as 'UserID'
		, r.SystemDate as 'RunDate'
		, r.SystemTime as 'RunTime'
		, r.ComputerName as 'TerminalNum' 
		, CustID
		, ProjectID
		, ClientRefNum
		, JobDescr
		, ProdCode
		, PerPost
		, RefNbr
		, DueDate
		, DocDate
		, DocType
		, CuryOrigDocAmt
		, CuryDocBal
		, AvgDayToPay
		, a.CpnyID
		, 0 as 'TotalAdjdAmt'
		, '' as 'AdjdRefNbr'
		, '' as 'AdjgDocType'
		, 0 as 'RecordID'
		, '1900/01/01' as 'DateAppl'
		, ClassID 
		, 0 as 'Current'
		, 0 as 'Past1'
		, 0 as 'Past2'
		, 0 as 'Past3'
		, 0 as 'Past4'
		, 0 as 'Over180'
		, 0 as 'Total'
		, DateDiff(d, DocDate, @AgingDate) as 'DateDiffDocDate'
		, DateDiff(d, DueDate, @AgingDate) as 'DateDiffDueDate'
FROM	xvr_AR000_Aged a JOIN rptRuntime r on @RI_ID = RI_ID
WHERE	a.s4Future01 <= r.begpernbr 
        AND (a.perclosed > r.begpernbr or perclosed = ' ')
END

BEGIN
UPDATE xwrk_AgedTwo
SET TotalAdjdAmt = ISNULL(a.TotalAdjdAmt,0)
, AdjdRefNbr = ISNULL(a.AdjdRefNbr, '')
FROM xwrk_AgedTwo LEFT JOIN (SELECT AdjdRefNbr
						, SUM(CuryAdjdAmt) as 'TotalAdjdAmt'
						FROM ARAdjust
						WHERE DateAppl <= @AgingDate
						GROUP BY AdjdRefNbr) a ON xwrk_AgedTwo.RefNbr = a.AdjdRefNbr
WHERE RI_ID = @RI_ID
END

BEGIN
UPDATE xwrk_AgedTwo
SET AdjgDocType = ISNULL(a.AdjgDocType, '')
, RecordID = ISNULL(a.RecordID, 0)
, DateAppl = ISNULL(a.DateAppl, '1900/01/01')
FROM xwrk_AgedTwo LEFT JOIN ARAdjust a on xwrk_AgedTwo.RefNbr = a.AdjdRefNbr
WHERE RI_ID = @RI_ID
END

BEGIN
UPDATE xwrk_AgedTwo
SET TotalAdjdAmt = ISNULL(CuryOrigDocAmt - CuryDocBal, 0)
	, AdjgDocType = 'DV' --derived
WHERE AdjdRefNbr = ''
	AND AdjgDocType = ''
	AND DateAppl = '1900/01/01'
	AND RecordID = 0
	AND CuryOrigDocAmt <> CuryDocBal
	AND RI_ID = @RI_ID
END

BEGIN
UPDATE xwrk_AgedTwo
SET [Current] = CASE WHEN DateDiffDocDate <= 30
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
, Past4 = CASE WHEN DateDiffDocDate between 121 and 180
						THEN CuryOrigDocAmt - TotalAdjdAmt
						ELSE 0 end
, Over180 = CASE WHEN DateDiffDocDate > 180
						THEN CuryOrigDocAmt - TotalAdjdAmt
						ELSE 0 end
WHERE RI_ID = @RI_ID
END

BEGIN
UPDATE xwrk_AgedTwo
SET Total = [Current] + Past1 + Past2 + Past3 + Past4 + Over180
WHERE RI_ID = @RI_ID
END
GO
