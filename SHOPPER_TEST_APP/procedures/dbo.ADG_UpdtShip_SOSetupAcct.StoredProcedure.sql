USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_SOSetupAcct]    Script Date: 12/21/2015 16:06:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_SOSetupAcct]
as
	select	InvtScrapAcct,
		InvtScrapSub

	from	SOSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
