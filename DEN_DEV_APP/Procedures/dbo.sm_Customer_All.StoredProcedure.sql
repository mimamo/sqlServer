USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_Customer_All]    Script Date: 12/21/2015 14:06:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_Customer_All]
		@parm1	varchar(15)
AS
	SELECT
		*
	FROM
		Customer
	WHERE
		CustId LIKE @parm1
	ORDER BY
		custid

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
