USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ClearIN10863_RIID]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_ClearIN10863_RIID]
	@ri_id		smallint
as
		delete from IN10863_WRK where ri_id = @ri_id
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
