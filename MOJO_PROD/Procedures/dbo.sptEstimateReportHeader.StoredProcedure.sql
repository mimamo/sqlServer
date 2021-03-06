USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateReportHeader]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptEstimateReportHeader]

	(
		@EstimateKey int
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 04/26/07 GHL 8.5   Added LaborGross and ExpenseGross for 2 new subtotals on estimate report
  || 03/17/10 GHL 10.520 Changed inner join with tProject to left join
  || 08/17/10 GHL 10.534 Added handling of 'By Project Only' case
  || 09/13/10 GHL 10.535 Replaced subquery by left join for header info (syntax not working on SQL 2000)
  || 06/07/11 GHL 10.545 Modified logic for company address (use GLCompany now)
  || 06/07/11 GHL 10.5.4.5 Added CompanyName/Phone/Fax from GL Company to be consistent
  ||                       with what we did for the POs vPurchaseOrderDetail (issue 37963)
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
  || 10/31/12 RLB 10.561 (158461) Added SelectedApproveQty
  || 01/10/14 GHL 10.576 Added currency ID
  || 12/30/14 GHL 10.587 (238741) Added CompareToOriginal to support enhancement for Giant Creative Strategy
  ||                     If CompareToOriginal=1 we must compare the current estimate to previous estimates
  */


/* Logic for the addresses same as for invoices

		' tInvoice.AddressKey			
		' tInvoiceTemplate.AddressKey
		' tCompany.BillingAddressKey (for client)
		' tCompany.DefaultAddressKey (for client)
		' tCompany.DefaultAddressKey (for signed company)

		' For the To Client Address (txtBillingAddress), use this logic:
		' 1) Use tInvoice.AddressKey if not null
		' 2) Use tCompany.BillingAddressKey (for client) if not null
		' 3) Use tCompany.DefaultAddressKey (for client) 

		' For the From Address (txtAddress), use this logic
		' If there is a template
		'	If tInvoiceTemplate.AddressKey is not null
		'		use it
		'	else
		'		Do not show the address
		' else
		'    if UseGLCompany and there is a GL company with an address
		'        use it
		'    else
		'	     Use tCompany.DefaultAddressKey (for signed company)
*/		

-- Estimate Types
	declare @kByTaskOnly int            select @kByTaskOnly = 1
	declare @kByTaskService int         select @kByTaskService = 2
	declare @kByTaskPerson int          select @kByTaskPerson = 3
	declare @kByServiceOnly int         select @kByServiceOnly = 4
	declare @kBySegmentService int      select @kBySegmentService = 5
	declare @kByProjectOnly int         select @kByProjectOnly = 6

declare @EstType int, @ApprovedQty int, @ProjectKey int, @CampaignKey int, @LeadKey int, @PrimaryContact varchar(250)
declare @TemplateProjectKey int, @CompanyKey int, @UseGLCompany int 
	
Select @EstType = EstType
       ,@ApprovedQty = ApprovedQty 
	   ,@ProjectKey = ProjectKey
	   ,@CampaignKey = CampaignKey
	   ,@LeadKey = LeadKey
	   ,@CompanyKey = CompanyKey
from tEstimate (nolock) Where EstimateKey = @EstimateKey

select @UseGLCompany = isnull(UseGLCompany, 0) from tPreference (nolock) where CompanyKey = @CompanyKey 

if @EstType = @kByProjectOnly
	select @ApprovedQty = 1 -- no support for multiple quantities for this case


-- labels on estimate header will not change because the client does not know if this is a project or campain or opp
-- keep same field names
create table #header_info(
    EstimateKey int null
	,ProjectNumber varchar(200) null
	,ProjectName varchar(200) null
	,Description text null -- this is the reason what we need a temp, cannot be a variable     
	,PrimaryContactKey int null
	,GLCompanyKey  int null
	,GLCAddressKey int null  
	,CurrencyID varchar(10) null
)


