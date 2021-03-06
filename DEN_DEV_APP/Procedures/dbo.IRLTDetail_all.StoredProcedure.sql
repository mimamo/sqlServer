USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRLTDetail_all]    Script Date: 12/21/2015 14:06:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRLTDetail_all]
	@parm1 varchar( 10 ),
	@parm2min int, @parm2max int
AS
	SELECT *
	FROM IRLTDetail
	WHERE LeadTimeID LIKE @parm1
	   AND PriorPeriodNbr BETWEEN @parm2min AND @parm2max
	ORDER BY LeadTimeID,
	   PriorPeriodNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
