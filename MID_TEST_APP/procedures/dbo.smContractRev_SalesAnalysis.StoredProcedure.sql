USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContractRev_SalesAnalysis]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smContractRev_SalesAnalysis]
		@parm1	smalldatetime
		,@parm2	smalldatetime
		,@parm3 varchar(10)
AS
	SELECT
		*
	FROM
		smContractRev, smContract
	WHERE
		smContractRev.RevDate BETWEEN @parm1 AND @parm2
			AND
		smContractRev.Status = 'P'
			AND
		smContractRev.ContractID = smContract.ContractId
			AND
		smContract.BranchId LIKE @parm3

	ORDER BY
		smContractRev.ContractID
		,RevDate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
