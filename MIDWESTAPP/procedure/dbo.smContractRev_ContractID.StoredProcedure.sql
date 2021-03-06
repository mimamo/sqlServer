USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[smContractRev_ContractID]    Script Date: 12/21/2015 15:55:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smContractRev_ContractID]
		@parm1	varchar(10)
		,@parm2 smalldatetime
		,@parm3	smalldatetime
AS
	SELECT
		*
	FROM
		smContractRev
 	WHERE
		ContractId = @parm1
			AND
		RevDate BETWEEN @parm2 AND @parm3
	ORDER BY
		ContractID
		,RevDate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
