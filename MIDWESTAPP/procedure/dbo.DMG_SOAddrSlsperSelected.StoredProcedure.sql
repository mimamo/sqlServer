USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOAddrSlsperSelected]    Script Date: 12/21/2015 15:55:27 ******/
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
