USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FtrOptions_LineNbr]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FtrOptions_LineNbr    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.FtrOptions_LineNbr    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[FtrOptions_LineNbr] @parm1 varchar  (  30), @parm2 varchar ( 4) , @parm3beg smallint , @parm3end smallint as
        Select * from FtrOptions where InvtID = @parm1 and
                FeatureNbr = @parm2 and LineNbr between @parm3beg and @parm3end
                order by InvtID, FeatureNbr, LineNbr
GO
