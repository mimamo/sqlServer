USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CSCycle_Descr]    Script Date: 12/21/2015 16:12:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_CSCycle_Descr]
	@parm1 varchar(10)
AS
	SELECT Descr
	FROM CSCycle
	WHERE CycleID = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
