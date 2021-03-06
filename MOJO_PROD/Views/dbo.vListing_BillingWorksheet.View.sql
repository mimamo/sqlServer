USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_BillingWorksheet]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE          View [dbo].[vListing_BillingWorksheet]
as

/*
|| When      Who Rel     What
|| 5/7/07    CRG 8.4.3   (8995) Added Worksheet Comment and Invoice Comment
|| 7/7/07    GHL 8.5      Added Master to Billing Method      
|| 10/10/07  CRG 8.5     Added Class, GLCompany, Office
|| 02/06/08  BSH 1.0.0.0 Added ASC_Selected
|| 08/08/08  GHL 1.0.0.6 (32019) Setting now Invoice Total = 0 for child worksheets
|| 12/03/08  GHL 10.013  (41656) Users want to see Retainer as billing method for child billing WS
|| 04/15/09  RLB 10.0.2.3 (50919) Pulling just date on b.DateCreated 
|| 05/14/09  GHL 10.0.2.5 (52802) Modified Total To Bill as sum of TM + FF + Retainer Amt regardless of billing method
|| 11/11/09  GHL 10.5.1.3 (67911) If the billing worksheet is not billed yet, get the invoice comment from the worksheet
|| 04/25/12  GHL 10.5.5.5 Added GLCompanyKey for map/restrict
|| 08/08/12  GHL 10.5.5.8 (150964) Corrected line formats. Added Billing Group Code
|| 09/27/12  GHL 10.5.6.0 Corrected billing group code because of new table tBillingGroup 
|| 08/26/13  RLB 10.5.7.1 (170225) Adding Billing Manager from the project
|| 12/26/13  WDF 10.5.7.5 (198697) Added Billing Manager for Retainers
|| 04/22/14  WDF 10.5.7.9 (211824) Added Budget and Billed taken from Pending Approvals screen
|| 01/26/15  GHL 10.5.8.8 Added Biling Group Description for Abelson Taylor + new Line Formats
|| 01/27/15  WDF 10.5.8.8 (Abelson Taylor) Added Division and Product ID
|| 03/25/15  GHL 10.5.9.1 Added field 'Under a Master Worksheet' to help with testing (+ Currency)
||                        Identifies independant worksheets vs ws under a master
*/

