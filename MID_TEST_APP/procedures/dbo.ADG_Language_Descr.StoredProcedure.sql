USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Language_Descr]    Script Date: 12/21/2015 15:49:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Language_Descr] @parm1 varchar(4) as
	select	Descr
	from	Language
	where	LanguageID = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
