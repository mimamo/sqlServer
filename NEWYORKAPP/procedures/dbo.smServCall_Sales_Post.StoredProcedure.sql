USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[smServCall_Sales_Post]    Script Date: 12/21/2015 16:01:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServCall_Sales_Post]
		@parm1	varchar(6)
		,@parm2	varchar(6)
		,@parm3 varchar(10)
AS
	SELECT
		*
	FROM
		smServCall
		,Customer
	WHERE
		PostToPeriod BETWEEN  @parm1 AND @parm2
		AND
		(ServiceCallCompleted = 1 OR cmbCODInvoice = 'P')
        	AND
        	smServCall.CustomerId = Customer.CustId
		AND
		smServCall.Branchid Like @parm3
	 ORDER BY
		ServiceCallID
GO
