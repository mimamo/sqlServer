USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLWildcard_IT2]    Script Date: 12/21/2015 14:17:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLWildcard_IT2]
	@InvtID	varchar(30)
as
	select		OMCOGSAcct,
			OMCOGSSub,
			OMSalesAcct,
			OMSalesSub

	from		InventoryADG (nolock)
	where		InvtID = @InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
