USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LoadAlloc_smServDetail]    Script Date: 12/21/2015 14:34:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_LoadAlloc_smServDetail]
	@ServiceCallID		Varchar(10)
As

SELECT	SPACE(5), smServDetail.InvtID, smServDetail.SiteID, smServDetail.WhseLoc, smServDetail.LotSerialRep,
	smServDetail.Quantity, COALESCE(u1.CnvFact, u2.CnvFact, u3.CnvFact, 1), COALESCE(u1.MultDiv, u2.MultDiv, u3.MultDiv, 'M')
	FROM	smServDetail (NOLOCK)
	JOIN	Inventory (NOLOCK) ON smServDetail.InvtID = Inventory.InvtID
	LEFT JOIN INUnit u1 (NOLOCK) ON
		u1.FromUnit = Inventory.DfltSOUnit
		AND u1.ToUnit = Inventory.StkUnit
		AND u1.UnitType = '3'
		AND u1.InvtID = Inventory.InvtID
	LEFT JOIN INUnit u2 (NOLOCK) ON
		u2.FromUnit = Inventory.DfltSOUnit
		AND u2.ToUnit = Inventory.StkUnit
		AND u2.UnitType = '2'
		AND u2.ClassID = Inventory.ClassID
	LEFT JOIN INUnit u3 (NOLOCK) ON
		u3.FromUnit = Inventory.DfltSOUnit
		AND u3.ToUnit = Inventory.StkUnit
		AND u3.UnitType = '1'
	WHERE	smServDetail.ServiceCallID = @ServiceCallID
		AND smServDetail.Quantity > 0
GO
