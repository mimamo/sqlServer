USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_InvtID_SiteID_LotSer]    Script Date: 12/21/2015 13:44:57 ******/
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
