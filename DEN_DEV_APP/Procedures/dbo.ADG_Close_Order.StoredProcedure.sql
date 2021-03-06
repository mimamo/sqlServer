USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Close_Order]    Script Date: 12/21/2015 14:05:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_Close_Order]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
as
	-- Change the order status to 'C' for 'closed'.
	update	SOHeader
	set	Status = 'C'
	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr

	-- Return a status of 'DONE' from this procedure so that
	-- Order Cycle Manager knows that it should not attempt to
	-- advance to another step in the order cycle.
	select	'Status' = 'DONE',
		'Descr'  = convert(varchar(30), '')

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
