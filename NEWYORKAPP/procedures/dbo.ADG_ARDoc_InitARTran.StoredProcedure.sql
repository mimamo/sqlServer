USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ARDoc_InitARTran]    Script Date: 12/21/2015 16:00:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ARDoc_InitARTran]
as
	select	*
	from	ARTran
	where	CustID = 'Z'
	  and	TranType = 'Z'
	  and	RefNbr = 'Z'
	  and	LineNbr = -1
	  and	RecordID = -1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
