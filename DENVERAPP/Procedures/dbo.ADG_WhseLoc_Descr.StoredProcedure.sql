USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_WhseLoc_Descr]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_WhseLoc_Descr]
	@parm1 varchar(10),
	@parm2 varchar(10)
AS
	SELECT	Descr
	FROM	LocTable
	WHERE	Siteid = @parm1
	  AND	WhseLoc = @parm2

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
