USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLWildcard_CC]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLWildcard_CC]
--	@GLClassID	varchar(4)
	@CustClass	varchar(6)
as
	select		COGSAcct,
			COGSSub,
			DiscAcct,
			DiscSub,
			FrtAcct,
			FrtSub,
			MiscAcct,
			MiscSub,
			SlsAcct,
			SlsSub
	from		CustGLClass
--	where		GLClassID = @GLClassID
	where		S4Future11 = @CustClass

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
