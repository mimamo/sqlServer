USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xiwNEI_ValidateVendor]    Script Date: 12/21/2015 16:07:24 ******/
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