Select
	 b.CompanyKey
	,b.GLCompanyKey
	,b.BillingKey
	,b.BillingID as [Worksheet ID]
	,c.CustomerID as [Client ID]
	,c.CompanyName as [Client Name]
	,c.CustomerID + ' - ' + c.CompanyName as [Client Full Name]
	,Case p.BillingMethod
		When 3 then 'Retainer'
		else
			Case b.BillingMethod
				When 1 then 'Time and Materials'
				When 2 then 'Fixed Fee'
				When 3 then 'Retainer' 
				else 'Master' 
			end 
		end as [Billing Method]
	,Case ParentWorksheet When 1 then 'YES' else 'NO' end as [Master Worksheet]
	,Case ParentWorksheet when 1 then NULL
		else Case isnull(ParentWorksheetKey, 0) When 0 then 'NO' else 'YES' end 
	end as [Under a Master Worksheet] 
	,ISNULL(u.FirstName, '')+' '+ISNULL(u.LastName, '') as [Approver Name]
	,Case b.BillingMethod
	    When 3 then ISNULL(ubr.FirstName, '')+' '+ISNULL(ubr.LastName, '')
	    else ISNULL(ubm.FirstName, '')+' '+ISNULL(ubm.LastName, '')
	 end  as [Billing Manager]
	,p.ProjectNumber as [Project Number]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber + ' - ' + p.ProjectName as [Project Full Name]
	,gl.AccountNumber as [Default Sales Account]
	,st1.SalesTaxName as [Sales Tax 1]
	,st2.SalesTaxName as [Sales Tax 2]
	,pt.TermsDescription as [Payment Terms]
	,Case b.Status
		When 1 then 'In Review'
		When 2 then 'Sent for Approval'
		When 3 then 'Rejected'
		When 4 then 'Approved'
		When 5 then 'Billed' end as [Worksheet Status]
	,Case b.DefaultARLineFormat
		When 0 then 'One Line Item'
		When 1 then 'One Per Task'
		When 2 then 'One Per Service'
		When 3 then 'One Per Billing Item'
		When 8 then 'One Per Project then Billing Item and Item'
		When 9 then 'One Per Billing Item and Item' 
		When 11 then 'One Per Title'
		When 12 then 'One Per Title and Service'
		When 13 then 'One Per Service and Title'
		When 14 then 'One Per Service/Item'
	end as [Line Item Format]
	,cp.ProductName as [Product]
	,cp.ProductID as [Product ID]
	,cd.DivisionName as [Division]
	,cd.DivisionID as [Division ID]
	,b.Status
	,b.RetainerAmount as [Retainer Amount]
	,b.FFTotal as [Fixed Fee Amount]
	,b.LaborTotal as [Labor to Bill]
	,b.ExpenseTotal as [Expenses to Bill]
	,(ISNULL(b.LaborTotal, 0) + ISNULL(b.ExpenseTotal, 0) + ISNULL(b.FFTotal, 0) + ISNULL(b.RetainerAmount, 0)) 
	as [Total to Bill]
	,ISNULL(p.EstLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.ApprovedCOExpense, 0) 
	as [Budget]
	,(Select Sum(Amount) from tInvoiceSummary (nolock) inner join tInvoice (nolock) on tInvoice.InvoiceKey = tInvoiceSummary.InvoiceKey
	   Where tInvoiceSummary.ProjectKey = b.ProjectKey and tInvoice.AdvanceBill = 0) as [Billed]
	,(Case b.ParentWorksheet 
		WHEN 0 THEN
			Case b.BillingMethod 
			When 1 then ISNULL(b.GeneratedLabor, 0) + ISNULL(b.GeneratedExpense, 0) 
			When 2 then ISNULL(b.GeneratedLabor, 0) + ISNULL(b.GeneratedExpense, 0) 
			When 3 then ISNULL(b.RetainerAmount, 0) 
			end
		ELSE
			ISNULL(b.GeneratedLabor, 0) + ISNULL(b.GeneratedExpense, 0) + ISNULL(b.RetainerAmount, 0)
	  END) 
	as [Original to Bill]
	,b.WOTotal as [Write Off Amount]
	,b.MBTotal as [Mark Billed Amount]
	,b.HoldTotal as [Put On Hold Amount]
	,b.OffHoldTotal as [Put Off Hold Amount]
	,b.TransferTotal as [Transfer Amount]
	,b.DoNotBillTotal as [Total to Not Bill]
	,b.GeneratedLabor as [Original Labor]
	,b.GeneratedExpense as [Original Expenses]
	,b.ErrorMsg as [Invoicing Error Message]
	,b.DueDate as [Due Date]
	,b.DueDate
	,Cast(Cast(Month(b.DateCreated) as varchar) + '/' + Cast(Day(b.DateCreated) as varchar) + '/' + Cast(Year(b.DateCreated) as varchar) as smalldatetime) as [Date Created]
	,i.InvoiceNumber as [Invoice Number]
	,CASE WHEN ISNULL(b.ParentWorksheetKey, 0) = 0 THEN i.InvoiceTotalAmount ELSE 0 END as [Invoice Total]
	,ISNULL((Select Sum(v.BillableCost) From vBillingItemSelect v (NOLOCK) Where b.ProjectKey = v.ProjectKey),0) As [Total Not Selected]
	,b.WorkSheetComment as [Worksheet Comment]
	,case when b.InvoiceKey is null then b.InvoiceComment else i.HeaderComment end as [Invoice Comment]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,o.OfficeID as [Office ID]
	,o.OfficeName as [Office Name]
    ,0 AS ASC_Selected
    
    , case when b.ParentWorksheet = 1 then 
		-- Master Worksheets
		case b.Entity
			when  'BillingGroup' then bg.BillingGroupCode
			else  null 
		end
	else 
		-- Regular Worksheets
		case isnull(b.GroupEntity, '')
			when  'BillingGroup' then bgg.BillingGroupCode
			else  null 
		end
	end as [Billing Group Code]
	, case when b.ParentWorksheet = 1 then 
		-- Master Worksheets
		case b.Entity
			when  'BillingGroup' then bg.Description
			else  null 
		end
	else 
		-- Regular Worksheets
		case isnull(b.GroupEntity, '')
			when  'BillingGroup' then bgg.Description
			else  null 
		end
	end as [Billing Group Description],
	b.CurrencyID as [Currency]

From
	tBilling b (NOLOCK) 
	inner join tCompany c (NOLOCK) on b.ClientKey = c.CompanyKey
	left outer join tProject p (NOLOCK) on b.ProjectKey = p.ProjectKey
	left outer join tUser u (nolock) on b.Approver = u.UserKey
	left outer join tRetainer r (nolock) on (b.BillingMethod = 3 and 
	                                         b.EntityKey = r.RetainerKey)
	left outer join tUser ubm (nolock) on p.BillingManagerKey = ubm.UserKey
	left outer join tUser ubr (nolock) on r.BillingManagerKey = ubr.UserKey
	left outer join tClientDivision cd (NOLOCK) on cd.ClientDivisionKey = p.ClientDivisionKey
	left outer join tClientProduct cp (NOLOCK) on cp.ClientProductKey = p.ClientProductKey
	left outer join tGLAccount gl (NOLOCK) on b.DefaultSalesAccountKey = gl.GLAccountKey
	left outer join tSalesTax st1 (NOLOCK) on b.SalesTaxKey = st1.SalesTaxKey
	left outer join tSalesTax st2 (NOLOCK) on b.SalesTax2Key = st2.SalesTaxKey
	left outer join tPaymentTerms pt (NOLOCK) on b.TermsKey = pt.PaymentTermsKey
	left outer join tInvoice i (nolock) on b.InvoiceKey = i.InvoiceKey
	left outer join tClass cl (nolock) on b.ClassKey = cl.ClassKey
	left outer join tGLCompany glc (nolock) on b.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on b.OfficeKey = o.OfficeKey
	left outer join tBillingGroup bg (nolock) on b.EntityKey = bg.BillingGroupKey
	left outer join tBillingGroup bgg (nolock) on b.GroupEntityKey = bgg.BillingGroupKey
GO
