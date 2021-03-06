USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOKit_Site]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOKit_Site]
   @KitID      varchar( 30 ),
   @SiteID     varchar( 10 )
AS
   SELECT      *
   FROM        Kit
   WHERE       KitID LIKE @KitID and
               SiteID LIKE @SiteID and
               Status = 'A'
   ORDER BY    KitID, SiteID, Status
GO
