USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpzAged]    Script Date: 12/21/2015 13:45:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpzAged]  
 @RI_ID int  
  
as  
  
BEGIN

DECLARE @AgingDate smalldatetime  
DECLARE @PerPost VARCHAR(6)

DELETE FROM xwrk_AgedTwox  
WHERE RI_ID = @RI_ID  
  
SET @AgingDate = (SELECT ReportDate FROM rptRuntime WHERE RI_ID = @RI_ID)  
  
SELECT @PerPost = BegPerNbr  
FROM rptRuntime   
WHERE RI_ID = @RI_ID  
  
INSERT xwrk_AgedTwox  
SELECT @RI_ID as 'RI_ID'  
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
FROM xvr_AR000_Agedx a JOIN rptRuntime r on @RI_ID = RI_ID  
WHERE a.s4Future01 <= @PerPost  
        AND (a.perclosed > @PerPost or perclosed = ' ')
		AND DocDate >= '10/01/2006'  

/*BEGIN DAVID MARTIN 12/18/13 UPDATES*/
--Payments and Small Balance Adjsutments
UPDATE xwrk_AgedTwox
SET TotalAdjdAmt = TotalAdjdAmt + ISNULL(AA.Amt,0)
FROM xwrk_AgedTwox LEFT JOIN	(SELECT		SUM(AdjAmt) AS 'Amt',AdjdRefNbr
								FROM        ARAdjust
								WHERE		AdjgDocType IN ('PA','SB','CM') and PerAppl <=@PerPost
								GROUP BY	AdjdRefNbr) AA ON AA.AdjdRefNbr = xwrk_AgedTwox.RefNbr
WHERE RI_ID = @RI_ID
--Credit Memo Applications (Needed to Reflect partial use of credit memos
UPDATE xwrk_AgedTwox
SET TotalAdjdAmt = TotalAdjdAmt + ISNULL(AA.Amt,0)
FROM xwrk_AgedTwox LEFT JOIN	(SELECT		0 - SUM(AdjAmt) AS 'Amt',AdjgRefNbr
								FROM        ARAdjust
								WHERE		AdjgDocType IN ('CM') and PerAppl <=@PerPost
								GROUP BY	AdjgRefNbr) AA ON AA.AdjgRefNbr = xwrk_AgedTwox.RefNbr
WHERE RI_ID = @RI_ID
--Small Credit Adjustments
UPDATE xwrk_AgedTwox
SET TotalAdjdAmt = TotalAdjdAmt + ISNULL(AA.Amt,0)
FROM xwrk_AgedTwox LEFT JOIN	(SELECT		0 - SUM(AdjAmt) AS 'Amt',AdjdRefNbr
								FROM        ARAdjust
								WHERE		AdjgDocType = 'SC' and PerAppl <=@PerPost
								GROUP BY	AdjdRefNbr) AA ON AA.AdjdRefNbr = xwrk_AgedTwox.RefNbr
WHERE RI_ID = @RI_ID
--On Account Payments Applied
UPDATE xwrk_AgedTwox
SET TotalAdjdAmt = TotalAdjdAmt + ISNULL(AA.Amt,0)
FROM xwrk_AgedTwox LEFT JOIN	(SELECT		0 - SUM(AdjAmt) AS 'Amt',AdjgRefNbr, CustID
								FROM        ARAdjust
								WHERE		AdjgDocType = 'PA' and PerAppl <=@PerPost
								GROUP BY	AdjgRefNbr, CustID) AA ON AA.AdjgRefNbr = xwrk_AgedTwox.RefNbr AND AA.CustID = xwrk_AgedTwox.CustID
WHERE RI_ID = @RI_ID
					
/*END DAVID MARTIN 12/18/13 UPDATES*/


-- final bucket assignment

UPDATE xwrk_AgedTwox  
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
  
UPDATE xwrk_AgedTwox  
SET Total = [Current] + Past1 + Past2 + Past3 + Past4 + Over180  
WHERE RI_ID = @RI_ID  

END  
  



/*DEPRECATED CODE*/
/*
-- update invoice balances

UPDATE xwrk_AgedTwox  
SET TotalAdjdAmt = ISNULL(a.TotalAdjdAmt,0)  
, AdjdRefNbr = ISNULL(a.AdjdRefNbr, '')  
FROM xwrk_AgedTwox LEFT JOIN (SELECT	AdjdRefNbr  
										,SUM(CuryAdjdAmt) as 'TotalAdjdAmt'  
							  FROM ARAdjust  
							  WHERE PerAppl <= @PerPost   --AdjgPerPost <= @PerPost 12/18/13 Fix report to use correct period field  
							  GROUP BY AdjdRefNbr) a ON xwrk_AgedTwox.RefNbr = a.AdjdRefNbr  
WHERE RI_ID = @RI_ID  
   
-- reconcile applied documents (in the previous update)
/*
UPDATE xwrk_AgedTwox  
SET AdjgDocType = ISNULL(a.AdjgDocType, '')  
, RecordID = ISNULL(a.RecordID, 0)  
, DateAppl = ISNULL(a.DateAppl, '1900/01/01')  
FROM xwrk_AgedTwox LEFT JOIN ARAdjust a on xwrk_AgedTwox.RefNbr = a.AdjdRefNbr  
WHERE RI_ID = @RI_ID  

UPDATE xwrk_AgedTwox  
SET TotalAdjdAmt = ISNULL(CuryOrigDocAmt - CuryDocBal, 0)  
 , AdjgDocType = 'DV' --derived  
WHERE AdjdRefNbr = ''  
 AND AdjgDocType = ''  
 AND DateAppl = '1900/01/01'  
 AND RecordID = 0  
 AND CuryOrigDocAmt <> CuryDocBal  
 AND RI_ID = @RI_ID 
*/

UPDATE	WRK
SET		WRK.TotalAdjdAmt = WRK.CuryOrigDocAmt - WRK.CuryDocBal
		,WRK.AdjgDocType = 'DV'
FROM	xwrk_AgedTwox WRK INNER JOIN ARAdjust ARA ON WRK.RefNbr = ARA.AdjgRefNbr 
		INNER JOIN ARDoc ARH ON ARA.AdjdRefNbr = ARH.RefNbr 
WHERE	ARH.PerPost <= @PerPost  
		AND RI_ID = @RI_ID 
*/
GO
