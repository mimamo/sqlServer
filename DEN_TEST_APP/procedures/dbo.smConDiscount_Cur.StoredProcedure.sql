USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConDiscount_Cur]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConDiscount_Cur]
	@parm1 smalldatetime,
	@parm2 smalldatetime
AS
SELECT * FROM smConDiscount
	WHERE
		AccrueDate >= @parm1 and
		Accruedate <= @parm2
			AND
		AccruetoGL = 0
	ORDER BY
		AccrueDate,
		AccrueToGL,
		ContractID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
