USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PWP_APDocs_Unlinked]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PWP_APDocs_Unlinked    Script Date: 06/7/06 ******/
Create Procedure [dbo].[PWP_APDocs_Unlinked] @VendID varchar(15), @RefNbr varchar (10), @SubContract varchar (16),
                                 @ProjectID varchar(16) as

SELECT a.*, APLINKED = 0
  FROM APDoc a JOIN Terms t
                 ON a.Terms = t.TermsID
               LEFT JOIN APARLINK l
                 ON a.Vendid = l.Vendid
                AND a.Doctype = l.APDocType
                AND a.RefNbr = l.APRefNbr
 WHERE l.VendID IS NULL
   AND a.Doctype IN ('AC','VO')
   AND t.DiscType = 'P'
   AND a.Vendid LIKE @VendID
   AND a.RefNbr LIKE @RefNbr
   AND a.SubContract LIKE @SubContract
   AND a.ProjectID LIKE @ProjectID
   AND a.docbal > 0
 ORDER BY a.VendID, a.Refnbr DESC
GO
