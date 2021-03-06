USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConEquipment_All]    Script Date: 12/21/2015 14:17:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smConEquipment_All]
		@parm1	varchar(10)
		,@parm2 varchar(10)
		,@parm3 varchar(10)
AS
	SELECT
		*
	FROM
		smConEquipment
 	WHERE
		smConEquipment.ContractId = @parm1
			AND
		smConEquipment.EquipID LIKE @parm2
			AND
		smConEquipment.PMCode LIKE @parm3
	ORDER BY
		smConEquipment.ContractID
		,smConEquipment.EquipId
		,smConEquipment.PMCode
GO
