USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventory_StkItem]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDInventory_StkItem] @InvtId varchar(30) As
Select StkItem From Inventory Where InvtId = @InvtId
GO
