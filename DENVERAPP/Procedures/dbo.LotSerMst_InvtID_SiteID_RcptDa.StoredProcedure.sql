USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_InvtID_SiteID_RcptDa]    Script Date: 12/21/2015 15:42:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerMst_InvtID_SiteID_RcptDa]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3min smalldatetime, @parm3max smalldatetime
AS
	SELECT *
	FROM LotSerMst
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND RcptDate BETWEEN @parm3min AND @parm3max
	ORDER BY InvtID,
	   SiteID,
	   RcptDate

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
