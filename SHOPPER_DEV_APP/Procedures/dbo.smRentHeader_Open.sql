USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smRentHeader_Open]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smRentHeader_Open]
		@parm1	varchar(10)
		,@parm2	varchar(10)
AS
	SELECT
		*
	FROM
		smRentHeader
	WHERE
		TransId =  @parm1
			AND
		EquipId = @parm2
			AND
		Status IN ('N', 'R','P')
	ORDER BY
		TransID
		,EquipID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
