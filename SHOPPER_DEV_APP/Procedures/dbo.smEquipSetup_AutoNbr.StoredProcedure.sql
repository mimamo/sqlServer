USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEquipSetup_AutoNbr]    Script Date: 12/21/2015 14:34:38 ******/
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
