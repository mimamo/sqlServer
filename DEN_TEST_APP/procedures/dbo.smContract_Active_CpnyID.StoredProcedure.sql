USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_Active_CpnyID]    Script Date: 12/21/2015 15:37:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smContract_Active_CpnyID]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
	SELECT * FROM smContract
	WHERE 	CpnyID = @parm1
		AND
		ContractId LIKE @parm1
		AND Status IN ('A','E','C')
	ORDER BY
		ContractId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
