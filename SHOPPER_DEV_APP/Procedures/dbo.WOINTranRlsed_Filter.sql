USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOINTranRlsed_Filter]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOINTranRlsed_Filter]
   @InvtID        varchar( 30 ),
   @SiteID        varchar( 10 ),
   @WhseLoc       varchar( 10 ),
   @TranDateBeg   smalldatetime,
   @TranDateEnd   smalldatetime,
   @ID            varchar( 15 ),
   @JrnlType      varchar( 3 ),
   @TranType       varchar( 2 ),
   @SpecificCostID varchar( 25 )
AS
   SELECT      *
   FROM        INTran

   WHERE       InvtID = @InvtID and
               SiteID LIKE @SiteID and
               WhseLoc LIKE @WhseLoc and
               TranDate BETWEEN @TranDateBeg and @TranDateEnd and
               ID LIKE @ID and
               JrnlType LIKE @JrnlType and
               TranType LIKE @TranType and
               SpecificCostID LIKE @SpecificCostID and
               Rlsed = 1
   ORDER BY    TranDate DESC, JrnlType, TranType
GO