if @ProjectKey > 0
	insert #header_info(EstimateKey, ProjectNumber, ProjectName, Description, PrimaryContactKey, GLCompanyKey, GLCAddressKey, CurrencyID)
	select @EstimateKey, p.ProjectNumber, p.ProjectName, p.Description, p.BillingContact, p.GLCompanyKey, glc.AddressKey, p.CurrencyID
	from   tProject p (nolock)
		left outer join tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey
	where  p.ProjectKey = @ProjectKey
else if @CampaignKey > 0
	insert #header_info(EstimateKey, ProjectNumber, ProjectName, Description, PrimaryContactKey, CurrencyID)
	select @EstimateKey,CampaignID, CampaignName, Description, ContactKey, CurrencyID
	from   tCampaign (nolock)
	where  CampaignKey = @CampaignKey
else if @LeadKey > 0
begin
	select @TemplateProjectKey = isnull(TemplateProjectKey, 0)
	from   tLead (nolock)
	where  LeadKey = @LeadKey

	insert #header_info(EstimateKey, ProjectNumber, ProjectName, Description, PrimaryContactKey)
	select @EstimateKey, null, Subject, null, ContactKey
	from   tLead (nolock)
	where  LeadKey = @LeadKey

end

if @UseGLCompany = 0
	update #header_info set GLCompanyKey = null, GLCAddressKey = null 

