USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pidetail_close]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.pidetail_close    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[pidetail_close] @parm1 VarChar(6), @parm2 VarChar(10) as
    update pidetail set perclosed = @parm1
    where piid = @parm2
GO
