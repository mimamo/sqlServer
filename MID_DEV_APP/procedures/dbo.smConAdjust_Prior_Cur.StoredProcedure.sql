USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConAdjust_Prior_Cur]    Script Date: 12/21/2015 14:17:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConAdjust_Prior_Cur]
	@parm1 varchar( 6 )
AS
SELECT * FROM smConAdjust
	WHERE
		PerPost <= @parm1 AND
		AccruetoGL = 0
	ORDER BY
		PerPost,
		AccrueToGl,
		ContractID,
		TransDate,
		Batnbr,
		LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
