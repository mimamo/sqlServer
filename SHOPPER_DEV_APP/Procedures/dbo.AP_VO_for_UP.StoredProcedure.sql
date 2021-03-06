USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AP_VO_for_UP]    Script Date: 12/21/2015 14:34:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AP_VO_for_UP]
	@VendId varchar(15),
	@CuryId varchar(4),
	@RefNbr varchar(10)
AS

SELECT	*
FROM	APDoc
WHERE	Status='A'
AND	VendID LIKE @VendID
AND	CuryId LIKE @CuryId
AND	Rlsed=1
AND	RefNbr LIKE @RefNbr
AND	DocType='VO'
AND	LTRIM(PrePay_RefNbr) <>''
ORDER BY RefNbr
GO
