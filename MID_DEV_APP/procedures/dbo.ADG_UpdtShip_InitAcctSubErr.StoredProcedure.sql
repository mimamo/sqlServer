USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_InitAcctSubErr]    Script Date: 12/21/2015 14:17:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_InitAcctSubErr]
as
	select	*
	from	SOAcctSubErr
	where	ErrorAcct = ''

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
