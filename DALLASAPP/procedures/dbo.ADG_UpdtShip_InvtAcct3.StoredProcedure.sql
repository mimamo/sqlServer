USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_InvtAcct3]    Script Date: 12/21/2015 13:44:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_InvtAcct3]
as
	select	DfltInvtAcct,
		DfltInvtSub
	from	INSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
