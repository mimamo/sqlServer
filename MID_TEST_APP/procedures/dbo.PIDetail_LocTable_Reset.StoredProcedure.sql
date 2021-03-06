USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIDetail_LocTable_Reset]    Script Date: 12/21/2015 15:49:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PIDetail_LocTable_Reset    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[PIDetail_LocTable_Reset] @parm1 VarChar(10) as
    Update loctable set loctable.countstatus = 'A'
    from loctable, pidetail
    where pidetail.piid = @parm1
    and loctable.countstatus = 'P'
    and loctable.siteid = pidetail.siteid
    and loctable.whseloc = pidetail.whseloc
GO
