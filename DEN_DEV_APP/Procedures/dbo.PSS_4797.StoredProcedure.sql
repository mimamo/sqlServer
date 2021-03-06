USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSS_4797]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSS_4797] 
@Year varchar(4), 
@CpnyID varchar(10),
@pcBookCode varchar(10)
 As

select 
t.assetid, 
t.assetsubid, 
dp.sect, 
a.assetdescr, 
a.acquiredate, 
max(case t.trantype    WHEN 'S'       then t.trandate else '01/01/1900'end )  as SoldDate,
Sum(CASE T.TRANTYPE    WHEN 'P'       THEN t.amt ELSE 0 END) AS Cost , 
Sum(Case left(t.perpost,4) when @year then (CASE T.TRANTYPE    WHEN 'S'       THEN t.amt ELSE 0 End) Else 0  END) AS Sale , 
Sum(Case left(t.perpost,4) when @year then 
                  CASE T.TRANTYPE    WHEN 'G'       THEN t.amt ELSE Case T.Trantype  when 'L' then T.Amt  Else 0 End  ENd
                  else 0 End)  AS GainLoss , 
SUM(Case T.DeprMethod  when 'SECT179' Then  CASE TRANTYPE WHEN 'D' THEN T.AMT ELSE 0 END Else 0 END) AS SECT179, 
SUM(Case T.DeprMethod  when 'SECT179' Then  0 else Case T.DeprMethod when 'IRS30' Then 0 else Case T.DeprMethod when 'IRS50' Then 0 Else (CASE TRANTYPE WHEN 'D' THEN T.AMT ELSE 0 End) END End End) AS DEPR, 
SUM(Case T.DeprMethod  when 'IRS30'   Then  CASE TRANTYPE WHEN 'D' THEN T.AMT Else 0 END when 'IRS50' THen CASE TRANTYPE WHEN 'D' THEN T.AMT  ELSE 0 END Else 0 END) AS BONUS, 
DP.DeprClass, 
DP.BookCode
from pssfatran T (nolock)
Join  pssfaassets A (nolock) on t.assetid = a.assetid AND t.assetsubid = a.assetsubid  
Join  PSSAssetDeprBook DP  (nolock) on t.assetid = dp.assetid AND t.assetsubid = dp.assetsubid AND t.bookcode = dp.bookcode 
join  PSSDeprMethodsHdr MH (nolock) on mh.DeprMethod = DP.DeprMethod 
where  t.bookcode = @pcBookcode
and t.disptran <> 'T'
AND (T.CpnyID = @CpnyID or @Cpnyid = '')
AND T.assetid in (Select AssetID from PSSFATRAN T2 WHERE T2.assetid = T.assetid AND t2.assetsubid = T.assetsubid AND T.bookcode = T2.bookcode  and t2.disptran <> 'T' AND left(t2.perpost,4) = @YEAR and t2.trantype = 'S')
group by t.assetid, t.assetsubid, dp.sect, a.assetdescr,dp.bookcode,  a.acquiredate,  dp.DeprClass
GO
