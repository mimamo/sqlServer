USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_OrdTot_SOSched]    Script Date: 12/21/2015 16:12:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_OrdTot_SOSched]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5)
as
	select	*
	from	SOSched
	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and	LineRef = @LineRef

	order by
		SchedRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
