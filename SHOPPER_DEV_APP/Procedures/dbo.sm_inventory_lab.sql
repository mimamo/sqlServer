USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_inventory_lab]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_inventory_lab]
		@parm1	varchar(30)
AS
	SELECT
		*
	FROM
		inventory
	WHERE
		stkitem = 0
			AND
		InvtType = 'L'
			AND
		invtid LIKE @parm1
	ORDER BY
		invtid

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
