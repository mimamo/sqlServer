USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_AssignBolNbr]    Script Date: 12/21/2015 14:17:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[EDContainer_AssignBolNbr] @BolNbr varchar(20), @CpnyId varchar(10), @ShipperId varchar(15) As
Update EDContainer Set BolNbr = @BolNbr Where CpnyId = @CpnyId And ShipperId = @ShipperId
Update EDSOShipHeader Set BOL = @BolNbr Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO
