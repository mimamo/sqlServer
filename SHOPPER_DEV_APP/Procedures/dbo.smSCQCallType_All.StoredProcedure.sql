USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSCQCallType_All]    Script Date: 12/21/2015 14:34:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smSCQCallType_All]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smSCQCallType
	left outer join smCallTypes
		on smSCQCallType.CallType = smCallTypes.CallTypeId
WHERE ConfigCode = @parm1
	AND CallType LIKE @parm2
ORDER BY ConfigCode
	,CallType
GO
