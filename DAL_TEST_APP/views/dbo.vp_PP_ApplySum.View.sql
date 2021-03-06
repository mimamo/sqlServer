USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[vp_PP_ApplySum]    Script Date: 12/21/2015 13:56:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vp_PP_ApplySum] AS 

select  Batnbr=(d.batnbr),
	AdjBatnbr=min(j2.adjbatnbr),
	Adjdrefnbr =min(j.adjdrefnbr),
	Adjddoctype = min(j.adjddoctype), 
	AdjAmt=sum( convert(dec(28,3),j2.AdjAmt) + convert(dec(28,3),j2.curyrgolamt)),
	CuryAdjdAmt=sum( convert(dec(28,3),j2.CuryAdjdAmt) ),
	CuryAdjgAmt=sum( convert(dec(28,3),j2.CuryAdjgAmt)),
	UserAddress = w.UserAddress
FROM WrkRelease w inner loop join APDoc d
ON w.batnbr = d.batnbr 
inner join APAdjust j
on d.PrePay_RefNbr = j.AdjdRefNbr AND j.AdjdDocType = 'PP'
inner join APAdjust j2 
on j2.adjdrefnbr = d.refnbr AND j2.adjddoctype = d.doctype AND
	j.adjbatnbr = j2.adjbatnbr
WHERE d.doctype in ('VO', 'AC') and w.Module = 'AP' 
group by w.UserAddress,d.batnbr,d.prepay_refnbr
GO
