USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[APARLink_APDocs_PWP]    Script Date: 12/21/2015 16:13:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APARLink_APDocs_PWP    Script Date: 06/7/06 ******/
Create Procedure [dbo].[APARLink_APDocs_PWP] @VendID varchar(15), @DocType varchar (2), @RefNbr varchar (10) as

SELECT *
  FROM APARLink
 WHERE VendID = @VendID
   AND APDoctype = @DocType
   AND APRefnbr = @RefNbr
GO
