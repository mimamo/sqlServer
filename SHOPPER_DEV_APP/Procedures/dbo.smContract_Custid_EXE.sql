USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_Custid_EXE]    Script Date: 12/16/2015 15:55:34 ******/
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
