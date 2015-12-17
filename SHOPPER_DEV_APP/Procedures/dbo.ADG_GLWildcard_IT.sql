USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLWildcard_IT]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLWildcard_IT]
	@InvtID	varchar(30)
as
	select		COGSAcct,
			COGSSub,
			DiscAcct,
			DiscSub,
			DfltSalesAcct,
			DfltSalesSub
	from		Inventory (nolock)
	where		InvtID = @InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
