USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smJobCallType_All]    Script Date: 12/21/2015 13:45:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smJobCallType_All]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smJobCallType
	left outer join smCallTypes
		on mJobCallType.CallType = smCallTypes.CallTypeId
WHERE ConfigCode = @parm1
	AND CallType LIKE @parm2
ORDER BY ConfigCode
	,CallType
GO
