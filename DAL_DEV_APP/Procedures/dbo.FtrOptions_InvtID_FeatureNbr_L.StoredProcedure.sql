USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FtrOptions_InvtID_FeatureNbr_L]    Script Date: 12/21/2015 13:35:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FtrOptions_InvtID_FeatureNbr_L]
	@parm1 varchar( 30 ),
	@parm2 varchar( 4 ),
	@parm3min smallint, @parm3max smallint
AS
	SELECT *
	FROM FtrOptions
	WHERE InvtID LIKE @parm1
	   AND FeatureNbr LIKE @parm2
	   AND LineNbr BETWEEN @parm3min AND @parm3max
	ORDER BY InvtID,
	   FeatureNbr,
	   LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
