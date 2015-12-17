USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_InvtIDValid]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_InvtIDValid]
	@InvtID	varchar(30)
as
	declare	@Count smallint

	select	@Count = count(*)
		from	Inventory (NOLOCK)
		where	InvtID = @InvtID

	--select @Count

	if @Count = 0
		return 0	--Failure
	else
		return 1	--Success
GO
