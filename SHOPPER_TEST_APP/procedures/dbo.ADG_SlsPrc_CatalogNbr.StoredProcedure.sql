USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrc_CatalogNbr]    Script Date: 12/21/2015 16:06:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SlsPrc_CatalogNbr]

	@CuryID		varchar(4),
	@CatalogNbr 	varchar(15)
as
	select	*
	from	SlsPrc
	where	CuryID = @CuryID
	and	CatalogNbr like @CatalogNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
