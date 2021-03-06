USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[FtrOptions_OptInvtID]    Script Date: 12/21/2015 16:07:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FtrOptions_OptInvtID    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.FtrOptions_OptInvtID    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[FtrOptions_OptInvtID] @parm1 varchar  (  30), @parm2 varchar ( 4), @parm3 varchar ( 30) as
        Select * from FtrOptions where InvtID = @parm1 and
                FeatureNbr = @parm2 and OptInvtID LIKE @parm3
                order by InvtID, FeatureNbr, OptInvtID
GO
