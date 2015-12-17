USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_OpenSOSchedCnt]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_OpenSOSchedCnt]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5)
as
	select	count(*)
	from	SOSched
	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and	LineRef = @LineRef
	  and	Status = 'O'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
