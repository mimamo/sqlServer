USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_INSetupAcct]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_INSetupAcct]
as
	select	APClearingAcct,
		APClearingSub,
		ARClearingAcct,
		ARClearingSub,
--		InTransitAcct,
--		InTransitSub
		INClearingAcct,	-- temp
		INClearingSub	-- temp

	from	INSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
