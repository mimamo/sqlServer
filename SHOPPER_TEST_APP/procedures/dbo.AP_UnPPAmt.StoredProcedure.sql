USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AP_UnPPAmt]    Script Date: 12/21/2015 16:06:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AP_UnPPAmt]
	@PPRefNbr AS varchar(10),
	@VORefNbr AS varchar(10)
AS

select isnull(sum(c.curyadjdamt),0)
from apadjust c
inner join apdoc d on d.refnbr = c.adjdrefnbr and d.doctype = c.adjddoctype
inner join apadjust a on a.adjgrefnbr = c.adjgrefnbr
and a.adjddoctype = 'PP' and a.AdjgAcct = c.AdjgAcct and a.AdjgSub = c.AdjgSub
where c.adjdrefnbr = @VORefNbr and a.adjdrefnbr = @PPRefNbr
GO
