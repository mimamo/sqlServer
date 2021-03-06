USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServFault_SmCode]    Script Date: 12/21/2015 15:37:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smServFault_SmCode]
	@parm1 varchar(10)
	,@parm2beg smallint
	,@parm2end smallint
AS
SELECT smcode.*
FROM smcode, smservfault
	where smcode.Fault_ID = smservfault.faultcodeid
	and smservfault.ServiceCallId = @parm1
	AND smservfault.LineNbr BETWEEN @parm2beg AND @parm2end
ORDER BY smcode.Fault_Id
GO
