USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEqHistory_EquipID]    Script Date: 12/21/2015 14:17:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smEqHistory_EquipID]
		@parm1	varchar(10)
		,@parm2 varchar(4)
AS
	SELECT
		*
	FROM
		smEqHistory
	WHERE
		EquipID LIKE @parm1
			AND
		CalYear LIKE @parm2
	ORDER BY
		EquipID
		,CalYear

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
