USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xiwNEI_ValidateVendor]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xiwNEI_ValidateVendor]
@StringList ListOfString READONLY
AS
SELECT U.Id
FROM @StringList U
LEFT JOIN Vendor V
  ON U.Id = V.VendId
WHERE V.VendId IS NULL
GO
