USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_ArTran_InvcNbr]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_ArTran_InvcNbr]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		ARTran
	WHERE
		ArTran.RefNbr = @parm1
			AND
		TranType = 'IN'
			AND
		DRCR = 'C'
	ORDER BY
		RefNbr
		,TranType
		,LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
