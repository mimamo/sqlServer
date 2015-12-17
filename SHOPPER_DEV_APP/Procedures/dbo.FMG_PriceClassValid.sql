USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_PriceClassValid]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_PriceClassValid]
	@PriceClassType	varchar(1),
	@PriceClassID	varchar(6)
as
	if (
	select	count(*)
	from	PriceClass (NOLOCK)
	where	PriceClassType = @PriceClassType
	and	PriceClassID = @PriceClassID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
