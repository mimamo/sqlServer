USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_OrdNbr_AddrCustAddress]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_OrdNbr_AddrCustAddress]
	@CpnyID varchar(10),
	@OrdNbr varchar(15),
	@CustID varchar(15),
	@ShipToID varchar(10)
AS
	select	distinct SOAddress.*
	from	SOAddress
	join	SOSched ON SOSched.ShipToID = SOAddress.ShipToID and SOSched.ShipCustID = SOAddress.CustID
	where	SOSched.CpnyID = @CpnyID
	and	SOSched.OrdNbr = @OrdNbr
	and	SOAddress.CustID = @CustID
	and	SOAddress.ShipToID like @ShipToID
	order by SOAddress.CustID, SOAddress.ShipToID
GO
