USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipline_CpnyShipCntr]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDSOShipline_CpnyShipCntr] @CpnyId varchar(10), @ShipperId varchar(15), @ContainerID varchar(10)
As
--Select line information for a single container (w/out container info)
	Select *
	From SOShipLine
	Where 	CpnyID = @CpnyId And
		ShipperId = @ShipperId And
 		LineRef in (Select LineRef From EDContainerDet
             			Where	CpnyID = @CpnyID And
                   			ShipperID = @ShipperID And
                   			ContainerID = @ContainerID
	     			)--end select from edcontainerdet
GO
