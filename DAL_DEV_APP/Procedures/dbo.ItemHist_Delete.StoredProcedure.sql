USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemHist_Delete]    Script Date: 12/21/2015 13:35:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemHist_Delete    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.ItemHist_Delete    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[ItemHist_Delete] @parm1 varchar ( 30), @parm2 varchar ( 10) , @parm3 varchar ( 4) As
        Delete itemhist from Itemhist
                where  invtid = @parm1
                and siteid = @parm2
                and Fiscyr > @parm3
GO
