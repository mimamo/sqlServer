USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SONoShip_Delete]    Script Date: 12/21/2015 16:00:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SONoShip_Delete]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
as
	delete	from SONoShip
	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
