USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_LotSerMst_QtyOnHand]    Script Date: 12/21/2015 16:07:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_LotSerMst_QtyOnHand]
	@InvtID varchar(30),
	@SiteID varchar(10),
	@LotSerNbr varchar(25)
AS
	select	QtyOnHand
	from	LotSerMst
	where	InvtID like @InvtID
	and	SiteID like @SiteID
	and	LotSerNbr like @LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
