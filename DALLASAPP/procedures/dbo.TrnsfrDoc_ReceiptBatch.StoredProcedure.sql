USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[TrnsfrDoc_ReceiptBatch]    Script Date: 12/21/2015 13:45:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[TrnsfrDoc_ReceiptBatch]
    @ReceiptBatNbr varchar ( 10) as
Select * from TrnsfrDoc
    where S4Future11 = @ReceiptBatNbr
GO
