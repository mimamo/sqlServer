USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_Batch_Module_BatNbr]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_Batch_Module_BatNbr]
	@parm1	varchar(2)
	,@parm2	varchar(10)
AS
	SELECT
		*
	FROM
		Batch
	WHERE
		Module = @parm1
	   		AND
	   	BatNbr = @parm2
	ORDER BY
		Module
		,BatNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
