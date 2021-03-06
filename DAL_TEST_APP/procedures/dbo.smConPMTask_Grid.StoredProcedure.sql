USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConPMTask_Grid]    Script Date: 12/21/2015 13:57:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConPMTask_Grid]
	@parm1 varchar(10)
	,@parm2 varchar(10)
	,@parm3 varchar(10)
	,@parm4 smalldatetime
	,@parm5 smalldatetime
AS
SELECT *
FROM smConPMTask
	left outer join smPMHeader
		on smConPMTask.PMCode = smPMHeader.PMType
WHERE smConPMTask.ContractId = @parm1
	AND smConPMTask.EquipID = @parm2
	AND smConPMTask.PMCode LIKE @parm3
	AND smConPMTask.PMDate BETWEEN @parm4 AND @parm5
ORDER BY smConPMTask.ContractID
	,smConPMTask.EquipId
	,smConPMTask.PMCode
	,smConPMTask.PMDate
GO
