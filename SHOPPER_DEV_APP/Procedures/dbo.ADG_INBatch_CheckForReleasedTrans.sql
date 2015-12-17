USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_INBatch_CheckForReleasedTrans]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_INBatch_CheckForReleasedTrans]

	@BatNbr varchar(10)
as

	select 	count(*)
	from	INTran
	where	BatNbr = @BatNbr
	  and	Rlsed = 1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
