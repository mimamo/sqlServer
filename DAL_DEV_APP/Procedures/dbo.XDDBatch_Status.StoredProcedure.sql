USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_Status]    Script Date: 12/21/2015 13:36:00 ******/
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
