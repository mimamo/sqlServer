USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_Upd_Via]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOShipHeader_Upd_Via] @BolNbr varchar(20), @ShipViaID varchar(15), @ShipDateAct  smalldatetime as
--Old proc from 2.52 Solomon
--Create Proc XEDIPKTicket_Upd_Via @parm1,@parm2,@parm3 as
--Update XEDIPKTicket, XEShipTicket Set XEDIPKTicket.ViaAct = @parm2, XEDIPKTicket.ShipDate = @parm3
--where XEShipTicket.BOLNbr = @parm1 and XEShipTicket.RefNbr = XEDIPKTicket.PickTicketNbr and XEDIPKTicket.Status <> 'P';
update SOShipHeader set SOShipHeader.ShipViaID = @ShipViaID, SOShipHeader.ShipDateAct = @ShipDateAct
From SOShipHeader, EDShipTicket
where EDShipTicket.BolNbr = @BolNbr
and EDShipTicket.ShipperID = SOShipHeader.ShipperID
and EDShipTicket.CpnyID = SOShipHeader.CpnyID
GO
