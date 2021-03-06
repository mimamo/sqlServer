USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[vr_PSSFA716]    Script Date: 12/21/2015 14:05:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vr_PSSFA716] AS

SELECT T.CrAcct AS 'Acct', A.Descr AS 'Acct_Descr', A.AcctType, 
AcctType_Descr = CASE WHEN (SUBSTRING(A.AcctType,2,1)) = 'A' THEN 'Assets'
                      WHEN (SUBSTRING(A.AcctType,2,1)) = 'L' THEN 'Liabilities'
                      WHEN (SUBSTRING(A.AcctType,2,1)) = 'I' THEN 'Income'
                      WHEN (SUBSTRING(A.AcctType,2,1)) = 'E' THEN 'Expenses'
                      ELSE '' END, 
T.Amt, F.CuryId AS 'Asset_Currency', F.AssetDescr, T.AssetId, T.AssetSubId, T.BaseCuryId, T.BatNbr, T.BookCode, T.BookSeq, T.CpnyId,  T.CuryAmt, T.CuryId, T.DeprMethod, B.LedgerId, T.LineId, T.LTDDepr, T.PerPost, B.PostGL, T.CrSubAcct AS 'SubAcct', U.Descr AS 'SubAcct_Descr', 'CR' AS 'Type',
K.AccumDep, K.Basis, K.Cost, K.CuryAccumDep, K.CuryBasis, K.CuryCost, K.DeprFromPerNbr, K.LastDeprPerNbr, K.SalvageValue, K.UsefulLife  
FROM PSSFATran T
INNER JOIN Account A (NOLOCK)  ON T.CRAcct = A.Acct 
INNER JOIN SubAcct U (NOLOCK)  ON T.CRSubAcct  = U.Sub
INNER JOIN PSSFAAssets F (NOLOCK)  ON T.AssetId  = F.AssetId and T.AssetSubId  = F.AssetSubId 
INNER JOIN PSSFABookCode B (NOLOCK)  ON T.BookCode  = B.BookCode
INNER JOIN PSSAssetDeprBook K (NOLOCK)  ON T.AssetId  = K.AssetId and T.AssetSubId  = K.AssetSubId and T.BookCode  = K.BookCode and T.BookSeq  = K.BookSeq  
WHERE T.BatNbr = 'FORECAST' 

UNION ALL

SELECT T.DrAcct, A.Descr, A.AcctType, 
AcctType_Descr = CASE WHEN (SUBSTRING(A.AcctType,2,1)) = 'A' THEN 'Assets'
                      WHEN (SUBSTRING(A.AcctType,2,1)) = 'L' THEN 'Liabilities'
                      WHEN (SUBSTRING(A.AcctType,2,1)) = 'I' THEN 'Income'
                      WHEN (SUBSTRING(A.AcctType,2,1)) = 'E' THEN 'Expenses'
                      ELSE '' END, 
T.Amt, F.CuryId, F.AssetDescr, T.AssetId, T.AssetSubId, T.BaseCuryId, T.BatNbr, T.BookCode, T.BookSeq, T.CpnyId,  T.CuryAmt, T.CuryId, T.DeprMethod, B.LedgerId, T.LineId, T.LTDDepr, T.PerPost, B.PostGL, T.DrSubAcct, U.Descr, 'DR', 
K.AccumDep, K.Basis, K.Cost, K.CuryAccumDep, K.CuryBasis, K.CuryCost, K.DeprFromPerNbr, K.LastDeprPerNbr, K.SalvageValue, K.UsefulLife 
FROM PSSFATran T
INNER JOIN Account A (NOLOCK)  ON T.DrAcct = A.Acct 
INNER JOIN SubAcct U (NOLOCK)  ON T.DrSubAcct  = U.Sub
INNER JOIN PSSFAAssets F (NOLOCK)  ON T.AssetId  = F.AssetId and T.AssetSubId  = F.AssetSubId 
INNER JOIN PSSFABookCode B (NOLOCK)  ON T.BookCode  = B.BookCode 
INNER JOIN PSSAssetDeprBook K (NOLOCK)  ON T.AssetId  = K.AssetId and T.AssetSubId  = K.AssetSubId and T.BookCode  = K.BookCode and T.BookSeq  = K.BookSeq    
WHERE T.BatNbr = 'FORECAST'
GO
