USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Release_for_Update]    Script Date: 12/21/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_Release_for_Update]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@ShipperID	varchar(15)
as
	-- Queue the shipper to be updated.
	exec ADG_ProcessMgr_QueueUpdSh @CpnyID, @ShipperID

	-- Return 'NEXT', meaning that the shipper should advance to
	-- the next step in the order cycle (the shipper update).
	select	'Status' = 'NEXT',
		'Descr'  = convert(varchar(30), '')

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
