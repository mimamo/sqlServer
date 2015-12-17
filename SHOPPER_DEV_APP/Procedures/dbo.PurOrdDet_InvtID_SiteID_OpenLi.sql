USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_InvtID_SiteID_OpenLi]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PurOrdDet_InvtID_SiteID_OpenLi]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3min smallint, @parm3max smallint
AS
	SELECT *
	FROM PurOrdDet
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND OpenLine BETWEEN @parm3min AND @parm3max
	ORDER BY InvtID,
	   SiteID,
	   OpenLine

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
