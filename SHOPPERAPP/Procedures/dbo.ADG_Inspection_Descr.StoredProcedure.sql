USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Inspection_Descr]    Script Date: 12/21/2015 16:12:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Inspection_Descr]
	@parm1 varchar(30),
	@parm2 varchar(2)
AS
	SELECT	Descr
	FROM	Inspection
	WHERE	InvtID = @parm1
	  AND	InspID = @parm2

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
