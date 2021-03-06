USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[IsDropShipAutoCreate]    Script Date: 12/21/2015 15:42:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[IsDropShipAutoCreate] @InTranRecordID int As
  --To find out if the Sales Order was drop ship and auto create PO

  SELECT CASE WHEN (SOLine.DropShip = 1 and SOLine.AutoPO = 1)
              THEN convert(SmallInt, 1)
              ELSE convert(SmallInt, 0)
         END

    FROM InTran T JOIN SOShipLine SL
                    ON T.shipperid = SL.shipperid
                   and T.shipperlineref = SL.lineref
                  JOIN SOLine
                    ON SOLine.LineRef = SL.OrdLineRef
                   and SOLine.OrdNbr = SL.OrdNbr
   WHERE T.Recordid =  @InTranRecordID
GO
