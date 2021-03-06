USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentDetailGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentDetailGet]
	@PaymentDetailKey int

AS --Encrypt

/*
|| When     Who Rel    What
|| 09/24/07 BSH 8.5    (9659)Get OfficeKey, DepartmentKey
|| 03/17/09 MFT 10.021 (40077) Added Exclude1099
|| 01/27/10 GHL 10.517 Added OfficeName and DepartmentName for Exclude1099 logic after posting
|| 07/22/10 MFT 10.532 Added tSalesTax
*/

SELECT     
	 pd.PaymentDetailKey
	,pd.PaymentKey
	,pd.GLAccountKey
	,pd.VoucherKey
	,pd.Description
	,pd.Quantity
	,pd.UnitAmount
	,pd.DiscAmount
	,pd.Amount
	,pd.Exclude1099
	,gl2.AccountNumber as AccountNumber
	,gl2.AccountName as AccountName
	,cl.ClassID
	,cl.ClassName
	,pd.OfficeKey
	,o.OfficeName
	,pd.DepartmentKey
	,d.DepartmentName
	,st.SalesTaxName
	,st.SalesTaxKey
FROM         
	tPaymentDetail pd (nolock)
	left outer  JOIN tGLAccount gl2 (nolock) ON pd.GLAccountKey = gl2.GLAccountKey
	left outer join tClass cl (nolock) on pd.ClassKey = cl.ClassKey
	left outer join tOffice o (nolock) on pd.OfficeKey = o.OfficeKey
	left outer join tDepartment d (nolock) on pd.DepartmentKey = d.DepartmentKey
	left outer join tSalesTax st (nolock) ON pd.SalesTaxKey = st.SalesTaxKey
WHERE
	PaymentDetailKey = @PaymentDetailKey

RETURN 1
GO
