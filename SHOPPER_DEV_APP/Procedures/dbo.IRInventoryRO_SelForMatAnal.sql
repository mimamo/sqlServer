USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRInventoryRO_SelForMatAnal]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[IRInventoryRO_SelForMatAnal] AS
if not exists (select * from sysobjects where id = object_id(N'[dbo].[IRCEPRestrict]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Select * from Inventory order by InvtID
Else
	If (select count(*) from IRCepRestrict) > 0
		Select * from Inventory where exists (Select * from IRCepRestrict where IRCepRestrict.InvtId = Inventory.InvtId) order by InvtID
	Else
		Select * from Inventory order by InvtID

-- InventoryRO_SelForMatAnal
GO
