USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipline_QtyShpOnCntr]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[EDSOShipline_QtyShpOnCntr] @CpnyId varchar(10), @ShipperId varchar(15), @ContainerId varchar(10), @LineRef varchar(5)
As
--Sums the qtyshipped on the container detail records for specified lineitem.
	Select ISNULL(SUM(A.QtyShipped),0)  -- a.qtyshipped
	From EDContainerDet A Join EDContainer B on A.ContainerID = B.ContainerID
	Where 	B.CpnyID = @CpnyID And
		B.ShipperID = @ShipperID And
		B.ContainerID = @ContainerID And
      		A.LineRef = @LineRef
GO
