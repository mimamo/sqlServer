USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ClearPO04740_RIID]    Script Date: 12/21/2015 13:35:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_ClearPO04740_RIID]
	@ri_id		smallint
as
		delete from PO04740_WRK where ri_id = @ri_id
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
