USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventoryADG_PackPackSize]    Script Date: 12/21/2015 16:07:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDInventoryADG_PackPackSize] @Invtid varchar(30) As
Select Pack, PackSize From InventoryADG Where InvtId = @InvtId
GO
