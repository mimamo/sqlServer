USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOHeader_Count]    Script Date: 12/21/2015 15:36:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOHeader_Count]
	@CpnyID	varchar(10),
	@OrdNbr	varchar(15)
as
	select	count(*)
	from	SOHeader
	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
