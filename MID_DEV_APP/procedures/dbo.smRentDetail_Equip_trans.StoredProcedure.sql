USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smRentDetail_Equip_trans]    Script Date: 12/21/2015 14:17:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smRentDetail_Equip_trans]
		@parm1	varchar(10)
		,@parm2	varchar(10)
		,@parm3Min	smallint
		,@parm3Max	smallint
AS
	SELECT
		*
	FROM
		smRentDetail
	WHERE
		EquipID = @parm1
			AND
		TransId = @parm2
			AND
		LineID BETWEEN @parm3Min AND @Parm3Max
	ORDER BY
		EquipID
		,TransID
		,LineID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
