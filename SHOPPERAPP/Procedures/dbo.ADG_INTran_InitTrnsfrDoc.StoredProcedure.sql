USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_INTran_InitTrnsfrDoc]    Script Date: 12/21/2015 16:12:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_INTran_InitTrnsfrDoc]
as
	select	*
	from	TrnsfrDoc
	where	CpnyID = ''
	  and	TrnsfrDocNbr = 'Z'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
