USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDVendor_UserFields]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDVendor_UserFields] @VendId varchar(15) As
Select VendId, User1, User2, User3, User4, User5, User6, User7, User8 From Vendor
Where VendId = @VendId
GO
