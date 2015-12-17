USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_Unprocessed_TranCount]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCVoucher_Unprocessed_TranCount]
	@cpnyid		VARCHAR(10),
	@apbatnbr	VARCHAR(10),
	@aplineref	CHAR(5),
	@aprefnbr	VARCHAR(10)
AS
	SELECT 	Count(*)
	FROM 	LCVoucher
	WHERE 	cpnyid = @cpnyid
	and 	apbatnbr = @apbatnbr
	and 	aplineref = @aplineref
	and	aprefnbr = @aprefnbr
	AND 	transtatus = 'U'
GO
