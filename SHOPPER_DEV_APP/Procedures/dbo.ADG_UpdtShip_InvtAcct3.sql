USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_InvtAcct3]    Script Date: 12/16/2015 15:55:11 ******/
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
