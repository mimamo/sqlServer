USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_SalesTaxValid]    Script Date: 12/21/2015 14:34:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_SalesTaxValid]
	@TaxID	varchar(10)
as
	if (
	select	count(*)
	from	SalesTax (NOLOCK)
	where	TaxID = @TaxID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
