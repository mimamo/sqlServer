USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSalesTax_850Info]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSalesTax_850Info] @TaxId varchar(10) As
Select TaxId, FilingLoc, Case Exemption When 'Y' Then '1' Else '2' End, TaxRate, LocalCode, User1,
User2, User3, User4, User5, User6, User7, User8 From SalesTax Where TaxId = @TaxId
GO
