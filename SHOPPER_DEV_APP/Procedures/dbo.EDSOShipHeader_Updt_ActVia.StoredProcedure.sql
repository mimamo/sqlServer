USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_Updt_ActVia]    Script Date: 12/21/2015 14:34:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOShipHeader_Updt_ActVia] @BolNbr varchar(20), @ShipViaID varchar(15) as
--Old proc from 2.52 Solomon
--Create Procedure XEContainer_Updt_ActVia @parm1, @parm2 As
--Update XEdiPkTicket Set A.ViaAct = @parm2 From XEdiPkTicket A, XEShipTicket B
--Where A.PickTicketNbr = B.RefNbr And B.BolNbr = @parm1 And B.ModType = 'PT';
update SOShipHeader set SOShipHeader.ShipViaID = @ShipViaID
From SOShipHeader, EDShipTicket
where EDShipTicket.BolNbr = @BolNbr
and EDShipTicket.ShipperID = SOShipHeader.ShipperID
and EDShipTicket.CpnyID = SOShipHeader.CpnyID
GO
