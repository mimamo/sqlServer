USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smEquipment_All_EXE]    Script Date: 12/21/2015 15:43:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smEquipment_All_EXE]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smEquipment
	WHERE
		EquipmentID LIKE @parm1
	ORDER BY
		EquipmentID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
