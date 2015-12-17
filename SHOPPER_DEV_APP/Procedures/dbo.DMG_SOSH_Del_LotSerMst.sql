USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOSH_Del_LotSerMst]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_SOSH_Del_LotSerMst]
	@InvtID varchar(30),
	@SiteID varchar(10),
	@LotSerNbr varchar(25) as

delete from LotSerMst where InvtID = @InvtID and SiteID = @SiteID and LotSerNbr = @LotSerNbr and Status = 'H'
GO
