USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_InvtID_SiteID_Status]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerMst_InvtID_SiteID_Status]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 1 ),
	@parm4 varchar( 25 )
AS
	SELECT *
	FROM LotSerMst
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND Status LIKE @parm3
	   AND LotSerNbr LIKE @parm4
	ORDER BY InvtID,
	   SiteID,
	   Status,
	   LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
