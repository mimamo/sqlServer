USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDBOLUpdate]    Script Date: 12/21/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDBOLUpdate] (@BOLNbr varchar(20)) AS
/* Returns 0 if everything is OK; 1 if shipment is not in open state; 2 if carrier is TL;
   3 if carrier is LTL but there is more than shipper on the BOL */
Declare @OkToSend smallint
Declare @NotOnHold varchar(1)
Declare @ShipperCount int
Declare @SendASN smallint
Declare @CarrierType varchar(3)
Declare @ShipViaId varchar(15)
Set @OkToSend = 0
--Only process this BOL if it is not on Hold or Staged
Select @NotOnHold = BOLState, @SendASN = SendASN, @ShipViaId = ViaCode from EDShipment where BOLNbr = @BOLNbr
If @NotOnHold <> 'O' Or @SendAsn = 0
  Begin
    Set @OkToSend = 1
    Goto ExitProc
End
 Select @CarrierType = IsNull(B.CarrierType,'LTL') From ShipVia A, Carrier B Where A.ShipViaId = @ShipViaId And A.CarrierId = B.CarrierId
If @CarrierType = 'TL'
  Begin
    Set @OkToSend = 2
    Goto ExitProc
End
Select @ShipperCount = Count(*) From EDShipTicket Where BOLNbr = @BOLNbr
If @ShipperCount <> 1
  Begin
    Set @OkToSend = 3
End
ExitProc:
Select @OkToSend
GO
