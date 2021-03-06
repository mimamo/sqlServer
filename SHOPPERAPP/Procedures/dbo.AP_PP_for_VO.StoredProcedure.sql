USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[AP_PP_for_VO]    Script Date: 12/21/2015 16:13:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AP_PP_for_VO]
	@CuryId varchar(4),
	@VendId varchar(15),
	@RefNbr varchar(10)
AS
SELECT	j.*
FROM	apadjust j, apdoc d
WHERE	j.adjddoctype = d.doctype
AND	d.refnbr = j.AdjdRefNbr
AND	j.vendid = d.vendid
AND	CuryId LIKE @CuryId
AND	j.adjddoctype IN ('PP')
AND	j.AdjAmt > 0
AND	d.docbal <> d.origdocamt
AND	j.s4future11 <> 'V'
AND	j.vendid = @VendId
AND	j.adjdrefnbr like @RefNbr
ORDER BY j.adjdrefnbr
GO
