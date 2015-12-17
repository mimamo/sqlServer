USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_SetLabelPrinted]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_SetLabelPrinted] @CpnyId varchar(10), @ShipperId varchar(15), @ContainerId varchar(10), @TrackingNbr varchar(30), @LabelLastPrinted smalldatetime As
Update EDContainer Set LabelLastPrinted = @LabelLastPrinted, TrackingNbr = @TrackingNbr Where
CpnyId = @CpnyId And ShipperId = @ShipperId And ContainerId = @ContainerId
GO
