USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_LocTable_SiteID]    Script Date: 12/21/2015 16:00:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_LocTable_SiteID]
 	@parm1 varchar ( 10),
	@parm2 varchar ( 10)
AS
    	Select 	*
	from 	LocTable
        where 	Siteid = @parm1
	  and 	WhseLoc like @parm2
	Order by SiteID, WhseLoc

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
