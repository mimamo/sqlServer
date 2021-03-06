USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLWildcard_CU]    Script Date: 12/21/2015 16:06:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLWildcard_CU]
	@CustID	varchar(15)
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
	from		CustomerEDI (nolock)
	where		CustID = @CustID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
