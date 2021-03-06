USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_Location_By_WhseLoc_InvtID_Exists]    Script Date: 12/21/2015 16:07:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_Location_By_WhseLoc_InvtID_Exists]
	@WhseLoc		varchar(10),
	@InvtID			varchar(30),
	@WhseLocExists		smallint OUTPUT,
	@WhseLocInvtIDExists	smallint OUTPUT
as
	-- Check whether any Location records exist that match
	-- the warehouse bin location only
	if (
	select	count(*)
	from 	Location (NOLOCK)
	where	WhseLoc = @WhseLoc
 	) = 0
		set @WhseLocExists = 0
	else
		set @WhseLocExists = -1

	-- Check whether any Location records exist that match
	-- the warehouse bin location and inventory item
	if (
	select	count(*)
	from 	Location (NOLOCK)
	where	WhseLoc = @WhseLoc
	and	InvtID = @InvtID
 	) = 0
		set @WhseLocInvtIDExists = 0
	else
		set @WhseLocInvtIDExists = -1

	--select @WhseLocExists, @WhseLocInvtIDExists

	-- Indicate success
	return 1
GO
