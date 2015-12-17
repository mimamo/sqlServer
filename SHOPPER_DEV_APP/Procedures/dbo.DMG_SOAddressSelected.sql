USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOAddressSelected]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_SOAddressSelected]
	@CustID		varchar(15),
	@ShipToID	varchar(10),
	@SiteID		varchar(10) OUTPUT
as
	select	@SiteID = ltrim(rtrim(SiteID))
	from	SOAddress (NOLOCK)
	where	CustID = @CustID
	and	ShipToID = @ShipToID

	if @@ROWCOUNT = 0 begin
		set @SiteID = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
