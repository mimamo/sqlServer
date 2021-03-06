USE [DENVERAPP]
GO
/****** Object:  View [dbo].[vr_10853_PIDetail]    Script Date: 12/21/2015 15:42:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vr_10853_PIDetail]

 AS

	SELECT 	PIDetail.*,
		CostPIID =
			CASE WHEN EXISTS(SELECT * FROM Inventory WHERE Inventory.InvtID = PIDetail.InvtID AND Inventory.ValMthd = 'S') THEN
			PIDetail.PIID ELSE
			NULL END
	FROM
		PIDetail
GO
