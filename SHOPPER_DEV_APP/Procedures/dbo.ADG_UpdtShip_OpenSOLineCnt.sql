USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_OpenSOLineCnt]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_OpenSOLineCnt]
	@CpnyID	varchar(10),
	@OrdNbr	varchar(15)
as
	select	count(*)
	from	SOLine
	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and	Status = 'O'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
