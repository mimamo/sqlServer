USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOSetup_PickTime]    Script Date: 12/21/2015 13:35:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOSetup_PickTime]
as
	select	PickTime
	from	SOSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
