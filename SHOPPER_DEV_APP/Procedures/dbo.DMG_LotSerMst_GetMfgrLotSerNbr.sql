USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_LotSerMst_GetMfgrLotSerNbr]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_LotSerMst_GetMfgrLotSerNbr]
	@InvtID 	varchar(30),
	@LotSerNbr	varchar(25),
	@SiteID		varchar(10),
	@WhseLoc	varchar(15),
	@MfgrLotSerNbr	varchar(25) OUTPUT

as

	select @MfgrLotSerNbr = ltrim(rtrim(MfgrLotSerNbr))
	from LotSerMst (nolock)
	where 	InvtID = @InvtID
		and LotSerNbr = @LotSerNbr
		and SiteID = @SiteID
		and WhseLoc = @WhseLoc

	if @@ROWCOUNT = 0 begin
		set @MfgrLotSerNbr = ''
		return 0	--Failure
	end
	else
		--select @MfgrLotSerNbr
		return 1	--Success
GO
