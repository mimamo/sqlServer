USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDocPWPCustIDRefNbr]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDocPWPCustIDRefNbr    Script Date: 06/7/06 ******/
Create Procedure [dbo].[ARDocPWPCustIDRefNbr] @CustID varchar(15), @RefNbr varchar (10) as
SELECT *
  FROM ARDoc
 WHERE CustID = @CustID
   AND RefNbr LIKE @RefNbr
   AND DocType = 'IN'
   AND Docbal > 0
 ORDER BY CustID, DocType, RefNbr
GO
