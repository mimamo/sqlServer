USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventory_CountActivePackNP]    Script Date: 12/21/2015 14:17:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDInventory_CountActivePackNP] @InvtId varchar(30), @Pack int As
Select Count(*) From Inventory A Inner Join InventoryADG B On A.InvtId = B.InvtId Where
A.InvtId = @InvtId And A.TranStatusCode IN ('AC','NP','OH') And (B.Pack * B.PackSize) = @Pack
GO
