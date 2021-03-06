USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LotSerMst_LotSerNbr_RMA]    Script Date: 12/21/2015 14:05:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_LotSerMst_LotSerNbr_RMA]
	@InvtID		varchar (30),
	@SiteID 	varchar (10),
	@LotSerNbr	varchar (25),
	@LotSerTrack    varchar (2)
	AS
	select 	LotSerNbr, WhseLoc, QtyOnHand
	from 	LotSerMst
	where 	InvtID like @InvtID
	and 	SiteID like @SiteID
	and 	LotSerNbr like @LotSerNbr
	and	LotSerNbr <> '*'
        and     (QtyOnHand = 0 or @LotSerTrack = 'LI')
	ORDER BY LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
