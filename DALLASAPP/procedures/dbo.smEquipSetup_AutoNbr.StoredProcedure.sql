USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smEquipSetup_AutoNbr]    Script Date: 12/21/2015 13:45:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smEquipSetup_AutoNbr]
AS
	SELECT
		LastEquipmentNbr
	FROM
		smEquipSetup
GO
