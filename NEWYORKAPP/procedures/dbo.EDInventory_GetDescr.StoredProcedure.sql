USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventory_GetDescr]    Script Date: 12/21/2015 16:01:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDInventory_GetDescr] @InvtId varchar(30) As
Select Descr From Inventory Where InvtId = @InvtId
GO
