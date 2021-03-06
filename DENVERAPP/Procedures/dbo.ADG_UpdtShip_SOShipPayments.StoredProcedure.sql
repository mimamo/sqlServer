USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_SOShipPayments]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_SOShipPayments]
	@ShipRegisterID varchar(10)
as
	select	SP.CardNbr,
		PM.CashAcct,
		PM.CashSub,
		SP.CpnyID,
		SP.ChkNbr,
		SP.CuryPmtAmt,
		SH.CuryID,
		SP.NoteID,
		SH.PerPost,
		SP.PmtAmt,
		SP.PmtRef,
		SP.PmtTypeID,
		SP.S4Future01,
		SP.S4Future12,
		SP.ShipperID,
		PM.ValidationType,
        SP.PmtDate

	from	SOShipPayments SP
	join	SOShipHeader SH
	  on	SH.CpnyID = SP.CpnyID
	  and	SH.ShipperID = SP.ShipperID
	join	PmtType PM
	  on	PM.CpnyID = SP.CpnyID
	  and	PM.PmtTypeID = SP.PmtTypeID
	where	SP.S4Future11 = @ShipRegisterID
	Order by SP.CpnyID, SH.CuryID, SH.PerPost, PM.CashAcct, PM.CashSub, SP.ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
