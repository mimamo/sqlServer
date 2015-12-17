USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Freight_FrtTerms]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Freight_FrtTerms]
	@FrtTermsID	varchar(10)
as
	select	Collect
	from	FrtTerms
	where	FrtTermsID = @FrtTermsID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
