USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventoryADG_PackPackSize]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDInventoryADG_PackPackSize] @Invtid varchar(30) As
Select Pack, PackSize From InventoryADG Where InvtId = @InvtId
GO
