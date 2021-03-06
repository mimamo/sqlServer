USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPurOrdDet_PurchOrd]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPurOrdDet_PurchOrd]
   @InvtID     varchar( 30 ),
   @SiteID     varchar( 10 )
AS
   SELECT      *
   FROM        PurOrdDet LEFT JOIN PurchOrd
               ON PurOrdDet.PONbr = PurchOrd.PONbr
   WHERE       PurOrdDet.InvtID = @InvtID and
               PurOrdDet.SiteID LIKE @SiteID
   ORDER BY    PurOrdDet.PONbr DESC, PurOrdDet.LineNbr
GO
