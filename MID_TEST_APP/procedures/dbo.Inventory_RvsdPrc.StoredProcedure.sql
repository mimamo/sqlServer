USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Inventory_RvsdPrc]    Script Date: 12/21/2015 15:49:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Inventory_RvsdPrc    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.Inventory_RvsdPrc    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Inventory_RvsdPrc] @parm1 varchar ( 30) as
    Select * from Inventory where RvsdPrc = 1 and
        InvtId like @parm1
        order by InvtId, RvsdPrc
GO
