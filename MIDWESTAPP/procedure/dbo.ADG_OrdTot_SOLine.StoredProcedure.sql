USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_OrdTot_SOLine]    Script Date: 12/21/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_OrdTot_SOLine]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
as
	select	*
	from	SOLine
	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and	Status = 'O'

	order by
		LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
