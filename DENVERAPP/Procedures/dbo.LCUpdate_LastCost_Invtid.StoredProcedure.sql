USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LCUpdate_LastCost_Invtid]    Script Date: 12/21/2015 15:42:58 ******/
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
