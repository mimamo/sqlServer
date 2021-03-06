USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[sm_SalesPrice]    Script Date: 12/21/2015 15:55:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_SalesPrice]
		@parm1	varchar(30)
		,@parm2	varchar(10)
		,@parm3	varchar(6)
		,@parm4 float
AS
	SELECT
		*
	FROM
		SalesPrice
	WHERE
		SalesPrice.InvtId = @parm1
			AND
		SalesPrice.PrcLvlId = @parm2
			AND
		SalesPrice.SlsUnit = @parm3
			AND
		SalesPrice.QtyBreak <= @parm4
	ORDER BY
		SalesPrice.InvtId DESC
		,SalesPrice.PrcLvlId DESC
		,SalesPrice.SlsUnit DESC
		,SalesPrice.QtyBreak DESC

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
