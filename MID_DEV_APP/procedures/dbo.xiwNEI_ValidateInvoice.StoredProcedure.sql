USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xiwNEI_ValidateInvoice]    Script Date: 12/21/2015 14:18:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xiwNEI_ValidateInvoice]
@Invoice ListOfInvoice READONLY
AS
SELECT U.InvcNbr
FROM @Invoice U
JOIN APDoc D
  ON U.InvcDate = D.InvcDate
 AND U.InvcNbr = D.InvcNbr
 AND U.Vendor = D.VendId
GO
