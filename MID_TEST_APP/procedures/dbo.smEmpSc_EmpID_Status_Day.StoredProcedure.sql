USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEmpSc_EmpID_Status_Day]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smEmpSc_EmpID_Status_Day]
		@parm1	varchar(10),
		@parm2	smalldatetime
AS
	SELECT
		EndDate, EndTime, EmpID, StartDate, StartTime, Status
	FROM
		smEmpSchedule
	WHERE
		EmpID = @parm1 AND
		StartDate <= @parm2 AND
		EndDate   >= @parm2
	ORDER BY
		EmpID,
		StartDate
GO
