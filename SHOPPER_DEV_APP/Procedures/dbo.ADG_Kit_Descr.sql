USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Kit_Descr]    Script Date: 12/16/2015 15:55:10 ******/
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
