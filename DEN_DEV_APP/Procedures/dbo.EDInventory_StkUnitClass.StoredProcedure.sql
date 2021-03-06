USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventory_StkUnitClass]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDInventory_StkUnitClass] @InvtId varchar(30) As
Select A.StkUnit,A.ClassId,B.PackMethod,B.Pack, B.PackSize, Cast (B.PackUOM As char(6)),B.StdCartonBreak
From Inventory A, InventoryADG B Where A.InvtId = @InvtId And A.InvtId = B.InvtId
GO
