USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smRentDetail_Billing]    Script Date: 12/21/2015 16:13:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smRentDetail_Billing]
		@parm1 	smalldatetime
		,@parm2	varchar(10)
		,@parm3	varchar(10)
		,@parm4	varchar(1)
AS
	SELECT
		*
	FROM
		smRentDetail
	WHERE
		StartDate <= @parm1
			AND
		BillStatus IN ('P', 'N')
			AND
		BranchID LIKE @parm2
			AND
		RentalID LIKE @parm3
			AND
		Frequency LIKE @parm4
			AND
		BillingDate < @parm1
			AND
		Void = 0
	ORDER BY
		CustID
		,SiteId
		,TransID
		,LineId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
