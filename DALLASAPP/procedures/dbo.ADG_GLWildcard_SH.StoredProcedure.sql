USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLWildcard_SH]    Script Date: 12/21/2015 13:44:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLWildcard_SH]
	@CustID		varchar(15),
	@ShipToID	varchar(10)
as
	select		COGSAcct,
			COGSSub,
			DiscAcct,
			DiscSub,
			FrtAcct,
			FrtSub,
			S4Future11,	-- MiscAcct - remember to change the buffer element in the ADGGLWildCard
			S4Future01,	-- MiscSub - class when restoring this, the buffer element length needs
			SlsAcct,	-- to be changed back to 24 from 30
			SlsSub
	from		SOAddress (nolock)
	where		CustID = @CustID
	  and		ShipToID = @ShipToID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
