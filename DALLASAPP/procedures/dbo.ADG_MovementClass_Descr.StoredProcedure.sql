USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_MovementClass_Descr]    Script Date: 12/21/2015 13:44:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_MovementClass_Descr]
	@parm1 varchar(10)
AS
	SELECT	Descr
	FROM	PIMoveCl
	WHERE	MoveClass = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
