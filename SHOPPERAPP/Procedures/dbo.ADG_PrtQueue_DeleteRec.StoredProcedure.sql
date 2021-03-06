USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_PrtQueue_DeleteRec]    Script Date: 12/21/2015 16:13:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_PrtQueue_DeleteRec]
	@ri_id		smallint,
	@cpnyid		varchar(10),
	@ordnbr		varchar(15),
	@shipperid	varchar(15)
as
	delete 	from soprintqueue
	where 	ri_id = @ri_id
	  and	CpnyID like @cpnyid
	  and	OrdNbr like @ordnbr
	  and	Shipperid like @shipperid

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
