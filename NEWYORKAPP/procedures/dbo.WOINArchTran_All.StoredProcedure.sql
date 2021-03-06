USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOINArchTran_All]    Script Date: 12/21/2015 16:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOINArchTran_All]
   @InvtID    varchar( 30 ),
   @SiteID    varchar( 10 ),
   @WhseLoc   varchar( 10 )
AS
   SELECT     *
   FROM       INArchTran
   WHERE      InvtID =  @InvtID and
              SiteID LIKE @SiteID and
              WhseLoc LIKE @WhseLoc
   ORDER BY   TranDate DESC, JrnlType, TranType
GO
