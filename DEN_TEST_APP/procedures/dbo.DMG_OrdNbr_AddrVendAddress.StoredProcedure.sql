USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_OrdNbr_AddrVendAddress]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_OrdNbr_AddrVendAddress]
	@CpnyID varchar(10),
	@OrdNbr varchar(15),
	@VendID varchar(15),
	@OrdFromID varchar(10)
AS
	select	distinct POAddress.*
	from	POAddress
	join	SOSched ON SOSched.S4Future11 = POAddress.OrdFromID and SOSched.ShipVendID = POAddress.VendID
	where	SOSched.CpnyID = @CpnyID
	and	SOSched.OrdNbr = @OrdNbr
	and	POAddress.VendID = @VendID
	and	POAddress.OrdFromID like @OrdFromID
	order by POAddress.VendID, POAddress.OrdFromID
GO
