USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_TaskSchedule_TaskInfo]    Script Date: 12/16/2015 15:55:11 ******/
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
