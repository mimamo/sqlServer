USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_INTran_InitAssyDoc]    Script Date: 12/21/2015 14:05:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_INTran_InitAssyDoc]
as
	select	*
	from	AssyDoc
	where	KitID = ''
	  and	RefNbr = ''
	  and	BatNbr = 'Z'
	  and	CpnyID = ''

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
