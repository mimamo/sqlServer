USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLot_Max]    Script Date: 12/21/2015 16:07:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSOShipLot_Max] @CpnyId varchar(10), @ShipperId varchar(15), @LineRef varchar(5) As
Select Max(LotSerRef) From SOShipLot Where Cpnyid = @CpnyId And ShipperId = @ShipperId And
LineRef = @LineRef
GO
