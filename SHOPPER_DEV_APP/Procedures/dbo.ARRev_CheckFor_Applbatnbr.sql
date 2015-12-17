USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARRev_CheckFor_Applbatnbr]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARRev_CheckFor_Applbatnbr    Script Date: 11/12/00 12:30:32 PM ******/
CREATE PROC [dbo].[ARRev_CheckFor_Applbatnbr] @Batnbr varchar (10), @custid varchar ( 15),
            @Doctype varchar ( 2), @refnbr varchar ( 10) AS

SELECT *
  FROM ARDoc
 WHERE Batnbr = @Batnbr AND
       ApplBatnbr = '' AND
       Custid = @custid AND
       Doctype = @Doctype AND
       Refnbr = @refnbr
GO
