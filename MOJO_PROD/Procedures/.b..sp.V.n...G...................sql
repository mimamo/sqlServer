USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorGet]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVendorGet]
	 @VendorKey int
AS --Encrypt


	
	
/*
|| When     Who Rel      What
|| 02/18/11 RLB 10.5.4.1 (100772) created for Sales Taxs on Expense Receipts
*/
	
Select  c.VendorID,
		c.CompanyName,
		c.VendorSalesTaxKey,
		st.SalesTaxID,
		st.SalesTaxName,
		st.TaxRate,
		st.PiggyBackTax,
		c.VendorSalesTax2Key,
		st2.SalesTaxID as SaleTax2ID,
		st2.SalesTaxName as SaleTax2Name,
		st2.TaxRate as TaxRate2,
		st2.PiggyBackTax as PiggyBackTax2
FROM tCompany c (nolock)
	left outer join tSalesTax st (nolock) on c.VendorSalesTaxKey = st.SalesTaxKey
	left outer join tSalesTax st2 (nolock) on c.VendorSalesTax2Key = st2.SalesTaxKey
WHERE c.CompanyKey = @VendorKey
  
 RETURN 1
GO
