USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDLabelPrint_Shipper]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDLabelPrint_Shipper] @CpnyId varchar(10), @ShipperId varchar(10) As
Update EDContainer Set LabelLastPrinted = GetDate() Where CpnyId = @CpnyId And ShipperId = @ShipperId And LabelLastPrinted = '01-01-1900'
GO
