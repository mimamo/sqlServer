USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCReceipt_Unprocessed_TranCount]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCReceipt_Unprocessed_TranCount]
	@ReceiptNbr varchar( 10 )
	AS
	SELECT 	Count(*)
	FROM 	LCReceipt
	WHERE 	rcptNbr = @ReceiptNbr
	AND 	transtatus = 'U'
GO
