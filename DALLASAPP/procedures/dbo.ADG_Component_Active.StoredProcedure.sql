USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Component_Active]    Script Date: 12/21/2015 13:44:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Component_Active]
	@parm1 varchar(30)
AS
	SELECT	*
	FROM	Component
     	WHERE	KitId = @parm1
    	ORDER BY LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
