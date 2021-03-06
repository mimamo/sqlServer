USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOINTran_All]    Script Date: 12/21/2015 14:18:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOINTran_All]
   @InvtID    varchar( 30 ),
   @SiteID    varchar( 10 ),
   @WhseLoc   varchar( 10 )
AS
   SELECT     *
   FROM       INTran
   WHERE      InvtID =  @InvtID and
              SiteID LIKE @SiteID and
              WhseLoc LIKE @WhseLoc
   ORDER BY   TranDate DESC, JrnlType, TranType
GO
