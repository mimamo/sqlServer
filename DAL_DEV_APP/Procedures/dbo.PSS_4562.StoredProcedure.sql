USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSS_4562]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSS_4562] 
@Year varchar(4), 
@CpnyID varchar(10) ,
@pcBookCode varchar(10)

As

--exec  [PSS_4562] '2011', '008', 'TAX'
select 
t.assetid, 
t.assetsubid, 
a.assetdescr, 
0.00 as cost , 
SUM(Case T.DeprMethod  when 'SECT179' Then  (CASE TRANTYPE WHEN 'D' THEN T.AMT ELSE 0 END) Else 0 END) AS SECT179, 
SUM(Case T.DeprMethod  when 'SECT179' Then 0 when DP.bonusdeprcd Then  0 else (CASE TRANTYPE WHEN 'D' THEN T.AMT ELSE 0 End) END) AS DEPR, 
SUM(Case T.DeprMethod  when DP.bonusdeprcd Then  (CASE TRANTYPE WHEN 'D' THEN T.AMT ELSE 0 END) Else 0 END) AS BONUS,
DP.UsefulLife,
DP.DeprClass,
DP.DeprFromPerNbr,
convert(char(20), DP.DeprMethod),
convert(char(10), Case DP.DeprMethod When  'SL' THen DP.MMTYPE else MH.Midconvention End) MidConv,
A.Acquiredate
from pssfatran T (nolock)
Join  pssfaassets A (nolock) on t.assetid = a.assetid AND t.assetsubid = a.assetsubid  
Join  PSSAssetDeprBook DP  (nolock) on t.assetid = dp.assetid AND t.assetsubid = dp.assetsubid AND t.bookcode = dp.bookcode 
join  PSSDeprMethodsHdr MH (nolock) on mh.DeprMethod = DP.DeprMethod 
where  t.disptran <> 'T'
and t.bookcode = @pcBookCode
AND left(T.perpost,4) = @YEAR
AND (T.trantype = 'D')
AND (T.CpnyID = @CpnyID or @CPnyid = '')
group by a.acquiredate, DP.DeprFromPerNbr, Dp.DeprClass, dp.deprmethod, t.assetid, t.assetsubid, a.assetdescr, dp.usefullife,  Case DP.DeprMethod When  'SL' THen DP.MMTYPE else MH.Midconvention End 
union 

select 
DP.assetid, 
DP.assetsubid, 
a.assetdescr, 
sum(amt) as COst,
0.00 AS SECT179, 
0.00 AS DEPR, 
0.00 AS BONUS,
DP.UsefulLife,
DP.DeprClass,
DP.DeprFromPerNbr,
convert(char(20), DP.DeprMethod),
convert(char(10), Case DP.DeprMethod When  'SL' THen DP.MMTYPE else MH.Midconvention End) MidConv,
A.Acquiredate
from pssfatran T (nolock)
Join  pssfaassets A (nolock) on t.assetid = a.assetid AND t.assetsubid = a.assetsubid  
Join  PSSAssetDeprBook DP  (nolock) on t.assetid = dp.assetid AND t.assetsubid = dp.assetsubid AND t.bookcode = dp.bookcode 
join  PSSDeprMethodsHdr MH (nolock) on mh.DeprMethod = DP.DeprMethod 
where  t.disptran <> 'T'
and t.bookcode = @pcBookCode
AND left(DP.DeprFromPerNbr,4) = @YEAR
AND (T.trantype = 'P')
AND (T.CpnyID = @CpnyID or @CPnyid = '')
group by a.acquiredate, DP.DeprFromPerNbr, Dp.DeprClass, dp.deprmethod, DP.assetid, DP.assetsubid, a.assetdescr, dp.usefullife,  Case DP.DeprMethod When  'SL' THen DP.MMTYPE else MH.Midconvention End
GO
