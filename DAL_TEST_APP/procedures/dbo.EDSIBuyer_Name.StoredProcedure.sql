USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSIBuyer_Name]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSIBuyer_Name] @Buyer varchar(10) As
Select Buyer, BuyerName From SIBuyer Where Buyer = @Buyer
GO
