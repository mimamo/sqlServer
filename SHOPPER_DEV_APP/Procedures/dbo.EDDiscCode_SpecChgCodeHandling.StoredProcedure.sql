USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDiscCode_SpecChgCodeHandling]    Script Date: 12/21/2015 14:34:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDDiscCode_SpecChgCodeHandling] @CustId varchar(15), @DiscountId varchar(1) As
Select SpecChgCode, HandlingMethod From EDDiscCode Where Direction = 'O' And
CustId In ('*',@CustId) And DiscountId = @DiscountId Order By DiscountType Desc
GO
