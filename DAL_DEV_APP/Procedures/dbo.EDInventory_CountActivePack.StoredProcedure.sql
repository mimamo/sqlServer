USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventory_CountActivePack]    Script Date: 12/21/2015 13:35:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDInventory_CountActivePack] @InvtId varchar(30), @Pack int As
Select Count(*) From Inventory A Inner Join InventoryADG B On A.InvtId = B.InvtId Where
A.InvtId = @InvtId And A.TranStatusCode = 'AC' And (B.Pack * B.PackSize) = @Pack
GO
