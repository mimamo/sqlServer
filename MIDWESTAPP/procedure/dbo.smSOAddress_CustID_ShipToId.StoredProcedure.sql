USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[smSOAddress_CustID_ShipToId]    Script Date: 12/21/2015 15:55:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSOAddress_CustID_ShipToId]
		@parm1	varchar(15)
		,@parm2	varchar(10)
AS
	SELECT
		*
	FROM
		smSoAddress
	WHERE
		CustID LIKE @parm1
			AND
		ShipTOID LIKE @parm2
	ORDER BY
		CustID
		,ShipTOID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
