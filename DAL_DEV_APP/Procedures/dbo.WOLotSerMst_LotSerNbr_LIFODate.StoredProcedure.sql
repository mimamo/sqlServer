USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOLotSerMst_LotSerNbr_LIFODate]    Script Date: 12/21/2015 13:35:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create Proc [dbo].[WOLotSerMst_LotSerNbr_LIFODate]
   @InvtID          varchar (30),
   @SiteID          varchar (10),
   @WhseLoc         varchar (10),
   @Today           smalldatetime
AS
   Select           *
   FROM             LotSerMst
   WHERE            InvtId = @InvtID and
                    SiteId = @SiteID and
                    WhseLoc = @WhseLoc and
                    (QtyOnHand - QtyAlloc - QtyShipNotInv - QtyWORlsedDemand) > 0 AND
					Status = 'A' AND
                    (expDate >= @Today or expDate = '01/01/1900')

   ORDER BY         LIFOdate desc, LotSerNbr desc
GO
