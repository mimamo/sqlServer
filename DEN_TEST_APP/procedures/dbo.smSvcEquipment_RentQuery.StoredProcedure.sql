USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSvcEquipment_RentQuery]    Script Date: 12/21/2015 15:37:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSvcEquipment_RentQuery]
		@parm1	varchar(10)
		,@parm2	varchar(10)
		,@parm3	varchar(40)
		,@parm4	varchar(10)
		,@parm5	varchar(15)
		,@parm6	varchar(1)
AS
	SELECT
		*
	FROM
		smSvcEquipment
	WHERE
		Status = 'A'
			AND
		BranchID LIKE @parm1
			AND
		ManufID LIKE @parm2
			AND
		ModelID LIKE @parm3
			AND
		SerialNbr LIKE @parm4
			AND
		AssetID LIKE @parm5
			AND
		Status LIKE @parm6
	ORDER BY
		Manufid
		,ModelID
		,EquipID
		,Status
GO
