USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOSetup_ProcManSleepSecs]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOSetup_ProcManSleepSecs]
as
	select	ProcManSleepSecs
	from	SOSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
