USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_GetModuleBatches]    Script Date: 12/21/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_GetModuleBatches]
	@Module		varchar(2),
	@JrnlType	varchar(3),
	@OrigScrnNbr	varchar(5),
	@OrigBatNbr	varchar(10)
as
	select	BatNbr

	from	Batch

	where	Module = @Module
	  and	JrnlType = @JrnlType
	  and	OrigScrnNbr = @OrigScrnNbr
	  and	OrigBatNbr = @OrigBatNbr
	  and	Status = 'V'
	  and	LUpd_Prog = '40690'	--Only return batches created by the pre-process
					--This keeps the post-process from balancing manually
					--voided batches

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
