USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_Batch_Status]    Script Date: 12/21/2015 16:07:10 ******/
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
