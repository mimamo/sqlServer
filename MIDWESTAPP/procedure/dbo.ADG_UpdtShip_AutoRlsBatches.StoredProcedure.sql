USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_AutoRlsBatches]    Script Date: 12/21/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_AutoRlsBatches]
as
	select	convert(smallint, S4Future10)	-- AutoReleaseBatches
	from	SOSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
