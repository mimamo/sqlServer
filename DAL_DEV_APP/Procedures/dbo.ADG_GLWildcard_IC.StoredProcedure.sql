USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLWildcard_IC]    Script Date: 12/21/2015 13:35:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLWildcard_IC]
	@GLClassID	varchar(4)
as
	select		COGSAcct,
			COGSSub,
			DiscAcct,
			DiscSub,
			SlsAcct,
			SlsSub
	from		ItemGLClass (nolock)
	where		GLClassID = @GLClassID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
