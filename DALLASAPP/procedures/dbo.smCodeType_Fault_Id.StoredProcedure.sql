USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smCodeType_Fault_Id]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smCodeType_Fault_Id]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smCodeType
	left outer join smCallTypes
		on smCodeType.CallTypeId = smCallTypes.CallTypeId
WHERE smCodeType.Fault_Id = @parm1
	AND smCodeType.CallTypeId LIKE @parm2
ORDER BY smCodeType.Fault_Id, smCodeType.CallTypeId
GO
