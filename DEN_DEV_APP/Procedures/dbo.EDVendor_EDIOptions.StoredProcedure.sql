USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDVendor_EDIOptions]    Script Date: 12/21/2015 14:06:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDVendor_EDIOptions] @VendId varchar(15) As
Select InEDICost, VouchRecpt, VouchFreight, VendId From EDVendor Where VendId = @VendId
GO
