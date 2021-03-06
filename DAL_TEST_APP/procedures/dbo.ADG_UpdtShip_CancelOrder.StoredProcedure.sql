USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_CancelOrder]    Script Date: 12/21/2015 13:56:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_CancelOrder]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
as

	update	SOLot
	set	Status = 'C',
		LUpd_DateTime = GetDate(),
		LUpd_Prog = 'SQL40400',
		LUpd_User = 'SQL40400'

	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and	Status <> 'C'

	update	SOSched
	set	Status = 'C',
		LUpd_DateTime = GetDate(),
		LUpd_Prog = 'SQL40400',
		LUpd_User = 'SQL40400'

	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and	Status <> 'C'

	update	SOLine
	set	Status = 'C',
		LUpd_DateTime = GetDate(),
		LUpd_Prog = 'SQL40400',
		LUpd_User = 'SQL40400'

	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and	Status <> 'C'

	update	SOHeader
	set	Status = 'C',
		LUpd_DateTime = GetDate(),
		LUpd_Prog = 'SQL40400',
		LUpd_User = 'SQL40400',
		NextFunctionID = '',
		NextFunctionClass = '',
		CuryUnshippedBalance = 0,
		UnshippedBalance = 0

	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and	Status <> 'C'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
