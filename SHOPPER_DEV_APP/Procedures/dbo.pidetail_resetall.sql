USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pidetail_resetall]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.pidetail_resetall    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[pidetail_resetall] @parm1 VarChar(10) as
    update pidetail
    set pidetail.status = 'N', pidetail.physqty = 0, pidetail.extcostvariance = 0, pidetail.s4future03 = 0
    where pidetail.piid = @parm1

    Delete pidetcost
    where pidetcost.piid = @parm1
GO
