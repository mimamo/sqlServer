USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_Batch_Status]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCVoucher_Batch_Status]
	@BatchNbr varchar( 10 )
	AS
	SELECT count(*)
	FROM Batch
	WHERE BatNbr = @BatchNbr
	and module = 'AP'
	and status IN ('U', 'P', 'V')
GO
