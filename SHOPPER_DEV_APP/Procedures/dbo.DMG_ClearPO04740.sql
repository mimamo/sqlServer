USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ClearPO04740]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_ClearPO04740]
as
		delete from PO04740_WRK
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
