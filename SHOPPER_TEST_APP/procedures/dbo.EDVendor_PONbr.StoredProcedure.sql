USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDVendor_PONbr]    Script Date: 12/21/2015 16:07:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDVendor_PONbr] @PONbr varchar(10) As
Select * From EDVendor Where VendId = (Select VendId From PurchOrd Where PONbr = @PONbr)
GO
