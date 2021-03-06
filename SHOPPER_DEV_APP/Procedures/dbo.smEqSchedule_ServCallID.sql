USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEqSchedule_ServCallID]    Script Date: 12/16/2015 15:55:34 ******/
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
