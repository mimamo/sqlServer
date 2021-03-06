USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[vi_08990sumCOGS]    Script Date: 12/21/2015 14:05:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE View [dbo].[vi_08990sumCOGS] AS
   
SELECT v.Cpnyid, v.Custid, v.Fiscyr,     
       PTDCOGS00 = SUM(CASE WHEN v.Period = '01' THEN v.COGS ELSE 0 END),
       PTDCOGS01 = SUM(CASE WHEN v.Period = '02' THEN v.COGS ELSE 0 END),
       PTDCOGS02 = SUM(CASE WHEN v.Period = '03' THEN v.COGS ELSE 0 END),
       PTDCOGS03 = SUM(CASE WHEN v.Period = '04' THEN v.COGS ELSE 0 END),
       PTDCOGS04 = SUM(CASE WHEN v.Period = '05' THEN v.COGS ELSE 0 END),
       PTDCOGS05 = SUM(CASE WHEN v.Period = '06' THEN v.COGS ELSE 0 END),
       PTDCOGS06 = SUM(CASE WHEN v.Period = '07' THEN v.COGS ELSE 0 END),
       PTDCOGS07 = SUM(CASE WHEN v.Period = '08' THEN v.COGS ELSE 0 END),
       PTDCOGS08 = SUM(CASE WHEN v.Period = '09' THEN v.COGS ELSE 0 END),
       PTDCOGS09 = SUM(CASE WHEN v.Period = '10' THEN v.COGS ELSE 0 END),
       PTDCOGS10 = SUM(CASE WHEN v.Period = '11' THEN v.COGS ELSE 0 END),
       PTDCOGS11 = SUM(CASE WHEN v.Period = '12' THEN v.COGS ELSE 0 END),
       PTDCOGS12 = SUM(CASE WHEN v.Period = '13' THEN v.COGS ELSE 0 END),
       YTDCOGS = SUM(v.COGS)
  FROM vi_08990COGS v
GROUP BY v.cpnyid,v.custid,v.fiscyr
GO
