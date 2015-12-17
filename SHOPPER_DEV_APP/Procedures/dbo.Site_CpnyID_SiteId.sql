USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Site_CpnyID_SiteId]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Site_CpnyID_SiteId]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM Site
	WHERE CpnyID LIKE @parm1
	   AND SiteId LIKE @parm2
	ORDER BY CpnyID,
	   SiteId

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
