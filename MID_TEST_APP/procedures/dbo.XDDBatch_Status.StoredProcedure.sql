USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_Status]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_Status]
	@BatNbr		varchar(10)
AS
	SELECT		*
	FROM		Batch (nolock)
	WHERE		Module = 'AR'
			and BatNbr = @BatNbr
GO
