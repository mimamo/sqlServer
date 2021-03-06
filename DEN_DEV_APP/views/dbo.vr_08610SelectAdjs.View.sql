USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[vr_08610SelectAdjs]    Script Date: 12/21/2015 14:05:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vr_08610SelectAdjs] AS

Select v.*,   

    gAdjAmt = g.AdjAmt, gAdjgDocDate = g.AdjgDocDate, 
    gAdjgPerPost = ISNull(g.AdjgPerPost,v.PerPost), 
    g.CuryAdjgAmt, jCuryAdjdAmt = j.CuryAdjdAmt, gCuryAdjdAmt = g.CuryAdjdAmt,

    jAdjAmt = j.AdjAmt, j.AdjDiscAmt, jAdjgDocDate = j.AdjgDocDate, 
    jAdjgPerPost = j.AdjgPerPost, j.CuryAdjdAmt, j.CuryAdjdDiscAmt,
    jPerAppl = j.perappl, gPerAppl = g.perappl,t.Descr


FROM vr_08610SelectDocs v 

Left Outer Join aradjust j on v.custid = j.custid and 

v.doctype = j.adjddoctype and v.refnbr = j.adjdrefnbr

Left Outer Join Aradjust g on v.custid = g.custid and v.refnbr = g.adjgrefnbr 
     and v.doctype = g.adjgdoctype

Left outer join terms t on v.terms = t.termsid

where 
((v.doctype = g.adjgdoctype or g.adjgdoctype is null or 
(v.doctype <> g.adjgdoctype and g.adjgdoctype in ('RP', 'NS', 'NC', 'SB')))
And v.DocType <> "RP")
GO
