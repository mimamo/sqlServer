USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOPlan_all]    Script Date: 12/21/2015 15:49:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOPlan_all]
	@parm1 varchar(30),
	@parm2 varchar(10)
AS
	SELECT *
	FROM SOPlan
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	ORDER BY DisplaySeq

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
