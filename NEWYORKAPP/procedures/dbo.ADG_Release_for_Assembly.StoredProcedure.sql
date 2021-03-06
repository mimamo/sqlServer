USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Release_for_Assembly]    Script Date: 12/21/2015 16:00:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_Release_for_Assembly]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@ShipperID	varchar(15)
as
	declare @RequireStepAssy smallint

	-- Read the shipper record to determine whether the shipper
	-- is eligible for the workorder-related steps.
	select	@RequireStepAssy = RequireStepAssy
	from	SOShipHeader
	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID

	-- If assembly is not required, return a value of 'SKIP',
	-- meaning that the shipper should skip past the workorder-
	-- related steps in the order cycle.
	if @RequireStepAssy = 0
		select	'Status' = 'SKIP',
			'Descr'  = convert(varchar(30), '')

	-- Otherwise, return 'NEXT', meaning that the shipper should
	-- advance to the next step in the order cycle (printing the
	-- workorder).
	else
		select	'Status' = 'NEXT',
			'Descr'  = convert(varchar(30), '')

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
