USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Multiple_InstallmentDocs]    Script Date: 12/21/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[Multiple_InstallmentDocs] @parm1 varchar ( 6) as
       Select d.Batnbr, d.custid, d.Doctype, d.Refnbr, d.Terms
         From ARDoc d, terms t
           Where d.Batnbr = @parm1
             and d.Terms = t.termsid
             and t.termstype = 'M'

 order by  BatNbr, custid, Doctype, refnbr
GO
