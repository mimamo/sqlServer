USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLWildcard_IT1]    Script Date: 12/21/2015 15:36:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLWildcard_IT1]
	@InvtID	varchar(30)
as
	select		DiscAcct,
			DiscSub

	from		Inventory (nolock)
	where		InvtID = @InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
