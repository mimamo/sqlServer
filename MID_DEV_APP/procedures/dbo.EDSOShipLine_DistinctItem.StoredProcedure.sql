USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLine_DistinctItem]    Script Date: 12/21/2015 14:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOShipLine_DistinctItem] @CpnyId varchar(10), @ShipperId varchar(15) As
Select Distinct InvtId From SOShipLine Where CpnyId = @CpnyId And ShipperId = @ShipperId
Order By InvtId
GO
