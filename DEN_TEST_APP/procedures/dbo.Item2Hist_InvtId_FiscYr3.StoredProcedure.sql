USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Item2Hist_InvtId_FiscYr3]    Script Date: 12/21/2015 15:36:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Item2Hist_InvtId_FiscYr3    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.Item2Hist_InvtId_FiscYr3    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Item2Hist_InvtId_FiscYr3] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 4) as
    Select * from Item2Hist
            where Item2Hist.InvtId = @parm1
            and Item2Hist.SiteId = @parm2
            and Item2Hist.FiscYr < @parm3
            order by Item2Hist.InvtId, Item2Hist.SiteId, Item2Hist.FiscYr desc
GO
