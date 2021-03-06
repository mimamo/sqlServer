USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Date_ClockDiff]    Script Date: 12/21/2015 13:44:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Date_ClockDiff]
	@DateTimeString	char(20)	-- format YYYYMMDD hh:mm[:ss:mm]
as
	select DateDiff(ss, @DateTimeString, GetDate())

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
