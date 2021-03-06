USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smSCQStatusCall_All]    Script Date: 12/21/2015 13:45:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smSCQStatusCall_All]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smSCQStatusCall
	left outer join smCallStatus
		on smSCQStatusCall.CallStatus = smCallStatus.CallStatusId
WHERE ConfigCode = @parm1
	AND CallStatus LIKE @parm2
ORDER BY ConfigCode
	,CallStatus
GO
