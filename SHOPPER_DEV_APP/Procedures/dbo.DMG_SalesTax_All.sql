USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SalesTax_All]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_SalesTax_All]

	@TaxID varchar(10)
as
	select	*
	from	SalesTax
	where	TaxID like @TaxID
	and	TaxType in ('G','T')
	order by TaxID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
