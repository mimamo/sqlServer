USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Inventory_InvtId]    Script Date: 12/21/2015 16:07:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Inventory_InvtId    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.Inventory_InvtId    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Inventory_InvtId] @parm1 varchar ( 30) as
        Select * from Inventory where InvtId = @parm1
GO
