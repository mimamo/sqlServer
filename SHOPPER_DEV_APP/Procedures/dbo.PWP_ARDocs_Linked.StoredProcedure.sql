USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PWP_ARDocs_Linked]    Script Date: 12/21/2015 14:34:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PWP_ARDocs_Linked    Script Date: 06/7/06 ******/
Create Procedure [dbo].[PWP_ARDocs_Linked] @Custid varchar(15), @RefNbr varchar (10),
                                 @ProjectID varchar(16) as

SELECT a.*, ARLINKED = 1
  FROM ARDoc a JOIN APARLINK l
                 ON a.Custid = l.Custid
                AND a.Doctype = l.ARDocType
                AND a.RefNbr = l.ARRefNbr
 WHERE a.Doctype  = 'IN'
   AND a.Custid LIKE @Custid
   AND a.RefNbr LIKE @RefNbr
   AND a.ProjectID LIKE @ProjectID
   AND a.docbal > 0
 ORDER BY a.Custid, a.Refnbr DESC
GO
