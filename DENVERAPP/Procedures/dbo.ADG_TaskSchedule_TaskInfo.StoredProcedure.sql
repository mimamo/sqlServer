USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_TaskSchedule_TaskInfo]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_TaskSchedule_TaskInfo]
as
	select	TaskProgram,
		CpnyID,
		FunctionID,
		FunctionClass,
		StartTime,
		EndTime,
		Interval
	from	TaskSchedule
	where	Active = 1
	order by StartTime, TaskProgram

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
