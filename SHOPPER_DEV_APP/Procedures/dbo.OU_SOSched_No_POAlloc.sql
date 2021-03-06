USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[OU_SOSched_No_POAlloc]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[OU_SOSched_No_POAlloc]
	@CpnyID		VarChar(10),
	@OrdNbr		VarChar(15)
As
	Select	*
		From	SOSched (NoLock)
		Where	CpnyID = @CpnyID
			And OrdNbr = @OrdNbr
			And AutoPO = 1 AND
			NOT EXISTS	(SELECT * FROM POAlloc
					 WHERE 	POAlloc.SOOrdNbr = SOSched.OrdNbr AND
						POAlloc.SOLineRef = SOSched.LineRef AND
						POAlloc.SOSchedRef = SOSched.SchedRef)

		ORDER BY AutoPOVendID, DropShip, ShipViaID,
			 ShipCustID, ShiptoID, ShipSiteID,
			 ShipVendID, S4Future11, ShipAddrID
GO
