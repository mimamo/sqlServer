USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessControl_Read]    Script Date: 12/16/2015 15:55:10 ******/
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
