USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[FtrOptions_all]    Script Date: 12/21/2015 13:57:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FtrOptions_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 4 ),
	@parm3 varchar( 30 )
AS
	SELECT *
	FROM FtrOptions
	WHERE InvtID LIKE @parm1
	   AND FeatureNbr LIKE @parm2
	   AND OptInvtID LIKE @parm3
	ORDER BY InvtID,
	   FeatureNbr,
	   OptInvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
