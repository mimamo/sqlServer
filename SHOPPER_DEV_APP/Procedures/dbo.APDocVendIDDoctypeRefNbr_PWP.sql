USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDocVendIDDoctypeRefNbr_PWP]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDocVendIDDoctypeRefNbr_PWP    Script Date: 06/7/06 ******/
Create Procedure [dbo].[APDocVendIDDoctypeRefNbr_PWP] @VendID varchar(15), @Doctype varchar (2), @RefNbr varchar (10) as

SELECT APCpnyID = CpnyID, APDocType = DocType, APProject = ProjectID, APRefNbr = RefNbr,
       SubContract,VendID, APDocBal = DocBal, APDocDate = DocDate
  FROM APDoc d
 WHERE VendID = @VendID
   AND Doctype = @Doctype
   AND RefNbr = @RefNbr
GO
