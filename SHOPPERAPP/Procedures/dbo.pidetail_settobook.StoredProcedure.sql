USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pidetail_settobook]    Script Date: 12/21/2015 16:13:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.pidetail_settobook    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[pidetail_settobook] @parm1 VarChar(10) as
    update pidetail
    set pidetail.status = 'E',
    pidetail.physqty = pidetail.bookqty,
    pidetail.extcostvariance = 0
    where pidetail.piid = @parm1 and pidetail.status = 'N'
GO
