USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessControl_Read]    Script Date: 12/21/2015 16:00:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessControl_Read]
as
	select * from ProcessControl
	where  ControlID = 'PM'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
