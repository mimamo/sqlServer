USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[sm_soaddress_custid_shiptoid]    Script Date: 12/21/2015 16:13:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_soaddress_custid_shiptoid]
		@parm1	varchar(15)
		,@parm2 varchar(10)
AS
	SELECT
		*
	FROM
		SOAddress
	WHERE
		Custid LIKE @parm1
			AND
		Shiptoid LIKE @parm2
		order by CustId, ShipToId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
