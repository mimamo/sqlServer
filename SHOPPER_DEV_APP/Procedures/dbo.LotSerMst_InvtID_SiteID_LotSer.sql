USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_InvtID_SiteID_LotSer]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerMst_InvtID_SiteID_LotSer]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 25 )
AS
	SELECT *
	FROM LotSerMst
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND LotSerNbr LIKE @parm3
	ORDER BY InvtID,
	   SiteID,
	   LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
