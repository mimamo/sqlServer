USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSODiscCode_Validate]    Script Date: 12/21/2015 13:44:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSODiscCode_Validate] @DiscountId varchar(1) As
Select Count(*) From SODiscCode Where DiscountId = @DiscountId
GO
