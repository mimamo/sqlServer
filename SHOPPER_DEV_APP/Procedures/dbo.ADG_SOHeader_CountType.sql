USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOHeader_CountType]    Script Date: 12/16/2015 15:55:11 ******/
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
