USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLWildcard_Error]    Script Date: 12/21/2015 14:17:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLWildcard_Error]
as
	select	ErrorAcct,
		ErrorSub
	from	SOSetup (nolock)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
