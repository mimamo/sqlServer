USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PriceClass_Item]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PriceClass_Item  ******/
Create Proc [dbo].[PriceClass_Item] @parm1 varchar ( 6) as
    Select * from PriceClass where PriceClassType = 'I' and PriceClassId like @parm1 order by PriceClassId
GO
