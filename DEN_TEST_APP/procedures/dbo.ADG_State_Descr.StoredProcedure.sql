USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_State_Descr]    Script Date: 12/21/2015 15:36:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_State_Descr]
	@parm1 varchar(3)
AS
	Select	Descr
	from	State
	where	StateProvID = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
