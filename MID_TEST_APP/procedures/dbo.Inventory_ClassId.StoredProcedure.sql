USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Inventory_ClassId]    Script Date: 12/21/2015 15:49:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Inventory_ClassId    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.Inventory_ClassId    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[Inventory_ClassId] @parm1 varchar ( 6) as
    Select * from Inventory where ClassId = @parm1 order by InvtId
GO
