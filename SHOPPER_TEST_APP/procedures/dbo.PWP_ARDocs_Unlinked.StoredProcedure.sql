USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PWP_ARDocs_Unlinked]    Script Date: 12/21/2015 16:07:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PWP_ARDocs_Unlinked    Script Date: 06/7/06 ******/
Create Procedure [dbo].[PWP_ARDocs_Unlinked] @Custid varchar(15), @RefNbr varchar (10),
                                 @ProjectID varchar(16) as

SELECT a.*, ARLINKED = 0
  FROM ARDoc a LEFT JOIN APARLINK l
                 ON a.Custid = l.Custid
                AND a.Doctype = l.ARDocType
                AND a.RefNbr = l.ARRefNbr
 WHERE l.Custid IS NULL
   AND a.Doctype  = 'IN'
   AND a.Custid LIKE @Custid
   AND a.RefNbr LIKE @RefNbr
   AND a.ProjectID LIKE @ProjectID
   AND a.docbal > 0
 ORDER BY a.Custid, a.Refnbr DESC
GO
