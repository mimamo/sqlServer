USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDiscCode_DiscountId]    Script Date: 12/21/2015 15:49:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDDiscCode_DiscountId] @Direction varchar(1), @CustId varchar(15), @SpecChgCode varchar(5) As
Select DiscountId From EDDiscCode Where Direction = @Direction And CustId In ('*',@CustId) And
SpecChgCode = @SpecChgCode Order By DiscountType Desc
GO
