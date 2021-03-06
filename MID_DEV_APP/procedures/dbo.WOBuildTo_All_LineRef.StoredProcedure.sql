USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOBuildTo_All_LineRef]    Script Date: 12/21/2015 14:18:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOBuildTo_All_LineRef]
   @WONbr      varchar( 16 ),
   @Status     varchar( 1 ),
   @LineRef    varchar( 5 )
AS
   SELECT      *
   FROM        WOBuildTo
   WHERE       WONbr = @WONbr and
               Status LIKE @Status and
               LineRef LIKE @LineRef
   ORDER BY    WONbr, Status, LineRef
GO
