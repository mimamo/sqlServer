USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_ASNTotals]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDShipment_ASNTotals]
	@BOLNbr VarChar(30)
As
Select
	IsNull(
			(
				Select
					Count(*)
				From
					EDContainer
				Where
					EDContainer.BOLNbr = @BolNbr
					And EDContainer.TareFlag = 0
			)
			,0
	) As 'NbrOfContainers',
	IsNull(
			(
				Select
					Count(*)
				From
					EDContainer
				Where
					EDContainer.BOLNbr = @BolNbr
					And EDContainer.TareFlag = 1
			)
			,0
	) As 'NbrOfTares',
	IsNull(
			(
				Select
					Sum(QtyShip) As 'QtyShip'
				From
					EDShipTicket
					Inner Join SOShipLine On
						SOShipLine.ShipperID = EDShipTicket.ShipperID
						And SOShipLine.CpnyID = EDShipTicket.CpnyID
				Where
					EDShipTicket.BOLNbr = @BolNbr
			)
			,0
	) As 'TotNumberOfItems'
From
	EDShipment
Where
	BOLNbr = @BolNbr
GO
