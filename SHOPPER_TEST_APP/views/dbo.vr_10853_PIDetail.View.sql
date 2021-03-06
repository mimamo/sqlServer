USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[vr_10853_PIDetail]    Script Date: 12/21/2015 16:06:44 ******/
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
