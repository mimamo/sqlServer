USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServCall_Ready_Invoice]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServCall_Ready_Invoice]
		@parm1	varchar(1)
		,@parm2 varchar(10)
		,@parm3 varchar(10)
		,@parm4 varchar(10)
AS
	SELECT
		*
	FROM
		smServCall
	WHERE
		ServiceCallCompleted = CONVERT(int,@parm1)
		AND CpnyID = @parm2
		AND InvoiceFlag = 0
		AND InvoiceHandling = 'A'
		AND InvoiceStatus IN ('O','P')
		AND (PostToPeriod = @parm3 OR PostToPeriod = '')
		AND ServiceCallId LIKE @parm4
	ORDER BY
		ServiceCallId
GO
