USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemBMIHist_InvtId_FiscYr2]    Script Date: 12/21/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemBMIHist_InvtId_FiscYr2    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.ItemBMIHist_InvtId_FiscYr2    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[ItemBMIHist_InvtId_FiscYr2] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 4) as
    Select * from ItemBMIHist
            where InvtId = @parm1
            and SiteId = @parm2
            and FiscYr <= @parm3
            order by InvtId, SiteId, FiscYr desc
GO
