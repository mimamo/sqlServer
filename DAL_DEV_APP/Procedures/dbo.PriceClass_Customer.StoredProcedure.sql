USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PriceClass_Customer]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PriceClass_Customer   ******/
Create Proc [dbo].[PriceClass_Customer] @parm1 varchar ( 6) as
    Select * from PriceClass where PriceClassType = 'C' and PriceClassId like @parm1 order by PriceClassId
GO
