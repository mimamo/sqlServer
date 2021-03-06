USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smJobCallType_All]    Script Date: 12/21/2015 15:43:10 ******/
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
