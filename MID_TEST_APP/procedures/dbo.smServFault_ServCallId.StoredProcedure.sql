USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServFault_ServCallId]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smServFault_ServCallId]
	@parm1 varchar(10)
	,@parm2beg smallint
	,@parm2end smallint
AS
SELECT *
FROM smServFault
	left outer join smcode
		on faultcodeid = smcode.Fault_Id
WHERE ServiceCallId = @parm1
	AND LineNbr BETWEEN @parm2beg AND @parm2end
ORDER BY ServiceCallId
	,LineNbr
GO
