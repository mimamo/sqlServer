USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectBudgetAnalysisMulti]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProjectBudgetAnalysisMulti]
	(
		@CompanyKey int
		,@StartDate datetime = null
		,@EndDate datetime = null 
		
		-- Now copy of the flags to spRptProjectBudgetAnalysis 
		,@Budget int = 1
		
		,@Hours int = 0
		,@HoursBilled int = 0
		,@HoursInvoiced int = 0
		,@LaborNet int = 0
		,@LaborGross int = 0
		,@LaborBilled int = 0			
		,@LaborInvoiced int = 0			
		,@LaborUnbilled int = 0			
		,@LaborWriteOff int = 0		
		
		,@OpenOrdersNet int = 0
		,@OutsideCostsNet int = 0
		,@InsideCostsNet int = 0
		
		,@OpenOrdersGrossUnbilled int = 0
		,@OutsideCostsGrossUnbilled int = 0
		,@InsideCostsGrossUnbilled int = 0
		
		,@OutsideCostsGross int = 0
		,@InsideCostsGross int = 0
				
		,@AdvanceBilled int = 0
		,@AdvanceBilledOpen int = 0
		,@AmountBilled int = 0
		,@BilledDifference int = 0
		
		,@ExpenseWriteOff int = 0	
		,@ExpenseBilled int = 0		
		,@ExpenseInvoiced int = 0		
		
		,@TransferInLabor int = 0
		,@TransferOutLabor int = 0
		,@TransferInExpense int = 0
		,@TransferOutExpense int = 0

		,@AllocatedHours int = 0
		,@FutureAllocatedHours int = 0
		,@AllocatedGross int = 0
		,@FutureAllocatedGross int = 0

		,@BGBCustomization int = 0 -- calcs for customization for BGB are requested
	)
