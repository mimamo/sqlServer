USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[FtrOptions_InvtID_LineNbr]    Script Date: 12/21/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FtrOptions_InvtID_LineNbr    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.FtrOptions_InvtID_LineNbr    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[FtrOptions_InvtID_LineNbr] @parm1 varchar  (  30), @parm2 varchar ( 4) , @parm3beg smallint , @parm3end smallint as
        Select * from FtrOptions, Inventory where FtrOptions.InvtID = @parm1 and
                FtrOptions.FeatureNbr = @parm2 and FtrOptions.LineNbr between @parm3beg and @parm3end
                and FtrOptions.OptInvtID = Inventory.InvtID
                order by FtrOptions.InvtID, FtrOptions.FeatureNbr, FtrOptions.LineNbr
GO
