USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSODiscCode_Validate]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSODiscCode_Validate] @DiscountId varchar(1) As
Select Count(*) From SODiscCode Where DiscountId = @DiscountId
GO
