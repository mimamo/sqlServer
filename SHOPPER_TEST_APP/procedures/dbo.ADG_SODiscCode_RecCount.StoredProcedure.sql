USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SODiscCode_RecCount]    Script Date: 12/21/2015 16:06:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SODiscCode_RecCount]
	@CpnyID		varchar(10),
	@DiscountID	varchar(1)
as

	-- return the count of the records that match the discount id
	select	count(*)
	from	SODiscCode
	where 	CpnyID = @CpnyID
	  and	DiscountID = @DiscountID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