select @PrimaryContact = FirstName + ' ' + LastName
from   tUser (nolock)
where  UserKey = (select min(PrimaryContactKey) from #header_info)

if @EstType = 1
	SELECT 
		tEstimate.CompanyKey,
		tEstimate.EstimateKey, 
		tEstimate.ProjectKey,
		tEstimate.CampaignKey,
		tEstimate.LeadKey,
		@TemplateProjectKey as TemplateProjectKey,
		  
		#header_info.ProjectName, --tProject.ProjectName, 
		#header_info.ProjectNumber, --tProject.ProjectNumber, 
		#header_info.Description, --tProject.Description,
		#header_info.CurrencyID,

		isnull(c.BillingName,c.CompanyName) AS ClientName, 

		-- Billing Address 1) Address on Estimate, 2) Client Billing Address, 3) Client Default Address
		CASE
			WHEN tEstimate.AddressKey IS NOT NULL THEN a_e.Address1 
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address1 ELSE a_dc.Address1 END 
		END  AS ClientAddress1, 
		CASE
			WHEN tEstimate.AddressKey IS NOT NULL THEN a_e.Address2 
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address2 ELSE a_dc.Address2 END 
		END  AS ClientAddress2, 
		CASE
			WHEN tEstimate.AddressKey IS NOT NULL THEN a_e.Address3 
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address3 ELSE a_dc.Address3 END 
		END  AS ClientAddress3, 
		CASE
			WHEN tEstimate.AddressKey IS NOT NULL THEN a_e.City 
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.City ELSE a_dc.City END 
		END  AS ClientCity, 
		CASE   
			WHEN tEstimate.AddressKey IS NOT NULL THEN a_e.State 
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.State ELSE a_dc.State END 
		END  AS ClientState, 
		CASE   
			WHEN tEstimate.AddressKey IS NOT NULL THEN a_e.PostalCode 
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.PostalCode ELSE a_dc.PostalCode END 
		END  AS ClientPostalCode, 
		CASE   
			WHEN tEstimate.AddressKey IS NOT NULL THEN a_e.Country 
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Country ELSE a_dc.Country END 
		END  AS ClientCountry, 
		et.AddressKey, -- If null, do not show company address on report (just logo)
		
		c1.CompanyName, 
		c1.Phone,
		c1.Fax,

		glc.GLCompanyKey,
		glc.PrintedName as GLCCompanyName, 
		glc.Phone as GLCPhone,
		glc.Fax as GLCFax,

		-- Company Address
		CASE WHEN et.AddressKey IS NOT NULL THEN a_et.Address1 
			ELSE CASE WHEN a_glc.AddressKey IS NOT NULL THEN a_glc.Address1 ELSE a_c1.Address1 END END AS Address1,
 		CASE WHEN et.AddressKey IS NOT NULL THEN a_et.Address2 
			ELSE CASE WHEN a_glc.AddressKey IS NOT NULL THEN a_glc.Address2 ELSE a_c1.Address2 END END AS Address2,
 		CASE WHEN et.AddressKey IS NOT NULL THEN a_et.Address3 
			ELSE CASE WHEN a_glc.AddressKey IS NOT NULL THEN a_glc.Address3 ELSE a_c1.Address3 END END AS Address3,
 		CASE WHEN et.AddressKey IS NOT NULL THEN a_et.City 
			ELSE CASE WHEN a_glc.AddressKey IS NOT NULL THEN a_glc.City ELSE a_c1.City END END AS City,
 		CASE WHEN et.AddressKey IS NOT NULL THEN a_et.State 
			ELSE CASE WHEN a_glc.AddressKey IS NOT NULL THEN a_glc.State ELSE a_c1.State END END AS State,
 		CASE WHEN et.AddressKey IS NOT NULL THEN a_et.PostalCode 
			ELSE CASE WHEN a_glc.AddressKey IS NOT NULL THEN a_glc.PostalCode ELSE a_c1.PostalCode END END AS PostalCode,
 		CASE WHEN et.AddressKey IS NOT NULL THEN a_et.Country 
			ELSE CASE WHEN a_glc.AddressKey IS NOT NULL THEN a_glc.Country ELSE a_c1.Country END END AS Country,
 		
		tEstimate.EstimateName, 
		tEstimate.EstimateNumber, 
		tEstimate.EstimateDate, 
		tEstimate.DeliveryDate, 
		tEstimate.Revision, 
		tEstimate.EstType, 
		tEstimate.EstDescription,
		tEstimate.EstimateTemplateKey,
		tEstimate.SalesTaxAmount,
		tEstimate.SalesTaxKey,
		st.Description as SalesTaxName,
		st.TaxRate As TaxRate,
		tEstimate.SalesTax2Amount,
		tEstimate.SalesTax2Key,
		st2.Description as SalesTax2Name,
		st2.TaxRate as Tax2Rate,
		CASE WHEN tEstimate.PrimaryContactKey IS NULL THEN @PrimaryContact -- u_p.FirstName + ' ' + u_p.LastName
		     ELSE u_e.FirstName + ' ' + u_e.LastName END as PrimaryContactName,
		ISNULL((Select Sum(EstLabor) from tEstimateTask (nolock) Where EstimateKey = @EstimateKey),0) as TaskLabor,
		ISNULL((Select Sum(EstExpenses) from tEstimateTask (nolock) Where EstimateKey = @EstimateKey),0) as TaskExpense,
		ISNULL((Select Sum(BillableCost) from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey),0) as TaskExpense1,
		ISNULL((Select Sum(BillableCost2) from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey),0) as TaskExpense2,
		ISNULL((Select Sum(BillableCost3) from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey),0) as TaskExpense3,
		ISNULL((Select Sum(BillableCost4) from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey),0) as TaskExpense4,
		ISNULL((Select Sum(BillableCost5) from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey),0) as TaskExpense5,
		ISNULL((Select Sum(BillableCost6) from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey),0) as TaskExpense6,
		0 as TaxableExpense,
		ISNULL((Select Sum(EstLabor) * tEstimate.Contingency / 100 from tEstimateTask (nolock) Where EstimateKey = @EstimateKey),0) as ContingencyAmount,
		ISNULL(tEstimate.ApprovedQty, 1) as SelectedApprovedQty,
		tEstimate.Expense1,
		tEstimate.Expense2,
		tEstimate.Expense3,
		tEstimate.Expense4,
		tEstimate.Expense5,
		tEstimate.Expense6,
		tEstimate.Contingency,
		tEstimate.LaborGross,
		tEstimate.ExpenseGross,		
		(Select count(*) from tEstimateTaskExpense (nolock) where EstimateKey = @EstimateKey) As ExpenseCount,
		internal_a.FirstName + ' ' + internal_a.LastName as InternalApproverName,
		external_a.FirstName + ' ' + external_a.LastName as ExternalApproverName,
		tEstimate.InternalStatus,
		tEstimate.ExternalStatus,
		tEstimate.UserDefined1,
		tEstimate.UserDefined2,
		tEstimate.UserDefined3,
		tEstimate.UserDefined4,
		tEstimate.UserDefined5,
		tEstimate.UserDefined6,
		tEstimate.UserDefined7,
		tEstimate.UserDefined8,
		tEstimate.UserDefined9,
		tEstimate.UserDefined10,
		cp.ProductName,
		cd.DivisionName,
		isnull(et.CompareToOriginal, 0) as CompareToOriginal
	FROM 
		tEstimate (nolock) 
		INNER JOIN vEstimateClient vc (nolock) on tEstimate.EstimateKey = vc.EstimateKey
		LEFT OUTER JOIN tProject (nolock) ON tEstimate.ProjectKey = tProject.ProjectKey -- still needed for product and division
        LEFT OUTER JOIN #header_info ON tEstimate.EstimateKey = #header_info.EstimateKey
		--Left Outer join tUser u_p (nolock) on u_p.UserKey = tProject.BillingContact
		Left Outer join tUser u_e (nolock) on u_e.UserKey = tEstimate.PrimaryContactKey		
		Left Outer join tUser internal_a (nolock) on tEstimate.InternalApprover = internal_a.UserKey
		Left Outer join tUser external_a (nolock) on tEstimate.ExternalApprover = external_a.UserKey
		left outer join tSalesTax st (nolock) on tEstimate.SalesTaxKey = st.SalesTaxKey
		left outer join tSalesTax st2 (nolock) on tEstimate.SalesTax2Key = st2.SalesTaxKey
		INNER JOIN tCompany c1 (nolock) ON tEstimate.CompanyKey = c1.CompanyKey 
		LEFT OUTER JOIN tCompany c (nolock) ON vc.ClientKey = c.CompanyKey
		LEFT OUTER JOIN tGLCompany glc (nolock) ON #header_info.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tEstimateTemplate et (nolock) ON tEstimate.EstimateTemplateKey = et.EstimateTemplateKey 
		LEFT OUTER JOIN tAddress a_c1 (nolock) ON c1.DefaultAddressKey = a_c1.AddressKey
		LEFT OUTER JOIN tAddress a_dc (nolock) ON c.DefaultAddressKey = a_dc.AddressKey
		LEFT OUTER JOIN tAddress a_bc (nolock) ON c.BillingAddressKey = a_bc.AddressKey  
		LEFT OUTER JOIN tAddress a_et (nolock) ON et.AddressKey = a_et.AddressKey	
		LEFT OUTER JOIN tAddress a_e (nolock) ON tEstimate.AddressKey = a_e.AddressKey
		left outer Join tAddress a_glc (nolock) on #header_info.GLCAddressKey = a_glc.AddressKey
		left outer join tClientProduct cp (nolock) on tProject.ClientProductKey = cp.ClientProductKey
		left outer join tClientDivision cd (nolock) on tProject.ClientDivisionKey = cd.ClientDivisionKey

	Where tEstimate.EstimateKey = @EstimateKey

