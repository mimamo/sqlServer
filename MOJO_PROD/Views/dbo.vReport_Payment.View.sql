USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Payment]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_Payment]
AS

/*
|| When      Who Rel     What
|| 3/18/09   GWG 10.021  Created
|| 3/22/09   GWG 10.022  Added Custom Fields
|| 04/24/12  GHL 10.555   Added GLCompanyKey in order to map/restrict
|| 04/27/12  RLB 10.555  (141436) Adding ClientID/Client Name from the Project on Voucher Header
|| 10/29/12  CRG 10.5.6.1 (156391) Added ProjectKey
|| 01/09/13  GWG 10.564  Added 1099 Info
|| 02/04/13  KMC 10.564  (167280) Added project number
|| 06/24/13  RLB 10.569  (180813) Added Purchase From and Purchase By
|| 07/01/13  GHL 10.569  (182649) Added [Vendor Accepts CreditCard Cards]
|| 07/19/13  WDF 10.570  (176497) Added VoucherID
|| 12/10/13  WDF 10.575  (198741) Added InvoiceDate and split out City, State, Zip from Address fields
|| 02/25/14  WDF 10.575  (204912) Added IsNull check for [Line 1099 Amount] calc; Added '' check for PayToAddresses
|| 03/07/14  GHL 10.578   Added Currency
|| 01/27/15  WDF 10.588  (Abelson Taylor) Added Division and Product
*/
 WITH AddressSplit (CompanyKey, PaymentKey, City, State, Zip)
      AS
      (
		select CompanyKey, PaymentKey, ca1.City, ca5.State, ca4.Zip from tPayment (nolock)
		cross apply (select charindex(', ', PayToAddress1) AS CommaPos) ca0
		cross apply (select case when CommaPos = 0 then 'Bad Address' else SUBSTRING(PayToAddress1,1,CommaPos - 1) end as City) ca1
		cross apply (select case when CommaPos = 0 then NULL else ltrim(substring(PayToAddress1,CommaPos+1, len(PayToAddress1))) end as Rest) ca2
		cross apply (select PATINDEX('%[0-9]%',Rest) as DigitPos) ca3
		cross apply (select case when DigitPos > 0 then substring(Rest, DigitPos, len(Rest)) end as Zip) ca4
		cross apply (select case when Zip Is not NULL then replace(Rest,Zip,'') else Rest end as State) ca5
		where PayToAddress1 is not null
		  and charindex(', ', PayToAddress1) > 0
		  and ca1.City <> 'Bad Address'
		  and LEN(ca5.State) = 2
		  and (LEN(ca4.Zip) = 5
		   or  LEN(ca4.Zip) = 10)
		UNION
		select CompanyKey, PaymentKey, ca1.City, ca5.State, ca4.Zip from tPayment (nolock)
		cross apply (select charindex(', ', PayToAddress2) AS CommaPos) ca0
		cross apply (select case when CommaPos = 0 then 'Bad Address' else SUBSTRING(PayToAddress2,1,CommaPos - 1) end as City) ca1
		cross apply (select case when CommaPos = 0 then NULL else ltrim(substring(PayToAddress2,CommaPos+1, len(PayToAddress2))) end as Rest) ca2
		cross apply (select PATINDEX('%[0-9]%',Rest) as DigitPos) ca3
		cross apply (select case when DigitPos > 0 then substring(Rest, DigitPos, len(Rest)) end as Zip) ca4
		cross apply (select case when Zip Is not NULL then replace(Rest,Zip,'') else Rest end as State) ca5
		where PayToAddress2 is not null
		  and charindex(', ', PayToAddress2) > 0
		  and ca1.City <> 'Bad Address'
		  and LEN(ca5.State) = 2
		  and (LEN(ca4.Zip) = 5
		   or  LEN(ca4.Zip) = 10)
		UNION
		select CompanyKey, PaymentKey, ca1.City, ca5.State, ca4.Zip from tPayment (nolock)
		cross apply (select charindex(', ', PayToAddress3) AS CommaPos) ca0
		cross apply (select case when CommaPos = 0 then 'Bad Address' else SUBSTRING(PayToAddress3,1,CommaPos - 1) end as City) ca1
		cross apply (select case when CommaPos = 0 then NULL else ltrim(substring(PayToAddress3,CommaPos+1, len(PayToAddress3))) end as Rest) ca2
		cross apply (select PATINDEX('%[0-9]%',Rest) as DigitPos) ca3
		cross apply (select case when DigitPos > 0 then substring(Rest, DigitPos, len(Rest)) end as Zip) ca4
		cross apply (select case when Zip Is not NULL then replace(Rest,Zip,'') else Rest end as State) ca5
		where PayToAddress3 is not null
		  and charindex(', ', PayToAddress3) > 0
		  and ca1.City <> 'Bad Address'
		  and LEN(ca5.State) = 2
		  and (LEN(ca4.Zip) = 5
		   or  LEN(ca4.Zip) = 10)
		UNION
		select CompanyKey, PaymentKey, ca1.City, ca5.State, ca4.Zip from tPayment (nolock)
		cross apply (select charindex(', ', PayToAddress4) AS CommaPos) ca0
		cross apply (select case when CommaPos = 0 then 'Bad Address' else SUBSTRING(PayToAddress4,1,CommaPos - 1) end as City) ca1
		cross apply (select case when CommaPos = 0 then NULL else ltrim(substring(PayToAddress4,CommaPos+1, len(PayToAddress4))) end as Rest) ca2
		cross apply (select PATINDEX('%[0-9]%',Rest) as DigitPos) ca3
		cross apply (select case when DigitPos > 0 then substring(Rest, DigitPos, len(Rest)) end as Zip) ca4
		cross apply (select case when Zip Is not NULL then replace(Rest,Zip,'') else Rest end as State) ca5
		where PayToAddress4 is not null
		  and charindex(', ', PayToAddress4) > 0
		  and ca1.City <> 'Bad Address'
		  and LEN(ca5.State) = 2
		  and (LEN(ca4.Zip) = 5
		   or  LEN(ca4.Zip) = 10)
		UNION
		select CompanyKey, PaymentKey, ca1.City, ca5.State, ca4.Zip from tPayment (nolock)
		cross apply (select charindex(', ', PayToAddress5) AS CommaPos) ca0
		cross apply (select case when CommaPos = 0 then 'Bad Address' else SUBSTRING(PayToAddress5,1,CommaPos - 1) end as City) ca1
		cross apply (select case when CommaPos = 0 then NULL else ltrim(substring(PayToAddress5,CommaPos+1, len(PayToAddress5))) end as Rest) ca2
		cross apply (select PATINDEX('%[0-9]%',Rest) as DigitPos) ca3
		cross apply (select case when DigitPos > 0 then substring(Rest, DigitPos, len(Rest)) end as Zip) ca4
		cross apply (select case when Zip Is not NULL then replace(Rest,Zip,'') else Rest end as State) ca5
		where PayToAddress5 is not null
		  and charindex(', ', PayToAddress5) > 0
		  and ca1.City <> 'Bad Address'
		  and LEN(ca5.State) = 2
		  and (LEN(ca4.Zip) = 5
		   or  LEN(ca4.Zip) = 10)
      )


