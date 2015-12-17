USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServCall_Open_Entry]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smServCall_Open_Entry]
	@parm1 varchar(15)
	,@parm2 varchar(10)
AS
SELECT * FROM smServCall
	WHERE
		CustomerId = @parm1 AND
		ShiptoId = @parm2 AND
        		ServiceCallCompleted =  0
        	ORDER BY
			ServiceCallID,
			ServiceCallDateProm

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
