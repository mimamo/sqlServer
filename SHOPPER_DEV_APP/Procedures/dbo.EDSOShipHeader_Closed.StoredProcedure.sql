USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_Closed]    Script Date: 12/21/2015 14:34:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOShipHeader_Closed] @CpnyId varchar(10), @ShipperId varchar(15) As
Select * From SOShipHeader Where CpnyId = @CpnyId And ShipperId Like @ShipperId
And Status = 'C' And Cancelled = 0 Order By CpnyId, ShipperId
GO
