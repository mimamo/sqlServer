USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Batch_SetARLastBatNbr]    Script Date: 12/21/2015 16:00:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Batch_SetARLastBatNbr]
	@LastBatNbr	varchar(10),
	@LUpd_Prog	varchar(8),
	@LUpd_User	varchar(10)
as
	update		ARSetup
	set		LastBatNbr = @LastBatNbr,
			LUpd_DateTime = GetDate(),
			LUpd_Prog = @LUpd_Prog,
			LUpd_User = @LUpd_User

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
