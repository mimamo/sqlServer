USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRDemDetail_all]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRDemDetail_all]
	@parm1 varchar( 10 ),
	@parm2min int, @parm2max int
AS
	SELECT *
	FROM IRDemDetail
	WHERE DemandID LIKE @parm1
	   AND PriorPeriodNbr BETWEEN @parm2min AND @parm2max
	ORDER BY DemandID,
	   PriorPeriodNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
