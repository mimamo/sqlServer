USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Update_ItemHist_BegBals]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Update_ItemHist_BegBals    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.Update_ItemHist_BegBals    Script Date: 4/16/98 7:41:53 PM ******/
Create Procedure [dbo].[Update_ItemHist_BegBals] @parm1 float, @parm2 float, @parm3 varchar ( 30), @parm4 varchar ( 10), @parm5 varchar ( 4) as
    UPDATE ItemHist
    SET ItemHist.BegBal = ItemHist.BegBal + @parm2
    WHERE InvtId = @parm3 and
          SiteId = @parm4 and
          ItemHist.FiscYr > @parm5

    UPDATE Item2Hist
    SET Item2Hist.BegQty = Item2Hist.BegQty + @parm1
    WHERE InvtId = @parm3 and
          SiteId = @parm4 and
          Item2Hist.FiscYr > @parm5
GO
