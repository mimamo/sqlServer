USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPurchOrd_VendPONbrChk]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPurchOrd_VendPONbrChk] @PONbr varchar(10), @VendId varchar(15) As
Select Count(*) From PurchOrd Where PONbr = @PONbr And VendId = @VendId
GO
