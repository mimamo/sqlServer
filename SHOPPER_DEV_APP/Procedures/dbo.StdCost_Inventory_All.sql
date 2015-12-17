USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[StdCost_Inventory_All]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[StdCost_Inventory_All]
     @parm1 varchar ( 30)
as
Select * from Inventory
     Where InvtId like @parm1
     and valmthd = 'T'
Order by InvtId
GO
