USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Inventory_All]    Script Date: 12/21/2015 16:13:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Inventory_All    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.Inventory_All    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[Inventory_All] @parm1 varchar ( 30) as
    Select * from Inventory where InvtId like @parm1 order by InvtId
GO
