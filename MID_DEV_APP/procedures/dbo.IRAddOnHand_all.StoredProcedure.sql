USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRAddOnHand_all]    Script Date: 12/21/2015 14:17:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRAddOnHand_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3min smalldatetime, @parm3max smalldatetime
AS
	SELECT *
	FROM IRAddOnHand
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND OnDate BETWEEN @parm3min AND @parm3max
	ORDER BY InvtID,
	   SiteID,
	   OnDate

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
