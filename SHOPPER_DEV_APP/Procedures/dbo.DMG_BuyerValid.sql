USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_BuyerValid]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_BuyerValid]
	@Buyer	varchar(10)
as
	if (
	select	count(*)
	from	SIBuyer (NOLOCK)
	where	Buyer = @Buyer
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
