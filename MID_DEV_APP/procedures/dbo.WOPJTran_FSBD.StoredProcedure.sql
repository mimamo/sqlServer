USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJTran_FSBD]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJTran_FSBD]
   @FiscalNo   varchar( 6 ),
   @System_CD  varchar( 2 ),
   @Batch_ID   varchar( 10 ),
   @Detail_Num    int

AS
   SELECT      *
   FROM     PJTran
   WHERE    FiscalNo = @FiscalNo and
            System_CD = @System_CD and
            Batch_ID = @Batch_ID and
            Detail_Num = @Detail_Num
   ORDER BY FiscalNo, System_CD, Batch_ID, Detail_Num
GO
