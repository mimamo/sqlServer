USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pidetail_voidrest]    Script Date: 12/21/2015 14:17:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.pidetail_voidrest    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[pidetail_voidrest] @parm1 VarChar(10) as
    update pidetail
    set pidetail.status = 'X'
    where pidetail.piid = @parm1 and pidetail.status = 'N'
GO
