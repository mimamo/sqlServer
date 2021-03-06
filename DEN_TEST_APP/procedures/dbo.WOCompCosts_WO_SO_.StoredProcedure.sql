USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOCompCosts_WO_SO_]    Script Date: 12/21/2015 15:37:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOCompCosts_WO_SO_]
   @WONbr      varchar( 16 ),
   @OrdNbr     varchar( 15 ),
   @InvtID     varchar( 30 ),
   @SiteID     varchar( 10 )
AS
   SELECT      *
   FROM        WOSOCompCost
   WHERE       WONbr = @WONbr and
               OrdNbr = @OrdNbr and
               InvtID = @InvtID and
               SiteID = @SiteID
   ORDER BY    WONbr, OrdNbr, InvtID, SiteID, LineNbr DESC
GO
