USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ARDoc_TranDescDflt]    Script Date: 12/21/2015 15:42:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ARDoc_TranDescDflt]
as
	select	TranDescDflt
	from	ARSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
