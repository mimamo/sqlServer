USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEquipment_Avail]    Script Date: 12/21/2015 13:57:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smEquipment_Avail]
	@sd smalldatetime
	,@ed smalldatetime
	,@st char(4)
	,@et char(4)
AS
SELECT *
FROM smEquipment
	left outer join smEqSchedule
		on smEquipment.EquipmentID = smEqSchedule.EquipmentID
WHERE (EqEndDate < @sd
	OR
	EqStartDate > @ed
	OR
	EqEndTime <= @st
	OR
	EqStartTime >= @et)
ORDER BY smEquipment.EquipmentID
GO
