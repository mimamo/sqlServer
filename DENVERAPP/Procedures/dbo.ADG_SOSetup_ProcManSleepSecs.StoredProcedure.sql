USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOSetup_ProcManSleepSecs]    Script Date: 12/21/2015 15:42:41 ******/
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
