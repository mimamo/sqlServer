USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSvcReadings_EquipID]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSvcReadings_EquipID]
		@parm1	varchar(10)
		,@parm2	smalldatetime
		,@parm3	smalldatetime
AS
	SELECT
		*
	FROM
		smSvcReadings
	WHERE
		EquipId = @parm1
			AND
		ReadDate BETWEEN @parm2 AND @parm3
	ORDER BY
		EquipId
		,ReadDate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
