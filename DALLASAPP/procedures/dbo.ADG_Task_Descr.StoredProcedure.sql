USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Task_Descr]    Script Date: 12/21/2015 13:44:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Task_Descr]
	@parm1 varchar(16),
	@parm2 varchar(32)
AS
	SELECT pjt_entity_desc
	FROM   PJPENT
	WHERE  project = @parm1
	  AND  pjt_entity = @parm2

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
