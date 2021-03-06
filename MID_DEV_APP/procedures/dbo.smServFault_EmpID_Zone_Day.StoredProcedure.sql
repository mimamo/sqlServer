USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServFault_EmpID_Zone_Day]    Script Date: 12/21/2015 14:17:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServFault_EmpID_Zone_Day]
		@parm1	varchar(10),
		@parm2	smalldatetime
AS
	SELECT
		smServFault.EmpID, smServFault.ServiceCallID, smServFault.LineNbr, smServCall.CustGeographicID
	FROM
		smServFault, smServCall
	WHERE
		(TaskStatus = 'W' OR TaskStatus = 'R') AND
		smServFault.StartDate = @parm2 AND
		smServFault.EmpID LIKE @parm1 AND
		smServCall.ServiceCallID = smServFault.ServiceCallID
	ORDER BY
		smServFault.ServiceCallID, smServFault.LineNbr
GO
