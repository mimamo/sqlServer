USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDVendor_PONbr]    Script Date: 12/21/2015 13:57:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDVendor_PONbr] @PONbr varchar(10) As
Select * From EDVendor Where VendId = (Select VendId From PurchOrd Where PONbr = @PONbr)
GO
