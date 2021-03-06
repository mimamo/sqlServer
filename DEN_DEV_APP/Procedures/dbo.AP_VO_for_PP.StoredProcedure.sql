USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AP_VO_for_PP]    Script Date: 12/21/2015 14:05:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AP_VO_for_PP]
	@VendId varchar(15),
	@CuryId varchar(4),
	@RefNbr varchar(10)
AS

SELECT	*
FROM	APDoc d
WHERE	d.status='A'
AND	VendID LIKE @VendID and d.RefNbr LIKE @RefNbr and DocType in ('VO','AC')
AND	LTRIM(PrePay_RefNbr) = ''
AND	d.DocBal>0
AND	d.rlsed = 1
AND	d.CuryId LIKE @CuryId
ORDER BY d.RefNbr
GO
