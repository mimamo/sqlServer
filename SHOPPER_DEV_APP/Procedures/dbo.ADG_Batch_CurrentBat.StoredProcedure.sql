USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Batch_CurrentBat]    Script Date: 12/21/2015 14:34:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Batch_CurrentBat]
	@CpnyID		varchar(10),
	@Module		varchar(2),
	@JrnlType	varchar(3),
	@EditScrnNbr	varchar(5),
	@PerPost	varchar(6),
	@CuryID		varchar(4),
	@CuryMultDiv	varchar(1),
	@OrigBatNbr	varchar(10)
as
	select		*
	from		Batch
	where		Rlsed = 0
	  and		Status = 'V'
	  and		PerPost = @PerPost
	  and		Module = @Module
	  and		JrnlType = @JrnlType
	  and		EditScrnNbr = @EditScrnNbr
	  and		CpnyID = @CpnyID
	  and		CuryID = @CuryID
	  and		CuryMultDiv = @CuryMultDiv
	  and		OrigBatNbr = @OrigBatNbr
	Order by BatNbr Desc

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
