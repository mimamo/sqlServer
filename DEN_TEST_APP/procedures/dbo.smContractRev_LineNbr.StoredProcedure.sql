USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContractRev_LineNbr]    Script Date: 12/21/2015 15:37:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smContractRev_LineNbr]
		@parm1	varchar(10)
		,@parm2beg	smallint
		,@parm2end 	smallint
AS
	SELECT
		*
	FROM
		smContractRev
 	WHERE
		ContractId = @parm1
			AND
	 	LineNbr BETWEEN @parm2beg AND @parm2end
	ORDER BY
		ContractID
		,LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
