USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[p08990UpdARHistYtd]    Script Date: 12/21/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[p08990UpdARHistYtd] AS

UPDATE h SET YTDAccruedRev = v.YTDAccruedRev, YtdCrMemo = v.YtdCrMemo, h.YtdRcpt = v.YtdRcpt, h.YtdDisc = v.YtdDisc,
             YtdDrMemo = v.YtdDrMemo,YtdSales = v.YtdSales, YtdFinChrg = v.YtdFinChrg,
             YtdCOGS = v.YtdCOGS
    FROM ARHist h, vi_08990SumPtdFields v
   WHERE h.custid = v.custid AND h.cpnyid = v.cpnyid AND h.FiscYr = v.FiscYr
GO
