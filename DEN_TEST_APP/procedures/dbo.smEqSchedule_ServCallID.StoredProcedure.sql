USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEqSchedule_ServCallID]    Script Date: 12/21/2015 15:37:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smEqSchedule_ServCallID]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smEqSchedule
	left outer join smEquipment
		on smEqSchedule.EquipmentID = smEquipment.EquipmentID
WHERE smEqSchedule.ServiceCallID = @parm1
	AND smEqSchedule.EquipmentID LIKE @parm2
ORDER BY smEqSchedule.ServiceCallID
	,smEqSchedule.EquipmentID
GO
