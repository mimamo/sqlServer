USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FtrOptions_DepExcl]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FtrOptions_DepExcl    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.FtrOptions_DepExcl    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[FtrOptions_DepExcl] @parm1 varchar ( 30), @parm2 varchar ( 4), @parm3 varchar ( 30), @parm4 varchar ( 1), @parm5beg smallint, @parm5end smallint as
        Select * from OptDepExcl, CustomFtr where OptDepExcl.InvtID = @parm1 and
                OptDepExcl.FeatureNbr = @parm2 and OptDepExcl.OptInvtID = @parm3 and
            OptDepExcl.DEType = @parm4 and OptDepExcl.LineNbr between @parm5beg and @parm5end and
            OptDepExcl.InvtID = CustomFtr.InvtID and OptDepExcl.DepExclFtr = CustomFtr.FeatureNbr
                order by OptDepExcl.InvtID, OptDepExcl.FeatureNbr, OptDepExcl.OptInvtID,
                     OptDepExcl.DEType, OptDepExcl.LineNbr
GO
