USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDCurrency_CuryID_Class]    Script Date: 12/21/2015 16:07:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDCurrency_CuryID_Class]
	@CuryID		varchar(4)
AS
	SELECT		DecPl,
			Descr
	FROM		Currncy (nolock)
	WHERE		CuryID = @CuryID
GO
