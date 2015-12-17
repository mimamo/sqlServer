USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContractRev_HistFix]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smContractRev_HistFix]
		@parm1	smalldatetime
		,@parm2 smalldatetime
AS
	SELECT
		*
	FROM
		smContractRev
	WHERE
		RevDate BETWEEN @parm1 AND @parm2
			AND
		RevFlag = 1
			AND
		Status = 'P'
	ORDER BY
		ContractId
		,RevDate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
