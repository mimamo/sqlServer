USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LotSerMst_LotSerNbr]    Script Date: 12/21/2015 15:49:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_LotSerMst_LotSerNbr]
	@InvtID		varchar (30),
	@SiteID 	varchar (10),
	@LotSerNbr	varchar (25)
	AS
	select 	LotSerNbr, WhseLoc, QtyOnHand
	from 	LotSerMst
	where 	InvtID like @InvtID
	and 	SiteID like @SiteID
	and 	LotSerNbr like @LotSerNbr
	and	(QtyAvail) > 0
	ORDER BY LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
