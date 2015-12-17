USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Date_ClockDiff]    Script Date: 12/16/2015 15:55:10 ******/
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
