USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Inventory_All_RO]    Script Date: 12/21/2015 16:13:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Inventory_All_RO] @InvtID varchar ( 30) as
        Select * from Inventory (NoLock) where InvtId like @InvtID order by InvtID
GO
