USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[VendItem_Vendor_FiscYr]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.VendItem_Vendor_FiscYr    Script Date: 4/16/98 7:50:27 PM ******/
Create Proc [dbo].[VendItem_Vendor_FiscYr] @InvtID varchar ( 30), @VendID varchar ( 15), @FiscYr varchar ( 04) as
Select * from VendItem where
        	InvtID = @InvtID And
        	VendID = @VendID And
        	FiscYr = @FiscYr
	Order by InvtId, VendID, FiscYr
GO
