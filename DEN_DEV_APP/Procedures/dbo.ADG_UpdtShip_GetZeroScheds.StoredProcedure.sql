USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_GetZeroScheds]    Script Date: 12/21/2015 14:05:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_GetZeroScheds]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@TodaysDate	smalldatetime
as
	select	LineRef,
		SchedRef,
		QtyOrd

	from	SOSched
	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and	Status <> 'C'
	  and	(QtyOrd = 0 or CancelDate <= @TodaysDate and @TodaysDate <> '')

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
