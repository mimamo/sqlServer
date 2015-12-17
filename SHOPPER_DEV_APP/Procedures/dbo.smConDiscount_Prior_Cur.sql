USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConDiscount_Prior_Cur]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConDiscount_Prior_Cur]
	@parm1 smalldatetime
AS
SELECT * FROM smConDiscount
	WHERE
		AccrueDate <= @parm1 AND
		AccruetoGL = 0
	ORDER BY
		AccrueDate,
		AccrueToGl,
		ContractID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
