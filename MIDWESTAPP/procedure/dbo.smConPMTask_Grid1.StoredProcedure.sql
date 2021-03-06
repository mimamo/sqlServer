USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[smConPMTask_Grid1]    Script Date: 12/21/2015 15:55:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConPMTask_Grid1]
	@parm1 varchar(10)
	,@parm2 varchar(10)
	,@parm3 smalldatetime
	,@parm4 smalldatetime
	,@parm5 varchar(10)
AS
SELECT *
FROM smConPMTask
	left outer join smPMHeader
		on smConPMTask.PMCode = smPMHeader.PMType
WHERE smConPMTask.ContractId = @parm1
	AND smConPMTask.EquipID = @parm2
	AND smConPMTask.PMDate BETWEEN @parm3 AND @parm4
	AND smConPMTask.PMCode LIKE @parm5
ORDER BY smConPMTask.ContractID
	,smConPMTask.EquipId
	,smConPMTask.PMDate
	,smConPMTask.PMCode
GO
