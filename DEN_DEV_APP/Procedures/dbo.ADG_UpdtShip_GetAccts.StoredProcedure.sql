USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_GetAccts]    Script Date: 12/21/2015 14:05:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_GetAccts]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
as
	select	ARAcct,
		ARSub,
		COGSAcct,
		COGSSub,
		DiscAcct,
		DiscSub,
		FrtAcct,
		FrtSub,
		InvAcct,
		InvSub,
		MiscAcct,
		MiscSub,
		SlsAcct,
		SlsSub,
		WholeOrdDiscAcct,
		WholeOrdDiscSub

	from	SOType
	where	CpnyID = @CpnyID
	  and	SOTypeID = @SOTypeID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
