USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[sm_Salesper_SlsperId]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_Salesper_SlsperId]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		Salesperson
	WHERE
		SlsperId LIKE @parm1
	ORDER BY
		SlsperId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
