USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSODiscCode_SingleDiscountID]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSODiscCode_SingleDiscountID] @DiscountID varchar(1) AS
select discountID, Descr  from sodisccode where discountid like @DiscountID
GO
