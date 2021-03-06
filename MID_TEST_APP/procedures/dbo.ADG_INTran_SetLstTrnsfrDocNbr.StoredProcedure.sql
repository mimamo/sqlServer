USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_INTran_SetLstTrnsfrDocNbr]    Script Date: 12/21/2015 15:49:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_INTran_SetLstTrnsfrDocNbr]
	@LastDocNbr	varchar(10),
	@LUpd_Prog	varchar(8),
	@LUpd_User	varchar(10)
as
	update		INSetup
	set		LstTrnsfrDocNbr = @LastDocNbr,
			LUpd_DateTime = GetDate(),
			LUpd_Prog = @LUpd_Prog,
			LUpd_User = @LUpd_User

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