SELECT
	 p.CompanyKey
	,isnull(pd.TargetGLCompanyKey, p.GLCompanyKey) as GLCompanyKey 
	,c.CustomFieldKey
	,pj.ProjectKey
	
	,gl.AccountNumber as [Cash Account Number]
	,gl.AccountName as [Cash Account Name]
	,gl.AccountNumber + ' - ' + gl.AccountName as [Cash Account Full Name]
	,gl2.AccountNumber as [Unapplied Payment Account Number]
	,gl2.AccountName as [Unapplied Payment Account Name]
	,gl2.AccountNumber + ' - ' + gl2.AccountName as [Unapplied Payment Account Full Name]
	,p.PaymentDate as [Check Date]
	,p.CheckNumber as [Check Number]
	,c.VendorID as [Vendor ID]
	,c.CompanyName as [Vendor Name]
	,case c.Type1099 When 1 then 'MISC' when 2 then 'INT' else 'NONE' end as [Vendor 1099 Type]
	,case when c.CCAccepted = 1 then 'YES' else 'NO' end as [Vendor Accepts Credit Cards]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,ct.CompanyTypeName as [Company Type]
	,p.PayToName as [Pay To Name]
	,c.Phone as [Vendor Phone]
	,case when p.PayToAddress1 = '' then null else p.PayToAddress1 end as [Pay To Address1]
	,case when p.PayToAddress2 = '' then null else p.PayToAddress2 end as [Pay To Address2]
	,case when p.PayToAddress3 = '' then null else p.PayToAddress3 end as [Pay To Address3]
	,case when p.PayToAddress4 = '' then null else p.PayToAddress4 end as [Pay To Address4]
	,case when p.PayToAddress5 = '' then null else p.PayToAddress5 end as [Pay To Address5]
	,(Select City from AddressSplit Where CompanyKey = p.CompanyKey and PaymentKey = p.PaymentKey) as [City]
	,(Select State from AddressSplit Where CompanyKey = p.CompanyKey and PaymentKey = p.PaymentKey) as [State]
	,(Select Zip from AddressSplit Where CompanyKey = p.CompanyKey and PaymentKey = p.PaymentKey) as [Zip Code]
	,p.PostingDate as [Posting Date]
	,p.Memo as [Check Memo]
	,p.PaymentAmount as [Check Amount]
	,case p.Posted when 1 then 'YES' else 'NO' end as Posted
	,case when p.CheckNumber is null then 'NO' else 'YES' end as Printed
	,(Select Count(*) from tTransaction (nolock) Where Entity = 'PAYMENT' and EntityKey = p.PaymentKey) as [Posting Count]
	,Case (Select Distinct 1 from tTransaction tr(nolock) Where  p.PaymentKey = tr.EntityKey and tr.Entity = 'PAYMENT' and tr.Cleared = 1) When 1 then 'YES' else 'NO' end as Cleared
	,isnull(glcT.GLCompanyID, glc.GLCompanyID) as [Company ID] 
	,isnull(glcT.GLCompanyName, glc.GLCompanyName) as [Company Name] 
	,glexp.AccountNumber as [Line Expense Account Number]
	,glexp.AccountName as [Line Expense Account Name]
	,glexp.AccountNumber + ' - ' + glexp.AccountName as [Line Expense Account]
	,cld.ClassID as [Line Class ID]
	,cld.ClassName as [Line Class Name]
	,o.OfficeName as [Line Office]
	,d.DepartmentName as [Line Department]
	,case when Prepay = 1 then 'YES' else 'NO' end as [Applied as a Prepayment]
	,pd.Description as [Line Description]
	,pd.Quantity as [Line Quantity]
	,pd.UnitAmount as [Line Unit Amount]
	,pd.DiscAmount as [Line Discount Amount]
	,pd.Amount as [Line Amount]
	,pd.Exclude1099 as [Line Exclude from 1099]
	,Case ISNULL(c.Type1099, 0) When 0 then 0 else ISNULL(pd.Amount, 0) - ISNULL(pd.Exclude1099, 0) end as [Line 1099 Amount]
	,Case c.Type1099 When 1 then 'MISC' when 2 then 'INT' else null end as [Vendor 1099 Form]
	,c.Box1099 as [Vendor 1099 Box]
	,v.InvoiceNumber as [Line Invoice Number]
	,v.InvoiceDate as [Invoice Date]
	,v.PostingDate as [Invoice Posting Date]
	,cc.CustomerID as [Client ID]
	,cc.CompanyName as [Client Name]
	,c.EINNumber as [EIN Number]
	,pj.ProjectNumber as [Project Number]
	,v.BoughtFrom as [Purchased From]
	,v.Description AS [Vendor Invoice Memo]
	,v.VoucherID as [Unique Auto Number]
	,pb.FirstName + ' ' + pb.LastName as [Purchased By]
    ,p.CurrencyID as [Currency]
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cp.ProductID as [Client Product ID]
    ,cp.ProductName as [Client Product]
