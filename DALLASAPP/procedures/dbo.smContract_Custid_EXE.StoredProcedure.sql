USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_Custid_EXE]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smContract_Custid_EXE]
		@parm1	varchar(15)
		,@parm2	varchar(10)
		,@parm3 varchar(10)
AS
	SELECT
		*
	FROM
		smContract
		WHERE
			CustId = @parm1
				AND
			SiteId = @parm2
				AND
			ContractID LIKE @Parm3
	ORDER BY
		CustId
		,SiteId
		,ContractID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