AS --Encrypt
	SET NOCOUNT ON
	
  /*
  || When     Who Rel   What
  || 10/17/07 GHL 8.5	Creation for new budget analysis 
  || 11/01/07 GHL 8.5   Added error checking
  || 11/06/07 GHL 8.5   Added flags that indicate which calculations should be performed  
  || 06/19/08 GHL 8.514 (28420) Corrected joins with ClientDivision/ClientProduct 
  || 08/08/08 GHL 10.0.0.6 (30969) Added Expense Write Off
  || 10/21/08 CRG 10.0.1.1 (37032) Added ClassID and ClassName
  || 10/14/09 GHL 10.512   (64397) Added ExpenseBilled  
  || 12/09/09 GHL 10.514   (69441) Added HoursInvoiced, LaborInvoiced, ExpenseInvoiced
  || 03/08/11 GHL 10.542   (105027) Added transfer numbers
  || 07/27/11 RLB 10.546 (111324) Added Campaign Segment
  || 02/24/12 MFT 10.553 (134500) Corrected join on tGLCompany UPDATE statment
  || 04/09/12 GHL 10.555 (139169) Added ClientProjectNumber + NonBillable fields
  || 06/20/12 RLB 10.557 (146831) Added Project Status Notes
  || 09/24/12 GHL 10.560 (149474) Added logic for BGB customization
  || 11/15/12 WDF 10.562 (154732) Added ProjectBillingStatus
  || 08/27/13 GHL 10.571 Added CurrencyID for multi currency
  || 01/21/14 GHL 10.576 Leave CurrencyID blank if home currency (consistent with other reports)
  || 01/20/15 GWG 10.588 Added billing group code
  || 03/10/15 WDF 10.590 (240546) Added BillingMethod
  */
	
	/*
	|| 1) Update ID fields like spRptProfitByProjectMulti does
	*/
	
	--update project related columns
	update #tRpt
	set  ProjectNumber = isnull(p.ProjectNumber, 'No Project')
		,ProjectName = isnull(p.ProjectName, 'No Project')
		,ProjectStatusNotes = isnull(p.StatusNotes, '')
		,ProjectTypeName = pt.ProjectTypeName
		,CampaignID = cmp.CampaignID
		,CampaignName = cmp.CampaignName
		,CampaignSegment = cs.SegmentName
		,DivisionName = d.DivisionName
		,ProductName = prd.ProductName
		,ClassKey = p.ClassKey
		,ClientProjectNumber = isnull(p.ClientProjectNumber, 'No Client Project')
	    ,NonBillable =case when p.NonBillable = 1 then 'YES' else 'NO' end 
		,CurrencyID = p.CurrencyID
		,BillingGroupCode = bg.BillingGroupCode
		,BillingMethod = Case p.BillingMethod When 1 then 'Time and Materials' 
	                          When 2 then 'Fixed Fee' 
	                          When 3 then 'Retainer' 
	                      end
	from tProject p (nolock)
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tCampaign cmp (nolock) on p.CampaignKey = cmp.CampaignKey
	left outer join tClientDivision d (nolock) on p.ClientDivisionKey = d.ClientDivisionKey
	left outer join tClientProduct prd (nolock) on p.ClientProductKey = prd.ClientProductKey
	left outer join tGLCompany glc (NOLOCK) on p.GLCompanyKey = glc.GLCompanyKey
	left outer join tCampaignSegment cs (nolock) on p.CampaignSegmentKey = cs.CampaignSegmentKey 
	left outer join tBillingGroup bg (nolock) on p.BillingGroupKey = bg.BillingGroupKey
	where #tRpt.ProjectKey = p.ProjectKey

	--update Account Manager
	update #tRpt
	set  AccountManager = am.FirstName + ' ' + am.LastName
	from tProject p (nolock)
	left outer join tUser am (nolock) on p.AccountManager = am.UserKey 
	where #tRpt.ProjectKey = p.ProjectKey

	--update client related columns
	update #tRpt
	set  ClientID = 'No Client'
		,ClientName = 'No Client'
	where ISNULL(#tRpt.ClientKey, 0) = 0
	
	update #tRpt
	set  ParentClientID = pcl.CustomerID
		,ParentClientName = pcl.CompanyName
		,ClientID = cl.CustomerID
		,ClientName = cl.CompanyName
	from tCompany cl (nolock) 
	left outer join tCompany pcl (nolock) on cl.ParentCompanyKey = pcl.CompanyKey
	where #tRpt.ClientKey = cl.CompanyKey
	
	--update GLCompany related columns
	update #tRpt
	set GLCompanyName = 'No Company'
	where ISNULL(GLCompanyKey, 0) = 0
	
	update #tRpt
	set GLCompanyName = glc.GLCompanyName
	from tGLCompany glc (nolock)
	where #tRpt.GLCompanyKey = glc.GLCompanyKey

    --update ProjectBillingStatus related columns
 	update #tRpt
	set ProjectBillingStatusFullName = 'No Billing Status'
	where ISNULL(ProjectBillingStatusKey, 0) = 0

	update #tRpt
	set ProjectBillingStatusFullName = ProjectBillingStatus + '-' + ProjectBillingStatusID
	from tProjectBillingStatus pbs (nolock)
	where #tRpt.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
	
	--update Office related columns
	update #tRpt
	set OfficeName = 'No Office'
	where ISNULL(#tRpt.OfficeKey, 0) = 0
	
	update #tRpt
	set OfficeName = o.OfficeName
	from tOffice o (nolock) 
	where #tRpt.OfficeKey = o.OfficeKey

	--update Class related columns
	update	#tRpt
	set		ClassID = 'No Class',
			ClassName = 'No Class'
	where	#tRpt.ClassKey is null
	
	update	#tRpt
	set		ClassID = c.ClassID,
			ClassName = c.ClassName
	from	tClass c (nolock) 
	where	#tRpt.ClassKey = c.ClassKey
	
	/*
	|| 2) Now perform calculations for all the fields 
	*/

-- vars for budget analysis
DECLARE @ProjectKey int
		,@GroupBy int
		,@NullEntityOnInvoices int  -- If 1 include the lines where Entity is null (fixed fee) 

-- Query everything for now, maybe we can be smarter later and determine which fields are really needed
SELECT 	@ProjectKey = NULL
		,@GroupBy = 1 -- By Project
		,@NullEntityOnInvoices = 1 -- only used if we group by task or service/item
		
DECLARE @RetVal int	
EXEC  @RetVal = spRptProjectBudgetAnalysis @CompanyKey 
		,@ProjectKey
		,@StartDate
		,@EndDate 
		,@GroupBy 
		,@NullEntityOnInvoices 		
		,@Budget  
		,@Hours 
		,@HoursBilled 
		,@HoursInvoiced 
		,@LaborNet 
		,@LaborGross 
		,@LaborBilled
		,@LaborInvoiced		
		,@LaborUnbilled 			
		,@LaborWriteOff 		
		,@OpenOrdersNet  
		,@OutsideCostsNet  
		,@InsideCostsNet  
		,@OpenOrdersGrossUnbilled  
		,@OutsideCostsGrossUnbilled  
		,@InsideCostsGrossUnbilled  
		,@OutsideCostsGross  
		,@InsideCostsGross  
		,@AdvanceBilled  
		,@AdvanceBilledOpen  
		,@AmountBilled  		
		,@BilledDifference		
		,@ExpenseWriteOff 		
		,@ExpenseBilled 		
		,@ExpenseInvoiced 		
		,@TransferInLabor
		,@TransferOutLabor
		,@TransferInExpense
		,@TransferOutExpense
		,@AllocatedHours
		,@FutureAllocatedHours
		,@AllocatedGross
		,@FutureAllocatedGross
		,@BGBCustomization

	RETURN @RetVal
GO
