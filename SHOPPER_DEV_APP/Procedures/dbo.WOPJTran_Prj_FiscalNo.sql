USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJTran_Prj_FiscalNo]    Script Date: 12/16/2015 15:55:37 ******/
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
