USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemHist_InvtId_FiscYr1_BMI]    Script Date: 12/21/2015 15:49:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemHist_InvtId_FiscYr1_BMI    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.ItemHist_InvtId_FiscYr1_BMI Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[ItemHist_InvtId_FiscYr1_BMI] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 4) as
    Select * from ItemBMIHist
            where ItemBMIHist.InvtId = @parm1
            and ItemBMIHist.SiteId = @parm2
            and ItemBMIHist.FiscYr >= @parm3
            order by ItemBMIHist.InvtId, ItemBMIHist.SiteId, ItemBMIHist.FiscYr
GO
