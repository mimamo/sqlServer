USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_OrdNbr_AddrOther]    Script Date: 12/21/2015 14:17:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_OrdNbr_AddrOther]
	@CpnyID varchar(10),
	@OrdNbr varchar(15),
	@AddrID varchar(10)
AS
	select	distinct Address.*
	from	Address
	join	SOSched ON SOSched.ShipAddrID = Address.AddrID
	where	SOSched.CpnyID = @CpnyID
	and	SOSched.OrdNbr = @OrdNbr
	and	Address.AddrID like @AddrID
	order by Address.AddrID
GO
