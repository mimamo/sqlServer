USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ARDoc_InitARDoc]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ARDoc_InitARDoc]
as
	select	*
	from	ARDoc
	where	CustID = 'Z'
	  and	DocType = 'Z'
	  and	RefNbr = 'Z'
	  and	BatNbr = 'Z'
	  and	BatSeq = -1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
