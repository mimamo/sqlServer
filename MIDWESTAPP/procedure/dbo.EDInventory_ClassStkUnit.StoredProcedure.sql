USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventory_ClassStkUnit]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDInventory_ClassStkUnit] @InvtId varchar(30) As
Select ClassId,StkUnit,InvtId From Inventory Where InvtId = @InvtId
GO
