USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SHSetup_Count]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SHSetup_Count]

as
	select	count(*)
	from	SHSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
