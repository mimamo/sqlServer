USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Territory_Descr]    Script Date: 12/21/2015 16:00:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Territory_Descr]
	@parm1 varchar (10)
AS
	Select	Descr
	from 	Territory
	where 	Territory = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
