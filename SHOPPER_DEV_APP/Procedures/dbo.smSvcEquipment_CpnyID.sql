USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSvcEquipment_CpnyID]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSvcEquipment_CpnyID]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smSvcEquipment
	WHERE
		Status = 'A'
			AND
		EquipID LIKE @parm1
	ORDER BY
		EquipID
GO
