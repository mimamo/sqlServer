USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AP_PP_Applied]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AP_PP_Applied]
	@VendId varchar(15),
	@RefNbr varchar(10)
AS
SELECT	*
FROM	apadjust j
        inner join apdoc d on d.refnbr = j.adjdrefnbr and
        d.doctype = j.adjddoctype and
        d.vendid = j.vendid
WHERE	j.adjddoctype IN ('PP')
AND	j.s4future11 <> 'V'
AND	j.vendid = @VendId
AND	j.adjdrefnbr = @RefNbr
ORDER BY j.adjdrefnbr
GO
