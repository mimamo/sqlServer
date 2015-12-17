USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConEquipment_ContractID]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smConEquipment_ContractID]
		@parm1	varchar(10)
		,@parm2 varchar(10)
AS
	SELECT
		*
	FROM
		smConEquipment
 	WHERE
		ContractId = @parm1
			AND
		EquipID  LIKE @parm2
	ORDER BY
		ContractID
		,EquipId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
