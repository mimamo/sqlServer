USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Site_CpnyID_NoInvt]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_Site_CpnyID_NoInvt]
	@parm1 varchar(10),
	@parm2 varchar(10)
	AS
	SELECT 	*
	FROM 	Site
	WHERE   CpnyID = @parm1
	  and 	SiteId like @parm2
	ORDER BY SiteId

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
