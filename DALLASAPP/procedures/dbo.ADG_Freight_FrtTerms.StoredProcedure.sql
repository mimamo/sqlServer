USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Freight_FrtTerms]    Script Date: 12/21/2015 13:44:42 ******/
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
