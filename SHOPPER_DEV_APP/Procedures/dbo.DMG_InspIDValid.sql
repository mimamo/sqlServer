USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_InspIDValid]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_InspIDValid]
	@InvtID	varchar(30),
	@InspID	varchar(2)
as
	if (
	select	count(*)
	from	Inspection (NOLOCK)
	where	InvtID = @InvtID
	and	InspID = @InspID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
