USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[APDocPWPVendIDRefNbr]    Script Date: 12/21/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDocPWPVendIDRefNbr    Script Date: 06/7/06 ******/
Create Procedure [dbo].[APDocPWPVendIDRefNbr] @VendID varchar(15), @Doctype varchar (2),@RefNbr varchar (10) as
SELECT a.*
  FROM APDoc a JOIN Terms t
                 ON a.Terms = t.TermsID
 WHERE a.VendID = @VendID
   AND a.DocType = @Doctype
   AND a.RefNbr LIKE @RefNbr
   AND a.DocType IN ('VO','AC')
   AND t.DiscType = 'P'
   AND a.Docbal > 0
 ORDER BY VendID, DocType, RefNbr
GO
