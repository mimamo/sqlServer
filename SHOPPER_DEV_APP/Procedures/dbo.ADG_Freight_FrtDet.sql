USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Freight_FrtDet]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Freight_FrtDet]
	@FrtTermsID	varchar(10),
	@OrderVal	float
as
	select	FreightPct,
		HandlingChg,
		HandlingChgLine,
		InvcAmtPct

	from	FrtTermDet
	where	FrtTermsID = @FrtTermsID
	  and	MinOrderVal <= @OrderVal

	order by
		MinOrderVal desc

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
