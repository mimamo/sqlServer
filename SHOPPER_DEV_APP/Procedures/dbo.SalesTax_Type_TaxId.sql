USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SalesTax_Type_TaxId]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SalesTax_Type_TaxId   ******/
Create Proc  [dbo].[SalesTax_Type_TaxId] @parm1 varchar ( 1), @parm2 varchar ( 10) as
       Select * from SalesTax
           where TaxType LIKE @parm1
             and TaxId   LIKE @parm2
           order by TaxType, TaxId
GO
