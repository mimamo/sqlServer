USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemHist_InvtId_FiscYr2]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemHist_InvtId_FiscYr2    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.ItemHist_InvtId_FiscYr2    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[ItemHist_InvtId_FiscYr2] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 4) as
    Select * from ItemHist
            where ItemHist.InvtId = @parm1
            and ItemHist.SiteId = @parm2
            and ItemHist.FiscYr <= @parm3
            order by ItemHist.InvtId, ItemHist.SiteId, ItemHist.FiscYr desc
GO
