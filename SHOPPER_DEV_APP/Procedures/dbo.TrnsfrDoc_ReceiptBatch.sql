USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TrnsfrDoc_ReceiptBatch]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[TrnsfrDoc_ReceiptBatch]
    @ReceiptBatNbr varchar ( 10) as
Select * from TrnsfrDoc
    where S4Future11 = @ReceiptBatNbr
GO
