USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSODiscCode_SingleDiscountID]    Script Date: 12/21/2015 13:35:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSODiscCode_SingleDiscountID] @DiscountID varchar(1) AS
select discountID, Descr  from sodisccode where discountid like @DiscountID
GO
