USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrc2]    Script Date: 12/21/2015 16:00:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SlsPrc2]

	@CuryID		varchar(4),
	@SlsPrcID	varchar(15)
as
	select	*
	from	SlsPrc
	where	CuryID = @CuryID
	and	SlsPrcID like @SlsPrcID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
