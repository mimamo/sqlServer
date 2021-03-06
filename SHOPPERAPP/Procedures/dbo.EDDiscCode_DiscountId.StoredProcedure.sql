USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDiscCode_DiscountId]    Script Date: 12/21/2015 16:13:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDDiscCode_DiscountId] @Direction varchar(1), @CustId varchar(15), @SpecChgCode varchar(5) As
Select DiscountId From EDDiscCode Where Direction = @Direction And CustId In ('*',@CustId) And
SpecChgCode = @SpecChgCode Order By DiscountType Desc
GO
