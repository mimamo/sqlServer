USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrc3]    Script Date: 12/21/2015 15:49:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SlsPrc3]

	@PriceCat varchar(2),
	@SelectFld1 varchar(30),
	@SelectFld2 varchar(30),
	@CuryID varchar(4),
	@SiteID varchar(10),
	@CatalogNbr varchar(15)
as
	select	*
	from	SlsPrc
	where	PriceCat = @PriceCat
	and	SelectFld1 = @SelectFld1
	and	SelectFld2 = @SelectFld2
	and	CuryID = @CuryID
	and	SiteID = @SiteID
	and	CatalogNbr like @CatalogNbr
	order by DiscPrcTyp, SlsPrcID
GO
