USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_GetBatches]    Script Date: 12/21/2015 14:17:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_GetBatches]
	@JrnlType	varchar(3),
	@OrigScrnNbr	varchar(5)
as
	select	Module,
		BatNbr

	from	Batch

	where	JrnlType = @JrnlType
	  and	OrigScrnNbr = @OrigScrnNbr
	  and	Status = 'V'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
