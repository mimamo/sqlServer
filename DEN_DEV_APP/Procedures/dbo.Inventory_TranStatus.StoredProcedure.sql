USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Inventory_TranStatus]    Script Date: 12/21/2015 14:06:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Inventory_TranStatus    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.Inventory_TranStatus    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Inventory_TranStatus] @parm1 varchar ( 2) as
    Select * from Inventory where TranStatusCode = @parm1
    order by InvtId
GO
