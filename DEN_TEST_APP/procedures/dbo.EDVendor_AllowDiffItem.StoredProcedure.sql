USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDVendor_AllowDiffItem]    Script Date: 12/21/2015 15:36:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDVendor_AllowDiffItem] @VendId varchar(15) As
Select AllowDiffItem From EDVendor Where VendId = @VendId
GO
