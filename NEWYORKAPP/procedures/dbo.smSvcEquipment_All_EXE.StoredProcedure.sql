USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[smSvcEquipment_All_EXE]    Script Date: 12/21/2015 16:01:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSvcEquipment_All_EXE]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smSvcEquipment
	WHERE
		Status = 'A'
			AND
		EquipID LIKE @parm1
	ORDER BY
		EquipID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
