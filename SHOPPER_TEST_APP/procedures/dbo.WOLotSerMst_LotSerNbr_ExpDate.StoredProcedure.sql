USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOLotSerMst_LotSerNbr_ExpDate]    Script Date: 12/21/2015 16:07:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[WOLotSerMst_LotSerNbr_ExpDate]
   @InvtID          varchar (30),
   @SiteID          varchar (10),
   @WhseLoc         varchar (10),
	@Today			smalldatetime
AS
   Select           *
   FROM             LotSerMst
   WHERE            InvtId = @InvtID and
                    SiteId = @SiteID and
                    WhseLoc = @WhseLoc and
                    (QtyOnHand - QtyAlloc - QtyShipNotInv - QtyWORlsedDemand) > 0 AND
					Status = 'A' AND
					expDate >= @Today
   ORDER BY         Expdate, LotSerNbr
GO
