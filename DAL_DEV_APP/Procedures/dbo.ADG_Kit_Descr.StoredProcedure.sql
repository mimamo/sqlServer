USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Kit_Descr]    Script Date: 12/21/2015 13:35:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Kit_Descr]
	@parm1 varchar(30),
	@parm2 varchar(10)
AS
	SELECT	Descr
	FROM	Kit
	WHERE	KitId = @parm1
	  AND	SiteId = @parm2
	  AND	Status = 'A'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
