USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_INTran_ShipContCode]    Script Date: 12/21/2015 16:06:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_INTran_ShipContCode]
	@InvtID		varchar(30),
	@SiteID		varchar(10),
	@WhseLoc	varchar(10),
	@LotSerNbr	varchar(25)
as
	select	ShipContCode
	from	LotSerMst
	where	InvtID = @InvtID
	  and	SiteID = @SiteID
	  and	WhseLoc = @WhseLoc
	  and	LotSerNbr = @LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
