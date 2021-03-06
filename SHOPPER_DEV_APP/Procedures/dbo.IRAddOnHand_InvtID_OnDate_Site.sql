USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRAddOnHand_InvtID_OnDate_Site]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRAddOnHand_InvtID_OnDate_Site]
	@parm1 varchar( 30 ),
	@parm2min smalldatetime, @parm2max smalldatetime,
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM IRAddOnHand
	WHERE InvtID LIKE @parm1
	   AND OnDate BETWEEN @parm2min AND @parm2max
	   AND SiteID LIKE @parm3
	ORDER BY InvtID,
	   OnDate,
	   SiteID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
