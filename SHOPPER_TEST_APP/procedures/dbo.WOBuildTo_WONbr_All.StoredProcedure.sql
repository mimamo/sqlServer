USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOBuildTo_WONbr_All]    Script Date: 12/21/2015 16:07:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOBuildTo_WONbr_All]
   @WONbr       varchar( 16 ),
   @Status      varchar( 1 ),
   @LineNbrbeg  smallint,
   @LineNbrend  smallint
AS
   SELECT       *
   FROM         WOBuildTo LEFT JOIN Inventory
                ON WOBuildTo.InvtID = Inventory.InvtID
   WHERE        WOBuildTo.WONbr = @WONbr and
                WOBuildTo.Status LIKE @Status and
                WOBuildTo.LineNbr Between @LineNbrbeg and @LineNbrend
   ORDER BY     WOBuildTo.WONbr, WOBuildTo.Status, WOBuildTo.LineNbr
GO
