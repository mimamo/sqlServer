USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLSetup_NbrPer]    Script Date: 12/21/2015 14:17:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLSetup_NbrPer]
as
	select NbrPer
	from GLSetup (nolock)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
