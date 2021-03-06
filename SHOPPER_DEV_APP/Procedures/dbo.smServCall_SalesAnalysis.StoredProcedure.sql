USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServCall_SalesAnalysis]    Script Date: 12/21/2015 14:34:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServCall_SalesAnalysis]
		@parm1	smalldatetime
		,@parm2	smalldatetime
		,@parm3 varchar(10)
AS
	SELECT
		*
	FROM
		smServCall
		,Customer
	WHERE
		completeDate BETWEEN  @parm1 AND @parm2
		AND
		(ServiceCallCompleted = 1 OR cmbCODInvoice = 'P')
        	AND
	        smServCall.CustomerId = Customer.CustId
		AND
		smServCall.BranchId LIKE @parm3
	 ORDER BY
		ServiceCallID
GO
