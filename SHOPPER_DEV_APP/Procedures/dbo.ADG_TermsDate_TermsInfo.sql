USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_TermsDate_TermsInfo]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_TermsDate_TermsInfo]
	@TermsID	varchar(2)
as
	select	DiscIntrv,
		DiscPct,
		DiscType,
		DueIntrv,
		DueType
	from	Terms
	where	TermsID = @TermsID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
