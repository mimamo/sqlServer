USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Batch_DeleteBatch]    Script Date: 12/21/2015 13:44:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Batch_DeleteBatch]
	@Module		varchar(2),
	@BatNbr		varchar(10)
as
	delete		Batch
	where		Module = @Module
	  and		BatNbr = @BatNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
