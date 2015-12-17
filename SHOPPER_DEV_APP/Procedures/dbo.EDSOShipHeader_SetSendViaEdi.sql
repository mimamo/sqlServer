USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_SetSendViaEdi]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSOShipHeader_SetSendViaEdi] @ShipperId varchar(15), @CpnyId varchar(10) AS

Declare @SendViaEDI smallint
Declare @CustId varchar(15)

Select @CustId = Custid from SOShipHeader where ShipperId = @ShipperId and CpnyId = @CpnyId

Select @SendViaEDI = 0

Select @SendViaEDI = Count(*) from EDOutbound where CustId = @CustId and Trans in ('810','880')

Update EDSOShipHeader set SendViaEDI = @SendViaEDI where ShipperId = @ShipperId and CpnyId = @CpnyId
GO
