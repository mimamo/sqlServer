USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smVehicle_All]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smVehicle_All]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smVehicle
	WHERE
		VehicleId LIKE @parm1
	ORDER BY
		VehicleId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
