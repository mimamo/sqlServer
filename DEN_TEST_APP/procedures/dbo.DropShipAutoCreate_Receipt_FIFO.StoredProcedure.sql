USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DropShipAutoCreate_Receipt_FIFO]    Script Date: 12/21/2015 15:36:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DropShipAutoCreate_Receipt_FIFO] @InTranRecordID int As
  --Get the receipt number for the Receipt tied to the Sales Order where Sales Order is drop ship and auto create PO

  SELECT IC.*
    FROM InTran T JOIN SOShipLine SL
                    ON T.CpnyID = SL.CpnyID
                   and T.ShipperID = SL.ShipperID
                   and T.Shipperlineref = SL.LineRef
                JOIN POTranAlloc PTA
                    on SL.CpnyID = PTA.CpnyID
                   and SL.OrdNbr = PTA.SOOrdnbr
                   and SL.OrdLineRef = PTA.SOLineRef
                  JOIN POTran PT
                    on PT.RcptNbr = PTA.RcptNbr
                   and PT.LineRef = PTA.POTranLineRef
                  JOIN ItemCost IC
                    on T.Invtid = IC.InvtID
                   and T.SiteID = IC.SiteID
                   and T.LayerType = IC.LayerType
                   and PT.RcptNbr = IC.RcptNbr
                   and PT.RcptDate = IC.RcptDate
   WHERE T.Recordid = @InTranRecordID
   Order By PT.RcptDate, PT.RcptNbr
GO
