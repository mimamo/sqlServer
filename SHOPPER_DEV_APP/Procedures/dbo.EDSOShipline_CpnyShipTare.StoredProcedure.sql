USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipline_CpnyShipTare]    Script Date: 12/21/2015 14:34:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[EDSOShipline_CpnyShipTare] @CpnyId varchar(10), @ShipperId varchar(15), @TareId varchar(10)
As
--Select line information for a single tare (w/out container info)
	Select *
	From SOShipLine
	Where 	CpnyID = @CpnyId And
		ShipperId = @ShipperId And
 		LineRef in (Select LineRef From EDContainerDet
				Where ContainerID in (Select ContainerID From EDContainer
                    					Where 	CpnyID = @CpnyID And
                          					ShipperID = @ShipperID And
                          					TareFlag = 0 And
                          					TareID = @TareID
                     					)--end select from edcontainer
	     			)--end select from edcontainerdet
GO
