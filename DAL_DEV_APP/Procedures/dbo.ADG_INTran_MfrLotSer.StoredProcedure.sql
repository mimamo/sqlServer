USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_INTran_MfrLotSer]    Script Date: 12/21/2015 13:35:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_INTran_MfrLotSer]
	@InvtID		varchar(30),
	@SiteID		varchar(10),
	@WhseLoc	varchar(10),
	@LotSerNbr	varchar(25)
as
	select	MfgrLotSerNbr
	from	LotSerMst
	where	InvtID = @InvtID
	  and	SiteID = @SiteID
	  and	WhseLoc = @WhseLoc
	  and	LotSerNbr = @LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
