USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemBMIHist_Delete]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemBMIHist_Delete    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.ItemBMIHist_Delete    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[ItemBMIHist_Delete] @parm1 varchar ( 30), @parm2 varchar ( 10) , @parm3 varchar ( 4) As
        Delete itemBMIhist from ItemBMIhist
                where  invtid = @parm1
                and siteid = @parm2
                and Fiscyr > @parm3
GO
