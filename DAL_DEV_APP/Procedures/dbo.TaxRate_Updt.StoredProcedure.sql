USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TaxRate_Updt]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.TaxRate_Updt    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[TaxRate_Updt] @parm1 smalldatetime AS
       Select * from SalesTax
           where NewRateDate <= @parm1
           and   NewTaxRate <> 0
           and   TaxType = 'T'
           Order by TaxId
GO
