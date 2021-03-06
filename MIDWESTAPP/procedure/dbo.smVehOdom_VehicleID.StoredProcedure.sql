USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[smVehOdom_VehicleID]    Script Date: 12/21/2015 15:55:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smVehOdom_VehicleID]
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
		VehicleID = @parm1
			AND
		EmpID LIKE @parm2
			AND
		LineNbr BETWEEN @parm3beg AND @parm3end
	ORDER BY
		VehicleID
		,VehicleReadDate DESC
		, LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
