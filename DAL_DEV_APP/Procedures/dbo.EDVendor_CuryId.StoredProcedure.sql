USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDVendor_CuryId]    Script Date: 12/21/2015 13:35:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDVendor_CuryId] @VendId varchar(15) As
Select CuryId From Vendor Where VendId = @VendId
GO
