USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJTran_Filter]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJTran_Filter]
   @Project       varchar( 16 ),
   @Task          varchar( 32 ),
   @Acct          varchar( 16 ),
   @TranDateBeg   smalldatetime,
   @TranDateEnd   smalldatetime,
   @Employee      varchar ( 10 ),
   @Vendor_Num    varchar ( 15 )

AS
   SELECT      *
   FROM        PJTran LEFT JOIN PJTranEx
               ON PJTran.FiscalNo = PJTranEx.FiscalNo and
               PJTran.System_CD = PJTranEx.System_CD and
               PJTran.Batch_ID = PJTranEx.Batch_ID and
               PJTran.Detail_Num = PJTranEx.Detail_Num
   WHERE       PJTran.Project = @Project and
               PJTran.PJT_Entity LIKE @Task and
               PJTran.Acct LIKE @Acct and
               PJTran.Trans_Date BETWEEN @TranDateBeg and @TranDateEnd and
               PJTran.Employee LIKE @Employee and
               PJTran.Vendor_Num LIKE @Vendor_Num
   ORDER BY    PJTran.Trans_Date DESC, PJTran.System_CD, PJtran.Batch_ID, PJTran.Detail_Num
GO
