USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOItemCost_InvtID_SiteID]    Script Date: 12/21/2015 15:37:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOItemCost_InvtID_SiteID]
   @InvtID     varchar( 30 ),
   @SiteID     varchar( 10 )
AS
   SELECT      *
   FROM        ItemCost
   WHERE       InvtID = @InvtID and
               SiteID LIKE @SiteID
   ORDER BY    InvtID, SiteID, SpecificCostID, RcptNbr, RcptDate
GO
