USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Inventory_CPSOn]    Script Date: 12/21/2015 13:35:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Inventory_CPSOn]
AS
	select	CPSOnOff
	from	INSetUp (NoLock)
GO
