USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SalesTax_All]    Script Date: 12/21/2015 15:55:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SalesTax_All    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[SalesTax_All] @parm1 varchar ( 10) as
    Select * from SalesTax
    where TaxId like @parm1
    order by TaxId
GO
