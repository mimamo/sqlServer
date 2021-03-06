USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[smServFault_ServCallId_ALL]    Script Date: 12/21/2015 16:01:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smServFault_ServCallId_ALL]
	@parm1 varchar(10)
	,@parm2beg smallint
	,@parm2end smallint
AS
SELECT *
FROM smServFault
	left outer join smcode
		on smServFault.faultcodeid = smcode.Fault_Id
	left outer join smEmp
		on smServFault.EmpId = smEmp.EmployeeId
	left outer join smCause
		on smServFault.CauseID = smCause.CauseID
	left outer join smResolution
		on smServFault.ResolutionID = smResolution.REsolutionID
WHERE ServiceCallId = @parm1
	AND LineNbr BETWEEN @parm2beg AND @parm2end
ORDER BY ServiceCallId
	,LineNbr
GO
