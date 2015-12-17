USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOLocation_InvtID_Site_WhseLoc]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOLocation_InvtID_Site_WhseLoc]
   @InvtID     varchar( 30 ),
   @SiteID     varchar( 10 ),
   @WhseLoc    varchar( 10 )
AS
   SELECT      *
   FROM        Location
   WHERE       InvtID = @InvtID and
               SiteID = @SiteID and
               WhseLoc LIKE @WhseLoc
   ORDER BY    InvtID, SiteID, WhseLoc
GO
