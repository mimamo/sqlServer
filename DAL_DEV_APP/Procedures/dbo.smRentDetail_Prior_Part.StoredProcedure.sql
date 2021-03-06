USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smRentDetail_Prior_Part]    Script Date: 12/21/2015 13:35:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smRentDetail_Prior_Part]
		@parm1 	varchar(10)
		,@parm2	varchar(10)
		,@parm3	varchar(10)
		,@parm4	varchar(1)
AS
	SELECT
		*
	FROM
		smRentDetail
	WHERE
		BillingDate < @parm1
			AND
		BillStatus = 'P'
			AND
		BranchID LIKE @parm2
			AND
		RentalID LIKE @parm3
			AND
		Frequency LIKE @parm4
			AND
		Void = 0
	ORDER BY
		CustID
		,SiteId
		,TransID
		,LineId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
