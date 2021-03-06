USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_LotSerMst_Fetch]    Script Date: 12/21/2015 14:06:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_LotSerMst_Fetch]
	@InvtID		varchar(30),
	@LotSerNbr	varchar(25),
	@SiteID		varchar(10),
	@WhseLoc	varchar(10)
as
	select	*
	from	LotSerMst
	where	InvtID = @InvtID
	and	LotSerNbr = @LotSerNbr
	and	SiteID = @SiteID
	and	WhseLoc = @WhseLoc
GO
