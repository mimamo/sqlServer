USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOBuildTo_High_LineNbr]    Script Date: 12/21/2015 13:35:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOBuildTo_High_LineNbr]
   @WONbr       varchar( 16 ),
   @Status      varchar( 1 )
AS
   SELECT TOP 1 LineNbr
   FROM         WOBuildTo
   WHERE        WONbr = @WONbr
   		and Status = @Status
   ORDER BY     WONbr, Status, LineNbr DESC
GO
