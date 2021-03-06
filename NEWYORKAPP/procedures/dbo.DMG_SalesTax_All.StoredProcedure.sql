USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SalesTax_All]    Script Date: 12/21/2015 16:00:55 ******/
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
