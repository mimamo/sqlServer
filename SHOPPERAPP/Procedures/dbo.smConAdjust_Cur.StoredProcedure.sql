USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smConAdjust_Cur]    Script Date: 12/21/2015 16:13:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConAdjust_Cur]
	@parm1 varchar( 6 )
AS
SELECT * FROM smConAdjust
	WHERE
		PerPost = @parm1 AND
		AccruetoGL = 0
	ORDER BY
		PerPost,
		AccrueToGL,
		ContractID,
		TransDate,
		Batnbr,
		LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
