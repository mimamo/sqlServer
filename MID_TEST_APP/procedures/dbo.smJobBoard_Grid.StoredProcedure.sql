USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smJobBoard_Grid]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smJobBoard_Grid]
	@parm1 smalldatetime
	,@parm2 varchar(10)
AS
SELECT *
FROM smServCall
	left outer join SOAddress
		on smServCall.CustomerId = SOAddress.Custid
		and smServCall.ShiptoId = SOAddress.Shiptoid
WHERE smServCall.ServiceCallDate <= @parm1
	AND smServCall.ServiceCallCompleted = 0
	AND smServCall.ServiceCallDuration = 'L'
	AND smServCall.ServiceCallStatus = 'R'
	AND smServCall.ServiceCallID LIKE @parm2
ORDER BY ServiceCallID
GO
