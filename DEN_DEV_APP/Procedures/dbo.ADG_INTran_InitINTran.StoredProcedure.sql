USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_INTran_InitINTran]    Script Date: 12/21/2015 14:05:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_INTran_InitINTran]
as
	select	*
	from	INTran
	where	BatNbr = 'Z'
	  and	InvtID = ''
	  and	SiteID = ''
	  and	WhseLoc = ''
	  and	RefNbr = ''

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
