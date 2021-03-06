USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smModPMBase_grid]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smModPMBase_grid]
		@parm1	varchar(10)
		,@parm2	varchar(40)
		,@parm3	varchar(10)
AS
	SELECT
		*
	FROM
		smModPMBase
	WHERE
		ManufID = @parm1
			AND
		ModelID = @parm2
			AND
		ContractTypeId LIKE @parm3
     ORDER BY
		ManufId,
		ModelID,
		ContractTypeId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
