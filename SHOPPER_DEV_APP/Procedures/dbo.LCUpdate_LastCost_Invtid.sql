USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCUpdate_LastCost_Invtid]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[LCUpdate_LastCost_Invtid]
	@InvtID varchar (30),
	@NewCost float
as
UPdate Inventory
	Set LastCost = @NewCost
Where
	Invtid = @InvtID
GO
