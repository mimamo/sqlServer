USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipline_QtyShpOnTare]    Script Date: 12/21/2015 16:07:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[EDSOShipline_QtyShpOnTare] @CpnyId varchar(10), @ShipperId varchar(15), @TareId varchar(10), @LineRef varchar(5)
As
--Sums the qtyshipped on the container detail records for specified lineitem.
	Select ISNULL(SUM(A.QtyShipped),0)  -- a.qtyshipped
	From EDContainerDet A Join EDContainer B on A.ContainerID = B.ContainerID
	Where 	B.CpnyID = @CpnyID And
		B.ShipperID = @ShipperID And
		B.TareID = @TareID And
		A.LineRef = @LineRef
GO
