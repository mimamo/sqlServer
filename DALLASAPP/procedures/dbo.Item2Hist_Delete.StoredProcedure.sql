USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Item2Hist_Delete]    Script Date: 12/21/2015 13:44:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Item2Hist_Delete    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.Item2Hist_Delete    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Item2Hist_Delete] @parm1 varchar ( 30), @parm2 varchar ( 10) , @parm3 varchar ( 4) As
        Delete item2hist from Item2hist
                where  invtid = @parm1
                and siteid = @parm2
                and Fiscyr > @parm3
GO
