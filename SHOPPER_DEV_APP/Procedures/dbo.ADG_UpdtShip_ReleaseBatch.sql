USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_ReleaseBatch]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_ReleaseBatch]
	@Module	varchar(2),
	@BatNbr	varchar(10)
as
	update	Batch

	set	Status = 'B',
		LUpd_DateTime = GetDate(),
		LUpd_Prog = 'UPDSH',
		LUpd_User = 'UPDSH'

	where	Module = @Module
	  and	BatNbr = @BatNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
