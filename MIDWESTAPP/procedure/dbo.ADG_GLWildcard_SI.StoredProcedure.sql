USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLWildcard_SI]    Script Date: 12/21/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLWildcard_SI]
	@SiteID	varchar(10)
as
	select		COGSAcct,
			COGSSub,
			DicsAcct,
			DiscSub,
			FrtAcct,
			FrtSub,
			S4Future11,	-- MiscAcct - remember to change the buffer element in the ADGGLWildCard
			S4Future01,	-- MiscSub - class when restoring this, the buffer element length needs
			SlsAcct,	-- to be changed back to 24 from 30
			SlsSub
	from		Site (nolock)
	where		SiteID = @SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