FROM         
	tPayment p (nolock)
	INNER JOIN tCompany c (nolock) ON p.VendorKey = c.CompanyKey 
	left outer join tPaymentDetail pd (nolock) on p.PaymentKey = pd.PaymentKey
	left outer join tCompanyType ct (nolock) on c.CompanyTypeKey = ct.CompanyTypeKey
	left outer JOIN tGLAccount gl(nolock) ON p.CashAccountKey = gl.GLAccountKey
	left outer JOIN tGLAccount gl2 (nolock) ON p.UnappliedPaymentAccountKey = gl2.GLAccountKey
	left outer JOIN tGLAccount glexp (nolock) ON pd.GLAccountKey = glexp.GLAccountKey
	left outer join tClass cl (nolock) on p.ClassKey = cl.ClassKey
	left outer join tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey
	left outer join tGLCompany glcT (nolock) on pd.TargetGLCompanyKey = glcT.GLCompanyKey
	left outer join tClass cld (nolock) on pd.ClassKey = cld.ClassKey
	left outer join tOffice o (nolock) on pd.OfficeKey = o.OfficeKey
	left outer join tDepartment d (nolock) on pd.DepartmentKey = d.DepartmentKey
	left outer join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
	left outer join tProject pj (nolock) on v.ProjectKey = pj.ProjectKey
	left outer join tCompany cc (nolock) on pj.ClientKey = cc.CompanyKey
	left outer join tUser pb (nolock) on v.BoughtByKey = pb.UserKey
	left outer join tClientDivision cd (nolock) on pj.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  cp (nolock) on pj.ClientProductKey  = cp.ClientProductKey
GO
