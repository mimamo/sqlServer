USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConAdjust_AccruePrior]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConAdjust_AccruePrior]
	@parm1 varchar( 6 )
AS
SELECT * FROM smConAdjust
	WHERE
		PerPost < @parm1 AND
		AccruetoGL = 0

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
