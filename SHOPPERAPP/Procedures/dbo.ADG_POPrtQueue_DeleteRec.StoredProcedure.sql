USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_POPrtQueue_DeleteRec]    Script Date: 12/21/2015 16:12:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_POPrtQueue_DeleteRec]
	@ri_id		smallint,
	@cpnyid		varchar(10),
	@PONbr		varchar(15)
as
	delete 	from POprintqueue
	where 	ri_id = @ri_id
	  and	CpnyID like @cpnyid
	  and	PONbr like @PONbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
