USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSvcEquipment_All]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSvcEquipment_All]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smSvcEquipment
	WHERE
		EquipID LIKE @parm1
	ORDER BY
		EquipID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
