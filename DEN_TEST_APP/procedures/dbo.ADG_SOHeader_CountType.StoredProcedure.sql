USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOHeader_CountType]    Script Date: 12/21/2015 15:36:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOHeader_CountType]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4),
	@Status		varchar(1)
as
	select	'Records' = convert(int, count(*))
	from	SOHeader
	where	CpnyID = @CpnyID
	  and	SOTypeID = @SOTypeID
	  and	Status = @Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
