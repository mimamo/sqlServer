USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SlsPrc_CatalogNbr_PV]    Script Date: 12/21/2015 16:13:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_SlsPrc_CatalogNbr_PV]

	@CuryID		varchar(4),
	@CatalogNbr	varchar(15)
as
	select	distinct CatalogNbr
	from	SlsPrc
	where	CuryID = @CuryID
	and	CatalogNbr like @CatalogNbr
	and	CatalogNbr <> ''
	order by CatalogNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
