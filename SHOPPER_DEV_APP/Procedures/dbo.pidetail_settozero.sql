USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pidetail_settozero]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.pidetail_settozero    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[pidetail_settozero] @parm1 VarChar(10) as
    update pidetail
    set pidetail.status = 'E', pidetail.physqty = 0
    where pidetail.piid = @parm1 and pidetail.status = 'N'
GO
