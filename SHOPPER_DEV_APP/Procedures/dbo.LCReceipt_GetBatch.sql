USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCReceipt_GetBatch]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LCReceipt_GetBatch]
	@RcptNbr varchar(15)
as
Select * FROM Batch
WHERE
	batnbr = (Select Batnbr from poreceipt
			WHERE RcptNbr = @RcptNbr)
GO
