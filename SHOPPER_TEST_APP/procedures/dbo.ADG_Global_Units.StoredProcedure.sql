USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Global_Units]    Script Date: 12/21/2015 16:06:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_Global_Units]

	@ToUnit varchar (6)
as
	select	distinct ToUnit
	from	INUnit
	where	UnitType = '1'
	and	ToUnit like @ToUnit
	order by ToUnit

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
