USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_TaxIDIsGroup]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_TaxIDIsGroup]
	@TaxID	varchar(10)
as
	if (
	select	count(*)
	from	SalesTax (NOLOCK)
	where	TaxID = @TaxID
	and	TaxType = 'G'
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
