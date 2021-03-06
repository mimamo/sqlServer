USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentDetailGetGLList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentDetailGetGLList]
	@PaymentKey int

AS --Encrypt

/*
|| When     Who Rel			What
|| 03/17/09 MFT 10.021  (40077) Added Exclude1099
|| 03/01/10 MAS 10.5.2  Added fields for Flex lookup classes
|| 07/22/10 MFT 10.532  Added tSalesTax
|| 03/21/12 GWG 10.554  Added GLCompany on the line
*/

SELECT     
	 pd.PaymentDetailKey
	,pd.PaymentKey
	,pd.GLAccountKey,gl2.AccountNumber as GLAccountNumber,gl2.AccountName as GLAccountName
	,pd.VoucherKey
	,pd.Description
	,pd.Quantity
	,pd.UnitAmount
	,pd.DiscAmount
	,pd.Amount
	,pd.Exclude1099
	,gl2.AccountNumber as AccountNumber
	,gl2.AccountName as AccountName
	,cl.ClassKey, cl.ClassID, cl.ClassName
	,pd.DepartmentKey, d.DepartmentName
	,pd.OfficeKey, o.OfficeID, o.OfficeName
	,st.SalesTaxName
	,st.SalesTaxKey
	,pd.TargetGLCompanyKey
	,glc.GLCompanyID
	,glc.GLCompanyName
FROM         
	tPaymentDetail pd (nolock)
	left outer  JOIN tGLAccount gl2 (nolock) ON pd.GLAccountKey = gl2.GLAccountKey
	left outer join tClass cl (nolock) on pd.ClassKey = cl.ClassKey
	left outer join tDepartment d (nolock) on pd.DepartmentKey = d.DepartmentKey
	left outer join tOffice o (nolock) on pd.OfficeKey = o.OfficeKey
	left outer join tSalesTax st (nolock) ON pd.SalesTaxKey = st.SalesTaxKey
	left outer join tGLCompany glc (nolock) on pd.TargetGLCompanyKey = glc.GLCompanyKey
WHERE
	PaymentKey = @PaymentKey and pd.VoucherKey is null
GO
