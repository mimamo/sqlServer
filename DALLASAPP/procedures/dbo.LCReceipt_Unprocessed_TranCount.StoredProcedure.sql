USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[LCReceipt_Unprocessed_TranCount]    Script Date: 12/21/2015 13:44:57 ******/
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
