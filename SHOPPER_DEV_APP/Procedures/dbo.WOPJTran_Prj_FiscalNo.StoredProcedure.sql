USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJTran_Prj_FiscalNo]    Script Date: 12/21/2015 14:34:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJTran_Prj_FiscalNo]
   @Project    varchar( 16 ),
   @FiscalNo   varchar( 6 )

AS
   SELECT      *
   FROM        PJTran
   WHERE       Project = @Project and
               FiscalNo = @FiscalNo and
               Batch_Type <> 'ALLC' and
               Alloc_Flag = ' '
   ORDER BY    Project, PJT_Entity, Acct, Trans_Date
GO
