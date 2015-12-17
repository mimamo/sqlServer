USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLWildcard_SV]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLWildcard_SV]
	@CpnyID		varchar(10),
	@ShipViaID	varchar(15)
as
	select		FrtAcct,
			FrtSub
	from		ShipVia (nolock)
	where		CpnyID = @CpnyID
	  and		ShipViaID = @ShipViaID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