ELSE

	SELECT 
		tEstimate.CompanyKey,
		tEstimate.EstimateKey, 
		tEstimate.ProjectKey,
		tEstimate.CampaignKey,
		tEstimate.LeadKey,
		@TemplateProjectKey as TemplateProjectKey,
		
		#header_info.ProjectName, --tProject.ProjectName, 
		#header_info.ProjectNumber, --tProject.ProjectNumber, 
		#header_info.Description, --tProject.Description,
		#header_info.CurrencyID,

		-- Billing Address
		isnull(c.BillingName,c.CompanyName) AS ClientName, 
		CASE
			WHEN tEstimate.AddressKey IS NOT NULL THEN a_e.Address1 
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address1 ELSE a_dc.Address1 END 
		END  AS ClientAddress1, 
		CASE
			WHEN tEstimate.AddressKey IS NOT NULL THEN a_e.Address2 
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address2 ELSE a_dc.Address2 END 
		END  AS ClientAddress2, 
		CASE
			WHEN tEstimate.AddressKey IS NOT NULL THEN a_e.Address3 
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address3 ELSE a_dc.Address3 END 
		END  AS ClientAddress3, 
		CASE
			WHEN tEstimate.AddressKey IS NOT NULL THEN a_e.City 
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.City ELSE a_dc.City END 
		END  AS ClientCity, 
		CASE   
			WHEN tEstimate.AddressKey IS NOT NULL THEN a_e.State 
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.State ELSE a_dc.State END 
		END  AS ClientState, 
		CASE   
			WHEN tEstimate.AddressKey IS NOT NULL THEN a_e.PostalCode 
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.PostalCode ELSE a_dc.PostalCode END 
		END  AS ClientPostalCode, 
		CASE   
			WHEN tEstimate.AddressKey IS NOT NULL THEN a_e.Country 
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Country ELSE a_dc.Country END 
		END  AS ClientCountry, 
		et.AddressKey, -- If null, do not show company address on report (just logo)
		
		c1.CompanyName, 
		c1.Phone,
		c1.Fax,

		glc.GLCompanyKey,
		glc.PrintedName as GLCCompanyName, 
		glc.Phone as GLCPhone,
		glc.Fax as GLCFax,

		-- Company Address
		CASE WHEN et.AddressKey IS NOT NULL THEN a_et.Address1 
			ELSE CASE WHEN a_glc.AddressKey IS NOT NULL THEN a_glc.Address1 ELSE a_c1.Address1 END END AS Address1,
 		CASE WHEN et.AddressKey IS NOT NULL THEN a_et.Address2 
			ELSE CASE WHEN a_glc.AddressKey IS NOT NULL THEN a_glc.Address2 ELSE a_c1.Address2 END END AS Address2,
 		CASE WHEN et.AddressKey IS NOT NULL THEN a_et.Address3 
			ELSE CASE WHEN a_glc.AddressKey IS NOT NULL THEN a_glc.Address3 ELSE a_c1.Address3 END END AS Address3,
 		CASE WHEN et.AddressKey IS NOT NULL THEN a_et.City 
			ELSE CASE WHEN a_glc.AddressKey IS NOT NULL THEN a_glc.City ELSE a_c1.City END END AS City,
 		CASE WHEN et.AddressKey IS NOT NULL THEN a_et.State 
			ELSE CASE WHEN a_glc.AddressKey IS NOT NULL THEN a_glc.State ELSE a_c1.State END END AS State,
 		CASE WHEN et.AddressKey IS NOT NULL THEN a_et.PostalCode 
			ELSE CASE WHEN a_glc.AddressKey IS NOT NULL THEN a_glc.PostalCode ELSE a_c1.PostalCode END END AS PostalCode,
 		CASE WHEN et.AddressKey IS NOT NULL THEN a_et.Country 
			ELSE CASE WHEN a_glc.AddressKey IS NOT NULL THEN a_glc.Country ELSE a_c1.Country END END AS Country,
 		
		tEstimate.EstimateName, 
		tEstimate.EstimateNumber, 
		tEstimate.EstimateDate, 
		tEstimate.DeliveryDate, 
		tEstimate.Revision, 
		tEstimate.EstType, 
		tEstimate.EstDescription,
		tEstimate.EstimateTemplateKey,

		tEstimate.SalesTaxAmount,
		
		case when @EstType = @kByProjectOnly then 
		   case when isnull(tEstimate.SalesTaxAmount, 0) = 0 then 0 else 1 end
		else tEstimate.SalesTaxKey end as SalesTaxKey,

		case when @EstType = @kByProjectOnly then 
		   case when isnull(tEstimate.SalesTaxAmount, 0) = 0 then '' else 'Sales Tax 1' end
		else st.Description end as SalesTaxName,
		
		st.TaxRate As TaxRate,

		tEstimate.SalesTax2Amount,
		
		case when @EstType = @kByProjectOnly then 
		   case when isnull(tEstimate.SalesTax2Amount, 0) = 0 then 0 else 1 end
		else tEstimate.SalesTax2Key end as SalesTax2Key,
		
		case when @EstType = @kByProjectOnly then 
		   case when isnull(tEstimate.SalesTax2Amount, 0) = 0 then '' else 'Sales Tax 2' end
		else st2.Description end as SalesTax2Name,
		
		st2.TaxRate as Tax2Rate,
		
		CASE WHEN tEstimate.PrimaryContactKey IS NULL THEN @PrimaryContact -- u_p.FirstName + ' ' + u_p.LastName
		     ELSE u_e.FirstName + ' ' + u_e.LastName END as PrimaryContactName,

        case when @EstType = @kByProjectOnly then tEstimate.LaborGross else
		ISNULL((Select Sum(Round(Hours * Rate,2)) from tEstimateTaskLabor Where EstimateKey = @EstimateKey),0) end as TaskLabor,
		
		case when @EstType = @kByProjectOnly then tEstimate.ExpenseGross else
		ISNULL((Select Sum(case 
				when @ApprovedQty = 1 Then BillableCost
				when @ApprovedQty = 2 Then BillableCost2
				when @ApprovedQty = 3 Then BillableCost3
				when @ApprovedQty = 4 Then BillableCost4
				when @ApprovedQty = 5 Then BillableCost5
				when @ApprovedQty = 6 Then BillableCost6											 
				end)
		from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey),0) end as TaskExpense,	 
		
		case when @EstType = @kByProjectOnly then tEstimate.ExpenseGross else
		ISNULL((Select Sum(BillableCost) from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey),0) end as TaskExpense1,
		
		case when @EstType = @kByProjectOnly then tEstimate.ExpenseGross else
		ISNULL((Select Sum(BillableCost2) from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey),0) end as TaskExpense2,
		
		case when @EstType = @kByProjectOnly then tEstimate.ExpenseGross else
		ISNULL((Select Sum(BillableCost3) from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey),0) end as TaskExpense3,
		
		case when @EstType = @kByProjectOnly then tEstimate.ExpenseGross else
		ISNULL((Select Sum(BillableCost4) from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey),0) end as TaskExpense4,
		
		case when @EstType = @kByProjectOnly then tEstimate.ExpenseGross else
		ISNULL((Select Sum(BillableCost5) from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey),0) end as TaskExpense5,
		
		case when @EstType = @kByProjectOnly then tEstimate.ExpenseGross else
		ISNULL((Select Sum(BillableCost6) from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey),0) end as TaskExpense6,
		
		case when @EstType = @kByProjectOnly then tEstimate.ExpenseGross else
		ISNULL((Select Sum(BillableCost) from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey and Taxable = 1),0) end as TaxableExpense,
		
		case when @EstType = @kByProjectOnly then tEstimate.ContingencyTotal else
		ISNULL((Select Sum(Hours * Rate) * tEstimate.Contingency / 100 from tEstimateTaskLabor (nolock) Where EstimateKey = @EstimateKey),0) end as ContingencyAmount,
		
		tEstimate.Expense1,
		case when @EstType = @kByProjectOnly then '' else tEstimate.Expense2 end as Expense2,
		case when @EstType = @kByProjectOnly then '' else tEstimate.Expense3 end as Expense3,
		case when @EstType = @kByProjectOnly then '' else tEstimate.Expense4 end as Expense4,
		case when @EstType = @kByProjectOnly then '' else tEstimate.Expense5 end as Expense5,
		case when @EstType = @kByProjectOnly then '' else tEstimate.Expense6 end as Expense6,

		tEstimate.Contingency,
		tEstimate.LaborGross,
		tEstimate.ExpenseGross,	
		ISNULL(tEstimate.ApprovedQty, 1) as SelectedApprovedQty,	
		
		case when @EstType = @kByProjectOnly then  
			case when tEstimate.ExpenseGross <> 0 then 1 else 0 end
		else
		(Select count(*) from tEstimateTaskExpense (nolock) where EstimateKey = @EstimateKey) end As ExpenseCount,

		internal_a.FirstName + ' ' + internal_a.LastName as InternalApproverName,
		external_a.FirstName + ' ' + external_a.LastName as ExternalApproverName,
		tEstimate.InternalStatus,
		tEstimate.ExternalStatus,
		tEstimate.UserDefined1,
		tEstimate.UserDefined2,
		tEstimate.UserDefined3,
		tEstimate.UserDefined4,
		tEstimate.UserDefined5,
		tEstimate.UserDefined6,
		tEstimate.UserDefined7,
		tEstimate.UserDefined8,
		tEstimate.UserDefined9,
		tEstimate.UserDefined10,
		cp.ProductName,
		cd.DivisionName,
		isnull(et.CompareToOriginal, 0) as CompareToOriginal
	FROM 
		tEstimate (nolock) 
		INNER JOIN vEstimateClient vc (nolock) on tEstimate.EstimateKey = vc.EstimateKey
		LEFT JOIN tProject (nolock) ON tEstimate.ProjectKey = tProject.ProjectKey -- still needed for product and division
		LEFT OUTER JOIN #header_info ON tEstimate.EstimateKey = #header_info.EstimateKey
		Left Outer join tUser u_p (nolock) on u_p.UserKey = tProject.BillingContact
		Left Outer join tUser u_e (nolock) on u_e.UserKey = tEstimate.PrimaryContactKey		
		Left Outer join tUser internal_a (nolock) on tEstimate.InternalApprover = internal_a.UserKey
		Left Outer join tUser external_a (nolock) on tEstimate.ExternalApprover = external_a.UserKey
		left outer join tSalesTax st (nolock) on tEstimate.SalesTaxKey = st.SalesTaxKey
		left outer join tSalesTax st2 (nolock) on tEstimate.SalesTax2Key = st2.SalesTaxKey
		INNER JOIN tCompany c1 (nolock) ON tEstimate.CompanyKey = c1.CompanyKey 
		LEFT OUTER JOIN tCompany c (nolock) ON vc.ClientKey = c.CompanyKey
		LEFT OUTER JOIN tGLCompany glc (nolock) ON #header_info.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tEstimateTemplate et (nolock) ON tEstimate.EstimateTemplateKey = et.EstimateTemplateKey 
		LEFT OUTER JOIN tAddress a_c1 (nolock) ON c1.DefaultAddressKey = a_c1.AddressKey
		LEFT OUTER JOIN tAddress a_dc (nolock) ON c.DefaultAddressKey = a_dc.AddressKey
		LEFT OUTER JOIN tAddress a_bc (nolock) ON c.BillingAddressKey = a_bc.AddressKey  
		LEFT OUTER JOIN tAddress a_et (nolock) ON et.AddressKey = a_et.AddressKey	
		LEFT OUTER JOIN tAddress a_e (nolock) ON tEstimate.AddressKey = a_e.AddressKey
		left outer Join tAddress a_glc (nolock) on #header_info.GLCAddressKey = a_glc.AddressKey
		left outer join tClientProduct cp (nolock) on tProject.ClientProductKey = cp.ClientProductKey
		left outer join tClientDivision cd (nolock) on tProject.ClientDivisionKey = cd.ClientDivisionKey

	Where tEstimate.EstimateKey = @EstimateKey
GO
