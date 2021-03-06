USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConAdjust_all]    Script Date: 12/21/2015 16:07:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConAdjust_all]
	@parm1 varchar( 10 ),
	@parm2min smallint, @parm2max smallint
AS
	SELECT *
	FROM smConAdjust
	WHERE Batnbr LIKE @parm1
	   AND LineNbr BETWEEN @parm2min AND @parm2max
	ORDER BY Batnbr,
	   LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
