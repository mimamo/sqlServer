USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOBuildTo_All]    Script Date: 12/21/2015 14:18:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOBuildTo_All]
   @WONbr      varchar( 16 ),
   @Status     varchar( 1 )
AS
   SELECT      *
   FROM        WOBuildTo
   WHERE       WONbr = @WONbr and
               Status LIKE @Status
   ORDER BY    WONbr, Status, LineNbr
GO
