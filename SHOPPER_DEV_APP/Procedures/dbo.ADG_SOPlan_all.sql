USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOPlan_all]    Script Date: 12/16/2015 15:55:11 ******/
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
