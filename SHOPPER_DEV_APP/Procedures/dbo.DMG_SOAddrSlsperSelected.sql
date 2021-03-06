USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOAddrSlsperSelected]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_SOAddrSlsperSelected]
	@CustID		varchar(15),
	@ShipToID	varchar(10)
as
	select	ltrim(rtrim(SlsperID)) SlsPerID,
		CreditPct
	from	SOAddrSlsper (NOLOCK)
	where	CustID = @CustID
	and	ShipToID = @ShipToID
GO
