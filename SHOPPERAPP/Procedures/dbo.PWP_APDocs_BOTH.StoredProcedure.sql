USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PWP_APDocs_BOTH]    Script Date: 12/21/2015 16:13:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PWP_APDocs_BOTH    Script Date: 06/7/06 ******/
Create Procedure [dbo].[PWP_APDocs_BOTH] @VendID varchar(15), @RefNbr varchar (10), @SubContract varchar (16),
                                 @ProjectID varchar(16) as

SELECT a.*, CASE WHEN l.VendID IS NULL Then 0 Else 1 END APLINKED
  FROM APDoc a JOIN Terms t
                 ON a.Terms = t.TermsID
               LEFT JOIN APARLINK l
                 ON a.Vendid = l.Vendid
                AND a.Doctype = l.APDocType
                AND a.RefNbr = l.APRefNbr
 WHERE a.Doctype IN ('AC','VO')
   AND t.DiscType = 'P'
   AND a.Vendid LIKE @VendID
   AND a.RefNbr LIKE @RefNbr
   AND a.SubContract LIKE @SubContract
   AND a.ProjectID LIKE @ProjectID
   AND a.docbal > 0
 ORDER BY a.VendID, a.Refnbr DESC
GO
