USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventory_ClassId]    Script Date: 12/21/2015 14:17:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDInventory_ClassId] @InvtId varchar(30) As
Select ClassId From Inventory Where InvtId = @InvtId
GO
