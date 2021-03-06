USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[OU_SOSched_All]    Script Date: 12/21/2015 16:07:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[OU_SOSched_All]
	@CpnyID		VarChar(10),
	@OrdNbr		VarChar(15)
As
	Select	*
		From	SOSched (NoLock)
		Where	CpnyID = @CpnyID
			And OrdNbr = @OrdNbr
			And AutoPO = 1
		ORDER BY AutoPOVendID, DropShip, ShipViaID,
			 ShipCustID, ShiptoID, ShipSiteID,
			 ShipVendID, S4Future11, ShipAddrID
GO
