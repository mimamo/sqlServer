USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Inventory_CPSOn]    Script Date: 12/21/2015 14:06:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Inventory_CPSOn]
AS
	select	CPSOnOff
	from	INSetUp (NoLock)
GO
