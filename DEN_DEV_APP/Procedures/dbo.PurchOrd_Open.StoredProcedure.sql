USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_Open]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_Open    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[PurchOrd_Open] as
Select * from PurOrdDet, PurchOrd, Vendor, Terms
where purorddet.openline =  1
and purorddet.ponbr = purchord.ponbr
and purchord.vendid = vendor.vendid
and purchord.terms = terms.termsid
Order by purorddet.ponbr, promdate
GO
