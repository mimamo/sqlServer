USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Inventory_All_RO]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Inventory_All_RO] @InvtID varchar ( 30) as
        Select * from Inventory (NoLock) where InvtId like @InvtID order by InvtID
GO
