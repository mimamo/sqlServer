USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SODiscCode_Descr]    Script Date: 12/21/2015 13:44:43 ******/
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
