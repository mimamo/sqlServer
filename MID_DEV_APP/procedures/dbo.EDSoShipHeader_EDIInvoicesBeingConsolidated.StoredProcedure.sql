USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSoShipHeader_EDIInvoicesBeingConsolidated]    Script Date: 12/21/2015 14:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSoShipHeader_EDIInvoicesBeingConsolidated]
        @ShipRegisterId varchar(10),
        @InvcNbr varchar(15),
	@CpnyID varchar(10),
	@CustID varchar(15),
        @CustOrdNbr varchar(25),
	@ShipToID varchar(10),
	@ShipViaID varchar(15)
AS
SELECT s.CpnyID, s.CustID, s.CustOrdNbr, s.FOBID, s.InvcNbr,
       s.NoteID, s.OrdNbr, s.ShipperID, s.TotMerch
  FROM soshipheader s INNER JOIN edsoshipheader e
                       ON s.cpnyid = e.cpnyid
                      AND s.shipperid = e.shipperid
 WHERE s.ShipRegisterId = @ShipRegisterId
   AND s.InvcNbr = @InvcNbr
   AND s.Custid = @Custid
   AND s.CpnyID = @CpnyID
   AND s.CustOrdNbr = @CustOrdNbr
   AND s.ShipToID = @ShipToID
   AND s.ShipViaID = @ShipViaID
   AND EDI810 <> 0
   AND e.lastedidate = '1/1/1900'
   AND s.Cancelled = 0
   AND s.ConSolInv = 1
   AND Exists (SELECT *
                 FROM EDOutbound
                WHERE EDOutbound.CustId = s.CustId
                  AND EDOutbound.Trans In ('810','880'))
GO
