USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOLotSerMst_LotSerNbr_RcptDate]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[WOLotSerMst_LotSerNbr_RcptDate]
   @InvtID          varchar (30),
   @SiteID          varchar (10),
   @WhseLoc         varchar (10),
	@Today			smallDateTime
AS
   Select           *
   FROM             LotSerMst
   WHERE            InvtId = @InvtID and
                    SiteId = @SiteID and
                    WhseLoc = @WhseLoc and
                    (QtyOnHand - QtyAlloc - QtyShipNotInv - QtyWORlsedDemand) > 0 AND
					Status = 'A' AND
                                        (expDate >= @Today or expDate = '01/01/1900')
   ORDER BY         Rcptdate, LotSerNbr
GO
