USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ClearIN10863]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_ClearIN10863]
as
		delete from IN10863_WRK
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
