USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Release_for_Inspection]    Script Date: 12/21/2015 15:49:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_Release_for_Inspection]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@ShipperID	varchar(15)
as
	declare @RequireStepInsp smallint

	-- Read the shipper record to determine whether the shipper
	-- is eligible for the inspection-related steps.
	select	@RequireStepInsp = RequireStepInsp
	from	SOShipHeader
	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID

	-- If inspection is not required, return a value of 'SKIP',
	-- meaning that the shipper should skip past the inspection-
	-- related steps in the order cycle.
	if @RequireStepInsp = 0
		select	'Status' = 'SKIP',
			'Descr'  = convert(varchar(30), '')

	-- Otherwise, return 'NEXT', meaning that the shipper should
	-- advance to the next step in the order cycle (printing the
	-- inspection order).
	else
		select	'Status' = 'NEXT',
			'Descr'  = convert(varchar(30), '')

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
