USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContractRev_Sales_Post]    Script Date: 12/21/2015 13:57:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smContractRev_Sales_Post]
		@parm1	varchar(6)
		,@parm2	varchar(6)
		,@parm3 varchar(10)
AS
	SELECT
		*
	FROM
		smContractRev
		,Batch
--		,smContract
	WHERE
		smContractRev.Status = 'P' AND
 		smContractRev.GLBatNbr = Batch.BatNbr AND
		Batch.Module = 'GL' AND
		Batch.PerPost BETWEEN @parm1 AND @parm2 AND

		EXISTS( SELECT * FROM smContract
			WHERE	smContract.ContractID = smContractRev.ContractID ANd
				smContract.BranchID like @parm3)
	ORDER BY
		smContractRev.ContractID
		, smContractRev.RevDate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
