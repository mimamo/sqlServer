USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDVendor_EDIOptions]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDVendor_EDIOptions] @VendId varchar(15) As
Select InEDICost, VouchRecpt, VouchFreight, VendId From EDVendor Where VendId = @VendId
GO
