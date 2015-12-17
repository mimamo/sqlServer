USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smRentHeader_Equipid]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smRentHeader_Equipid]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smRentHeader
	WHERE
		EquipID = @parm1
			AND
		Status IN ('N', 'R','P')
	ORDER BY
		EquipID
		,TransID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
