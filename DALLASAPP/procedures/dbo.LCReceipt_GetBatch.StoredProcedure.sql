USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[LCReceipt_GetBatch]    Script Date: 12/21/2015 13:44:57 ******/
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
