USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smequipment_empid]    Script Date: 12/21/2015 13:45:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smequipment_empid]
		@parm1	varchar(10)
		,@parm2 varchar(10)
AS
	SELECT
		*
	FROM
		smEquipment
	WHERE
		EquipmentEmployeeID = @parm1
			AND
		EquipmentID LIKE @parm2
	ORDER BY
		EquipmentEmployeeID
		,EquipmentID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
