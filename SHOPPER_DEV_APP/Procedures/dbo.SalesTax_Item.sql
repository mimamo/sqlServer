USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SalesTax_Item]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SalesTax_Item    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[SalesTax_Item] @parm1 varchar ( 10) as
    Select * from SalesTax
    where TaxId like @parm1
    and TaxCalcType = 'I'
    order by TaxId
GO
