USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventory_CountActiveNP]    Script Date: 12/21/2015 14:17:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDInventory_CountActiveNP] @InvtId varchar(30) As
Select Count(*) From Inventory Where InvtId = @InvtId And TranStatusCode IN ('AC','NP','OH')
GO
