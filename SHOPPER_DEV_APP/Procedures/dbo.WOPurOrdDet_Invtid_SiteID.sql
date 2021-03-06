USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPurOrdDet_Invtid_SiteID]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPurOrdDet_Invtid_SiteID]
   @InvtID     varchar( 30 ),
   @SiteID     varchar( 10 )
AS
   SELECT      *
   FROM        PurOrdDet
   WHERE       PurOrdDet.InvtID = @InvtID and
               PurOrdDet.SiteID LIKE @SiteID
   ORDER BY    PurOrdDet.PONbr DESC, PurOrdDet.LineNbr
GO
