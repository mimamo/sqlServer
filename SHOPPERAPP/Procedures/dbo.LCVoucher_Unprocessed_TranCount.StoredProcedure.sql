USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_Unprocessed_TranCount]    Script Date: 12/21/2015 16:13:15 ******/
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
