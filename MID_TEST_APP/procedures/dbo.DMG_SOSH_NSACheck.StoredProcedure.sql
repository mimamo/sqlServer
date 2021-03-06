USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOSH_NSACheck]    Script Date: 12/21/2015 15:49:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_SOSH_NSACheck]
	@InvtID varchar(30),
	@SiteID varchar(10),
	@LotSerNbr varchar(25)
as

select convert(smallint, case

        when exists (

    	select * from LotSerMst lsm, LocTable lct
    	where lct.SiteID = lsm.SiteID and lct.WhseLoc = lsm.WhseLoc
        and lsm.InvtID = @InvtID and lsm.SiteID = @SiteID and lsm.LotSerNbr = @LotSerNbr
        and lct.SalesValid = 'N' and lsm.Status = 'A')

        and not exists (
    	select * from LotSerMst lsm, LocTable lct
    	where lct.SiteID = lsm.SiteID and lct.WhseLoc = lsm.WhseLoc
        and lsm.InvtID = @InvtID and lsm.SiteID = @SiteID and lsm.LotSerNbr = @LotSerNbr
        and lct.SalesValid <> 'N' and lsm.Status = 'A')
  	then 15577
	else 0 end)
GO
