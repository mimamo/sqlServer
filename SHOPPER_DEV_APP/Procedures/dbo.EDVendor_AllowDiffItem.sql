USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDVendor_AllowDiffItem]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDVendor_AllowDiffItem] @VendId varchar(15) As
Select AllowDiffItem From EDVendor Where VendId = @VendId
GO
