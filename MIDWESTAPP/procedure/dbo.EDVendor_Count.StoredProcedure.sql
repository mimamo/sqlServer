USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDVendor_Count]    Script Date: 12/21/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDVendor_Count] @VendId varchar(15) As
Select Count(*) From Vendor Where VendId = @VendId
GO
