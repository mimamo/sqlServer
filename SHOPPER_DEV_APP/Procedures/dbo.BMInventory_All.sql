USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMInventory_All]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- 11250
-- bkb 6/29/99
Create Proc [dbo].[BMInventory_All] @InvtID varchar ( 30) as
        Select * from Inventory where
		InvtID like @InvtID
		order by InvtID
GO
