USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SODiscCode_Descr]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SODiscCode_Descr]
	@CpnyID		varchar(10),
	@DiscountID	varchar(1)
as
	-- return the description of the passed discount id
	select	Descr
	from	SODiscCode
	where 	CpnyID = @CpnyID
	  and	DiscountID = @DiscountID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
