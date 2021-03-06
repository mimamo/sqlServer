USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_OpenSchedCnt]    Script Date: 12/21/2015 16:00:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_OpenSchedCnt]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
as
	select	count(*)
	from	SOSched
	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and	Status = 'O'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
