USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smVehOdom_EmpID]    Script Date: 12/21/2015 16:07:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smVehOdom_EmpID]
		@parm1	varchar(10)
		,@parm2	varchar(10)
		,@parm3beg	smallint
		,@parm3end 	smallint
AS
	SELECT
		*
	FROM
		smVehOdom
	WHERE
		EmpID = @parm1
			AND
		VehicleID LIKE @parm2
			AND
		LineNbr BETWEEN @parm3beg AND @parm3end
	ORDER BY
		EmpID
		,VehicleReadDate DESC
		,LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
