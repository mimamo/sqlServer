USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSODiscCode_DiscountIDAll]    Script Date: 12/21/2015 16:13:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSODiscCode_DiscountIDAll] @DiscountID varchar(1) AS
select * from sodisccode where discountid like @DiscountID order by discountid
GO
