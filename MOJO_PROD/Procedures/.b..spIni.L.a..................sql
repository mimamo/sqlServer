USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spInitLoad]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spInitLoad]
	@List varchar(100),
	@CheckTime smalldatetime,
	@CompanyKey int,
	@UserKey int

AS --Encrypt

/*
|| When       Who Rel     What
||  2/25/08   CRG 1.0.0.0 Created to combine all of the InitLoad SP's into one.
||  4/03/08   RTC 1.0.0.0 Modified the 'listings' entity to return all reports, not just user's private reports
||                        and public reports with security group access. 
||  4/21/08   CRG 1.0.0.0 Added tTeam 
||  4/21/08   RTC 1.0.0.0 Limited tRptSecurityGroup to only user's security group 
||  4/24/08   CRG 1.0.0.0 (25387) Added columns to tProjectStatus and tProjectBillingStatus for compatibility with 85.
||  5/6/08    CRG 1.0.0.0 Added CompanyKey restriction for Listings
||  5/22/08   GWG 10.0.0.1 Added User Skills, specialties and Service mapping (not used in time entry)
||  5/22/08   GWG 10.0.0.1 Added User Skills, specialties and Service mapping (not used in time entry)
||  7/03/08   QMD 10.0.0.4 Add Where (w.CompanyKey is null or w.CompanyKey = @CompanyKey) to widget select
||  7/20/08   GWG 10.5.0.0 Added additional standard lists for contact mgt.
||  7/24/08   GHL 10.5.0.0 Added Source for companies  
||  7/28/08   GHL 10.5.0.0 Added folder list for companies
||  7/29/08   QMD 10.5.0.0 Added select for tUserRole
||  8/11/08	  GWG 10.5.0.0 Added UserLeadFolders
||  8/28/08   CRG 10.5.0.0 Added DistributionGroups and CalendarResources
||  9/24/08   GWG 01.5.0.0 Added Sales Taxes, invoice templates, estimate templates
|| 10/02/09   RTC 10.0.1.0 Added tViewSecurity
|| 10/17/08   GWG 10.0.1.1 Added all full users into the list of users otherwise a contact with full rights can not use the system in places
|| 10/29/08   GWG 10.5     Added folder type for the lead folders
|| 12/02.08   RTC 10.5     Changed the way contact folders are retrieved
|| 01/16/09   RTC 10.0.1.6 Added CompanyKey to where clause on tReport get
||  1/19/09   CRG 10.0.1.7 (44519) Now sorting GLAccounts by AccountNumber then AccountName
|| 02/20/09   GWG 10.5	   Added ActivityType
||  4/22/09   CRG 10.5.0.0 Added SyncDirection to tCMFolderContact
||  4/29/09   CRG 10.5.0.0 Added IncludeInSync and IsDefault to tCMFolderContact
||  5/11/09   GWG 10.5.0.0 Fixed the rights call on the contact folder list
||  6/2/09    CRG 10.5.0.0 Added FormattedName for tSkill
||	6/9/09    MFT 10.5.0.0 Correct tCMFolderActivity CanView, CanAdd to be 1 when FolderType is personal
|| 06/12/09   MFT 10.0.2.7 (54605) Added project defaults to tClient: GLCompanyKey, GetRateFrom, TimeRateSheetKey, GetMarkupFrom, ItemMarkup, IOCommission, BCCommission, IOBillAt, BCBillAt
||  7/28/09   CRG 10.5.0.5 Modified tSalesTax query for new screen
||  7/30/09   CRG 10.5.0.5 Added PayToID and PayToName to tSalesTax query for use by the Vendor lookup
||  7/31/09   CRG 10.5.0.6 Modified tSalesTax query because of new ID/Name ability in grids
||  8/6/09    CRG 10.5.0.6 Fixed PayToID for tSalesTax query, and modified sorting
||  8/6/09    MAS 10.5.0.7 Added Item Sales and Expense Name/Number columns to the tItem lookup
|| 8/24/09    CRG 10.5.0.8 (61327) Restricted personal tDistributionGroup records to the UserKey
|| 09/02/09   MAS 10.5.0.8 Added tMediaMarket
|| 9/2/09     CRG 10.5.0.9 Per Greg- Set all sorting of lists that contain an ID field to sort by ID first, then Name
|| 09/04/09   MAS 10.5.0.8 Added tMediaRevisionReason
|| 09/14/09   MAS 10.5.0.9 AddedtWriteOffReason
|| 09/15/09   MAS 10.5.0.9 tWorkType added SalesAccountNumber, SalesAccountName, ClaClassID and Class Name
|| 09/15/09   MAS 10.5.0.9 tItem added WorkTypeID, WorkTypeName and DepartmentName
|| 09/15/09   GHL 10.5.1.0 Added DepartmentKey to tWorkType
|| 09/15/09   GWG 10.5.1.0 Modified GL Account lookup to sort in display order so it looks like the chart of accounts
|| 09/28/09   MAS 10.5.0.9 tService added WorkTypeID, WorkTypeName and DepartmentName
|| 10/2/09    GWG 10.5.1.1 Modified tUser to include active, non client vendor logins w a password (should be ok at flynn wright)
|| 10/05/09   MAS 10.5.1.1 tClass added Office and Department fields.
|| 10/27/09   RLB 10.5.1.2 added Formated name to tInvoiceTemplate
|| 11/23/09   RLB 10.5.1.4 Modified tClient to pull more data.
|| 03/08/10   GHL 10.5.1.9 Added tEstimate list
|| 04/15/10   GHL 10.5.2.1 Added MultipleSegments to campaign list 
|| 04/18/10   GWG 10.5.2.2 Added default class name
|| 04/19/10   MAS 10.5.2.2 Added DefaultCashAccountName & DefaultExpenseAccountName
|| 04/20/10   MAS 10.5.2.2 Added UnappliedCashAccountName & DefaultSalesAccountName
|| 04/27/10   RLB 10.5.2.2 Added first order by Display order then Work Type ID on Work Types
|| 5/13/10    CRG 10.5.2.2 (80503) Added BillBy to the Campaign query
|| 6/1/10     CRG 10.5.3.1 Added ServiceDescription to User query
|| 6/21/10    GHL 10.5.3.1 Added AccountName for some accounts when querying tPreference 
|| 7/7/10     GWG 10.5.3.2 Added security group properties to the currentUser table
|| 07/20/10   MFT 10.5.3.2 Added POLineType list
|| 07/25/10   GWG 10.5.3.2 Added Default service code and name to current user
|| 07/27/10   MFT 10.5.3.2 Added UnappliedPaymentAccountName to preferences
|| 08/25/10   GHL 10.5.3.4 Added tLayout list
|| 09/03/10   GHL 10.5.3.4 Added DefaultARApproverName and DefaultAPApproverName 
|| 9/14/10    CRG 10.5.3.5 Modified tFormTemplate to only select for the Entity/EntityKey rather than for the entire company
|| 10/19/10   CRG 10.5.3.7 Added tTimelineSegment
|| 10/29/10   GHL 10.5.3.7 Added wip voucher income accounts 
|| 05/16/11   MAS 10.5.4.4 Added extra fields to "tGLAccount" for the Flex Admin Screen
|| 06/03/11   GHL 10.5.4.5 Added gl account info to tGLCompany query
|| 07/20/11   RLB 10.5.4.6 (116481) Added DefaultGLCompany information
|| 07/25/11   MFT 10.5.4.5 Added tAddress
|| 08/02/11   GHL 10.5.4.6 Added Item Type description to show on lookups
|| 08/04/11   GHL 10.5.4.6 Added Credit Card gl account with security in tGLAccountUser
|| 08/22/11   CRG 10.5.4.7 Added WebDavServerURL to tPreference for use in VB later
|| 08/30/11   GHL 10.5.4.4 Added tGLAccountUser, list of users who can use credit cards
|| 09/28/11   CRG 10.5.4.8 Added tWebDavServer
|| 10/05/11   CRG 10.5.4.8 Changed WebDavServerURL to WebDAVServerOptions in tPreference query
|| 10/20/11   GHL 10.5.4.9 Added tGLAccountCC for credit cards
|| 11/01/11   GHL 10.5.4.9 Added checking of security when pulling tGLAccountCC records
|| 02/02/12   GHL 10.5.5.2 Added POPrebillAccrualAccountName
|| 03/19/12   MFT 10.5.5.4 Added tCheckFormat
|| 03/20/12   GWG 10.5.5.4 Added in the access restrictions on GL Company and added in the GL Company mapping to the target company
|| 4/6/12     CRG 10.5.5.4 (138810) Added ProjectTemplates
|| 04/11/12   MAS 10.5.5.4 Added CCSetup flag to the tGLAccountCC list 
|| 05/08/12   GHL 10.5.5.6 Added office and department and gl comp info to tUser
|| 05/10/12   GHL 10.5.5.6 Added gl comp info to tGLAccount
|| 05/24/12   MFT 10.5.5.6 Added tFlatFile
|| 6/4/12     CRG 10.5.5.6 Added tPublishCalendar	   
|| 6/6/12     GHL 10.5.5.6 Added security to offices
|| 06/04/12   QMD 10.5.5.7 Added tGLAccount VisibleGLCompanyKey, NoJournalEntries into the select
|| 06/11/12   QMD 10.5.5.7 Added tGLAccount MultiCompanyPayments into the select
|| 07/6/12    GWG 10.5.5.7 Sorted items by type then id then name
|| 07/26/12   GHL 10.5.5.8 Added restrict to gl company to 3 lists tUser, tVendor, tClient for sublists on listings
||                         (other restricted lists are tOffice, tGLCompany and tGLCompanyMap)
|| 08/02/12   QMD 10.5.5.9 Added google info to tCMFolderContact
|| 08/15/12   GHL 10.5.5.9 Changed restrict logic in tGLAccount (use RestrictToGLCompany instead of VisibleGLCompanyKey)
|| 9/11/12    CRG 10.5.6.0 Added tColumnSet
|| 9/15/12    GWG 10.5.6.0 Removed the GL Company security option from the tGLCompany map for intercompany transactions
|| 09/25/12  GHL 10.5.6.0 Added tBillingGroup for HMI request
|| 10/02/12   GHL 10.5.6.0 Removed reference to tGLAccount.GLCompanyKey. GLCompanyKey is now on the Credit Card charge
|| 10/08/12   GHL 10.5.6.1 Added RestrictToGLCompany logic for credit cards
|| 10/23/12   GWG 10.5.6.1 Changed the sort on tClient to just be by name
|| 11/06/12   RLB 10.5.6.2 (158866) Sort on Project Number for Project Templates
|| 11/28/12   RLB 10.5.6.2 (160940) Added department on to currentuser
|| 01/11/13   QMD 10.5.6.4 Removed GoogleAPIVersion, GoogleClientID, GoogleClientSecret, GoogleRedirectURI
|| 04/15/13   GWG 10.5.6.6 Added DefaultCheckFormatKey to tGLAccount
|| 04/22/13   KMC 10.5.6.7 (175039) Added BackupExpenseApprover to currentUser
|| 05/20/13   GHL 10.5.6.8 (178882) Removed VisibleGLCompanyKey, has been replaced by RestrictToGLCompany/tGLCompanyAccess logic
|| 06/03/13   MAS 10.5.6.9 Added tMediaPrintPosition
|| 06/03/13   MAS 10.5.6.9 Added tMediaSpace
|| 06/03/13   MAS 10.5.6.9 Added tMediaDemographic
|| 06/03/13   MAS 10.5.6.9 Added tMediaCategory
|| 06/04/13   WDF 10.5.6.9 Added tMediaDays
|| 06/05/13   WDF 10.5.6.9 Added tMediaStdComment
|| 06/25/13   MAS 10.5.6.9 Added tMediaUnitType
|| 06/28/13   CRG 10.5.6.9 Added tCompanyMediaContract
|| 06/28/13   GWG 10.5.6.9 Added tMediaPremium
|| 08/06/13   MAS 10.5.6.9 Added tMediaBroadcastLength, tMediaDayPart
|| 08/21/13   GHL 10.5.7.1 Added tCurrency
|| 09/03/13   GHL 10.5.7.2 Removed CompanyKey from where clause when getting tCurrency. 
||                         The currency list is now a seeded list available to all companies
|| 09/12/13   GHL 10.5.7.2 Added tCurrencyCompany list of currencies for a company
|| 01/28/14   GHL 10.5.7.6 The list of foreign currencies should not include the home currency
|| 01/29/14   PLC 10.5.7.6 Added MediaAffiliate The list of networks for broadcast
|| 02/04/14   PLC 10.5.7.6 Added Days to tMediaDayPart
|| 03/13/14   GHL 10.5.7.8 Added tGLAccount.CurrencyID 
|| 03/21/14   GHL 10.5.7.8 Added 'tUserGLCompanyAccess' 
|| 09/12/14   WDF 10.5.8.4 Added 'tTitle'
|| 09/24/14   WDF 10.5.8.4 Added 'tTitleRateSheet' & 'tTitleRateSheetDetail' 
|| 10/07/14   CRG 10.5.8.5 Added CCDeliveryOption to 'tGLAccountCC'
|| 10/13/14   WDF 10.5.8.5 Added tWorkType and tGLAccount to select of tTitle
|| 11/20/14   WDF 10.5.8.7 In list 'widgets', suppress widget 'Traffic Forms' if not legacy
|| 04/23/15   GHL 10.5.9.1 (250967) Added tRequestRejectReason for enhancement for Kohls
|| 04/27/15   GWG 10.5.9.2 Added Activity Status for issue tracking.
|| 04/30/15   GWG 10.5.9.2 Removed extra fields. using a separate sp now
*/

DECLARE	@SecurityGroupKey int
DECLARE @Administrator int
DECLARE @RestrictToGLCompany int 

IF @List = 'tUser'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tUser (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
	BEGIN
		Select @RestrictToGLCompany = isnull(RestrictToGLCompany, 0) from tPreference (nolock) where CompanyKey = @CompanyKey

		select u.*
			  ,ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS UserName
			  ,ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS FormattedName
  			  ,SUBSTRING(ISNULL(u.FirstName, ''),1,1) + SUBSTRING(ISNULL(u.MiddleName, ''),1,1) + SUBSTRING(ISNULL(u.LastName, ''),1,1) AS Initials
			  ,ISNULL(u.DepartmentKey, 0)		AS IndexDepartmentKey	-- Clean keys for indexes (no nulls)
			  ,ISNULL(u.OfficeKey, 0)			AS IndexOfficeKey		-- Clean keys for indexes (no nulls)
			  ,0 AS ASC_Selected
			  ,s.Description AS ServiceDescription, s.ServiceCode
			  -- Added 3 fields below, mainly for HMI to restrict on user lookup
			  ,o.OfficeName	
			  ,d.DepartmentName
			  ,glc.GLCompanyID
			  ,glc.GLCompanyName
		from tUser u (nolock)
		left join tService s (nolock) on u.DefaultServiceKey = s.ServiceKey
		left join tOffice o (nolock) on u.OfficeKey = o.OfficeKey
		left join tDepartment d (nolock) on u.DepartmentKey = d.DepartmentKey
		left join tGLCompany glc (nolock) on u.GLCompanyKey = glc.GLCompanyKey
		where (
			u.CompanyKey = @CompanyKey 
			OR (u.OwnerCompanyKey = @CompanyKey and u.ClientVendorLogin = 0 and u.UserID is not null and u.Password is not null and u.Active = 1)
			)
		and (@RestrictToGLCompany = 0
			Or
			u.GLCompanyKey in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey)
			)
		order by u.FirstName, u.LastName

	END

	RETURN

END

IF @List = 'tUserGLCompanyAccess'
BEGIN
	IF EXISTS (SELECT 1 FROM tUser (nolock) where UserKey = @UserKey and Administrator = 1)
		SELECT GLCompanyKey FROM tGLCompany (nolock) where CompanyKey = @CompanyKey  
	ELSE
		SELECT GLCompanyKey FROM tUserGLCompanyAccess (nolock) where UserKey = @UserKey  
END

IF @List = 'tItem'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tItem (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select i.*,
			CASE
				WHEN ISNULL(i.ItemID, '') <> '' THEN ISNULL(i.ItemName, '') + '-' + ISNULL(i.ItemID, '')
				ELSE ISNULL(i.ItemName, '')
			END AS FormattedName, 
			gl.AccountNumber AS ExpenseAccountNumber,
			gl.AccountName AS ExpenseAccountName,
			gl2.AccountNumber AS SalesAccountNumber,
			gl2.AccountName AS SalesAccountName,
			c.ClassID,
			c.ClassName,
			wt.WorkTypeID, wt.WorkTypeName,
			d.DepartmentName,
			case 
				when i.ItemType = 0 then 'Purchase'
				when i.ItemType = 1 then 'Print'
				when i.ItemType = 2 then 'Broadcast'
				else 'Expense Report'
			end as ItemTypeDesc
		from tItem i(nolock) 
		Left Outer Join tGLAccount gl (nolock) on i.ExpenseAccountKey = gl.GLAccountKey
		Left Outer Join tWorkType wt (nolock) on i.WorkTypeKey = wt.WorkTypeKey
		Left outer Join tGLAccount gl2 (nolock) on i.SalesAccountKey = gl2.GLAccountKey
		Left outer Join tClass c (nolock) on i.ClassKey = c.ClassKey	
		Left outer Join tDepartment d (nolock) on i.DepartmentKey = d.DepartmentKey
		where i.CompanyKey = @CompanyKey 
		order by i.ItemType, i.ItemID, i.ItemName

	RETURN
END

IF @List = 'tService'
BEGIN

	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tService (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *,
			CASE
				WHEN ISNULL(ServiceCode, '') <> '' THEN ISNULL(tService.Description, '') + '-' + ISNULL(ServiceCode, '')
				ELSE ISNULL(tService.Description, '')
			END AS FormattedName,
			gl.AccountNumber AS SalesAccountNumber,
			gl.AccountName AS SalesAccountName,
			c.ClassID,
			c.ClassName,
			wt.WorkTypeID, wt.WorkTypeName,
			d.DepartmentName 
		 from tService (nolock) 
		 Left Outer Join tGLAccount gl (nolock) on tService.GLAccountKey = gl.GLAccountKey
		 Left Outer Join tWorkType wt (nolock) on tService.WorkTypeKey = wt.WorkTypeKey
		 Left outer Join tClass c (nolock) on tService.ClassKey = c.ClassKey	
		 Left outer Join tDepartment d (nolock) on tService.DepartmentKey = d.DepartmentKey	
		 Where tService.CompanyKey = @CompanyKey 	
		 order by ServiceCode, tService.Description

	RETURN
END

Declare @ServiceMode int
IF @List = 'tUserService'
BEGIN
	Select @SecurityGroupKey = SecurityGroupKey from tUser (nolock) Where UserKey = @UserKey
	if exists(Select null from tRight r (nolock) 
		inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
		Where r.RightID = 'timeallservices' and EntityKey = @SecurityGroupKey)
		Select @ServiceMode = 1
	else
		Select @ServiceMode = 0

	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tService (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
	BEGIN
		if @ServiceMode = 1
		select *,
				CASE
					WHEN ISNULL(ServiceCode, '') <> '' THEN ISNULL(Description, '') + '-' + ISNULL(ServiceCode, '')
					ELSE ISNULL(Description, '')
				END AS FormattedName 
			 from tService (nolock) Where CompanyKey = @CompanyKey 
			order by ServiceCode, Description
		else
		select *,
				CASE
					WHEN ISNULL(ServiceCode, '') <> '' THEN ISNULL(Description, '') + '-' + ISNULL(ServiceCode, '')
					ELSE ISNULL(Description, '')
				END AS FormattedName 
			 from tService s (nolock) 
			 inner join tUserService us (nolock) on s.ServiceKey = us.ServiceKey
			 Where CompanyKey = @CompanyKey and us.UserKey = @UserKey

			order by ServiceCode, Description
	END
	RETURN
END

IF @List = 'tUserServiceMap'
BEGIN
	Select 
		us.UserKey,
		us.ServiceKey
	from tUserService us (nolock)
	Inner Join tService s (nolock) on us.ServiceKey = s.ServiceKey
	Where
		s.CompanyKey = @CompanyKey

	RETURN
END





IF @List = 'tTimeRateSheet'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tTimeRateSheet (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *
		 from tTimeRateSheet (nolock) Where CompanyKey = @CompanyKey 
		order by RateSheetName

	RETURN
END

IF @List = 'tTimeRateSheetDetail'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tTimeRateSheet (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select tsd.*
		 from tTimeRateSheetDetail tsd (nolock) 
		 inner join tTimeRateSheet ts (nolock) on tsd.TimeRateSheetKey = ts.TimeRateSheetKey
		 Where CompanyKey = @CompanyKey 

	RETURN
END

IF @List = 'tGLAccount'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tGLAccount (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)

		BEGIN

			Select tGLAccount.GLAccountKey,
				tGLAccount.Active,
				tGLAccount.AccountNumber,
				tGLAccount.AccountName,
				tGLAccount.CompanyKey,
				ISNULL(tGLAccount.ParentAccountKey, 0) as ParentAccountKey, 
				CASE
					WHEN ISNULL(tGLAccount.AccountNumber, '') <> '' THEN ISNULL(tGLAccount.AccountName, '') + '-' + ISNULL(tGLAccount.AccountNumber, '')
					ELSE ISNULL(tGLAccount.AccountName, '')
				END AS FormattedName,
				CASE tGLAccount.AccountType
					WHEN 10 THEN 'Bank'
					WHEN 11 THEN 'Accounts Receivable'
					WHEN 12 THEN 'Current Asset'
					WHEN 13 THEN 'Fixed Asset'
					WHEN 14 THEN 'Other Asset'
					WHEN 20 THEN 'Accounts Payable'
					WHEN 21 THEN 'Current Liability'
					WHEN 22 THEN 'Long Term Liability'
					WHEN 23 THEN 'Credit Card'
					WHEN 30 THEN 'Equity - Does not Close'
					WHEN 31 THEN 'Equity - Closes'
					WHEN 32 THEN 'Retained Earnings'
					WHEN 40 THEN 'Income'
					WHEN 41 THEN 'Other Income'
					WHEN 50 THEN 'Cost of Goods Sold'
					WHEN 51 THEN 'Expenses'
					WHEN 52 THEN 'Other Expenses'
					ELSE 'No Type'
				END AS AccountTypeName,
				tGLAccount.AccountType,
				tGLAccount.Rollup,
				tGLAccount.Description,
				tGLAccount.BankAccountNumber,
				tGLAccount.CurrentBalance,
				tGLAccount.NextCheckNumber,
				tGLAccount.LastReconcileDate,
				tGLAccount.StatementDate,
				tGLAccount.StatementBalance,
				tGLAccount.RecStatus,
				tGLAccount.Active,
				tGLAccount.DisplayOrder,
				tGLAccount.DisplayLevel,
				tGLAccount.LinkID,
				tGLAccount.PayrollExpense,
				tGLAccount.FacilityExpense,
				tGLAccount.LaborIncome,
				tGLAccount.LastModified,
				tGLAccount.DefaultCheckFormatKey,
				isnull(tGLAccount.AccountTypeCash, tGLAccount.AccountType) as AccountTypeCash,			
				CASE
					WHEN tGLAccount.AccountType in (40, 41) THEN 1 --Income
					WHEN tGLAccount.AccountType in (50, 51, 52) THEN 2 --Expense
					ELSE 0 --Other
				END AS IncExpType,
				CASE
					WHEN ISNULL(tGLAccount.AccountNumber, '') <> '' THEN ISNULL(tGLAccount.AccountNumber, '') + '-' + ISNULL(tGLAccount.AccountName, '')
					ELSE ISNULL(tGLAccount.AccountName, '')
				END AS AccountNumberName,
				pgl.AccountNumber as ParentAccountNumber, pgl.AccountName as ParentAccountName,
				ISNULL(tGLAccount.NoJournalEntries,0) AS NoJournalEntries,
				ISNULL(tGLAccount.MultiCompanyPayments,0) AS MultiCompanyPayments,
				ISNULL(tGLAccount.RestrictToGLCompany,0) AS RestrictToGLCompany,
				tGLAccount.CurrencyID
			from tGLAccount (nolock)  
			LEFT JOIN tGLAccount pgl (nolock) on tGLAccount.ParentAccountKey = pgl.GLAccountKey
			Where tGLAccount.CompanyKey = @CompanyKey
			And   (isnull(tGLAccount.RestrictToGLCompany, 0) = 0
					Or 
					tGLAccount.GLAccountKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tGLAccount'
							and  uglca.UserKey = @UserKey
						  )
				  )

			order by tGLAccount.DisplayOrder, tGLAccount.AccountNumber

		END
	RETURN
END

IF @List = 'tGLAccountUser'
BEGIN
	select  distinct u.UserKey, u.Active
		, u.FirstName + ' ' + u.LastName as UserName
		, u.FirstName + ' ' + u.LastName as FormattedName
	from    tGLAccountUser glau (nolock)
	inner   join tGLAccount gla (nolock) on gla.GLAccountKey = glau.GLAccountKey
	inner   join tUser u (nolock) on glau.UserKey = u.UserKey 
	where   gla.CompanyKey = @CompanyKey
	order by u.FirstName + ' ' + u.LastName
END

IF @List = 'tGLAccountCC'
BEGIN
	declare @AddOtherCreditCardCharges int

	select @SecurityGroupKey = SecurityGroupKey, @Administrator = Administrator from tUser (nolock) where UserKey = @UserKey

	if @Administrator = 1
		select @AddOtherCreditCardCharges = 1 
	else
	begin
		if exists (select 1 from tRight r (nolock)
					inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey 
						and ra.EntityKey = @SecurityGroupKey and ra.EntityType ='Security Group'
				   where r.RightID = 'purch_addothercreditcardcharge'
				   )
				   select @AddOtherCreditCardCharges = 1
				else
				   select @AddOtherCreditCardCharges = 0
	end	

	if @AddOtherCreditCardCharges = 1

		-- all credit cards with users for the company	 
		select  distinct gla.GLAccountKey, gla.AccountName, gla.AccountNumber, gla.DisplayOrder, ISNULL(gla.CCDeliveryOption, 0) AS CCDeliveryOption
			,CASE
					WHEN ISNULL(gla.AccountNumber, '') <> '' THEN ISNULL(gla.AccountName, '') + '-' + ISNULL(gla.AccountNumber, '')
					ELSE ISNULL(gla.AccountName, '')
				END AS FormattedName
			,CASE 
				WHEN LEN(ISNULL(CreditCardNumber, '')) > 0 
				 AND LEN(ISNULL(CreditCardPassword, '')) > 0  
				 AND LEN(ISNULL(CreditCardLogin, '')) > 0 
				 AND LEN(ISNULL(FIName, '')) > 0 
				 AND LEN(ISNULL(FIID, '')) > 0 
				 AND LEN(ISNULL(FIOrg, '')) > 0 
				 AND LEN(ISNULL(FIUrl, '')) > 0  Then 1 Else 0
			End as CCSetup	
		from    tGLAccount gla (nolock) 
			inner join tGLAccountUser glau (nolock) on gla.GLAccountKey = glau.GLAccountKey
			inner join tUser u (nolock) on glau.UserKey = u.UserKey
		where   gla.CompanyKey = @CompanyKey
		and     gla.AccountType = 23
		and     gla.Active = 1
		and     u.Active = 1
		and   (isnull(gla.RestrictToGLCompany, 0) = 0
					Or 
					gla.GLAccountKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tGLAccount'
							and  uglca.UserKey = @UserKey
						  )
				  )
		order by gla.DisplayOrder, gla.AccountNumber

	else

		-- all credit cards for that user 	 
		select  distinct gla.GLAccountKey, gla.AccountName, gla.AccountNumber, gla.DisplayOrder
			,CASE
					WHEN ISNULL(gla.AccountNumber, '') <> '' THEN ISNULL(gla.AccountName, '') + '-' + ISNULL(gla.AccountNumber, '')
					ELSE ISNULL(gla.AccountName, '')
				END AS FormattedName
			,CASE 
				WHEN LEN(ISNULL(CreditCardNumber, '')) > 0 
				 AND LEN(ISNULL(CreditCardPassword, '')) > 0  
				 AND LEN(ISNULL(CreditCardLogin, '')) > 0 
				 AND LEN(ISNULL(FIName, '')) > 0 
				 AND LEN(ISNULL(FIID, '')) > 0 
				 AND LEN(ISNULL(FIOrg, '')) > 0 
				 AND LEN(ISNULL(FIUrl, '')) > 0  Then 1 Else 0
			End as CCSetup	
		from    tGLAccount gla (nolock) 
			inner join tGLAccountUser glau (nolock) on gla.GLAccountKey = glau.GLAccountKey
			inner join tUser u (nolock) on glau.UserKey = u.UserKey
		where   gla.CompanyKey = @CompanyKey
		and     glau.UserKey = @UserKey 
		and     gla.AccountType = 23
		and     gla.Active = 1
		and     u.Active = 1
		and   (isnull(gla.RestrictToGLCompany, 0) = 0
					Or 
					gla.GLAccountKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tGLAccount'
							and  uglca.UserKey = @UserKey
						  )
				  )
		order by gla.DisplayOrder, gla.AccountNumber

END

IF @List = 'tClass'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tClass (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *,
			CASE
				WHEN ISNULL(ClassID, '') <> '' THEN ISNULL(ClassName, '') + '-' + ISNULL(ClassID, '')
				ELSE ISNULL(ClassName, '')
			END AS FormattedName,
			d.DepartmentName,
			o.OfficeID,
			o.OfficeName
		from tClass (nolock) 
		Left Outer Join tDepartment d (nolock) on tClass.DepartmentKey = d.DepartmentKey
		Left Outer Join tOffice o (nolock) on tClass.OfficeKey = o.OfficeKey
		Where tClass.CompanyKey = @CompanyKey 
		order by ClassID, ClassName

	RETURN
END

IF @List = 'tOffice'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tOffice (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
	IF Exists(Select 1 from tPreference (nolock) Where CompanyKey = @CompanyKey and ISNULL(RestrictToGLCompany, 0) = 1)
	BEGIN
		-- add in a restriction layer if the person is not allowed to access a particular office
		select distinct o.*,
			CASE
				WHEN ISNULL(o.OfficeID, '') <> '' THEN ISNULL(o.OfficeName, '') + '-' + ISNULL(o.OfficeID, '')
				ELSE ISNULL(o.OfficeName, '')
			END AS FormattedName 
		from tOffice o (nolock) 
		inner join tGLCompanyAccess glca (nolock) on o.OfficeKey = glca.EntityKey and glca.Entity = 'tOffice'
		inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey 
		where o.CompanyKey = @CompanyKey 
		and   uglca.UserKey = @UserKey
		order by o.OfficeID, o.OfficeName
	END
	ELSE
	BEGIN
		select *,
			CASE
				WHEN ISNULL(OfficeID, '') <> '' THEN ISNULL(OfficeName, '') + '-' + ISNULL(OfficeID, '')
				ELSE ISNULL(OfficeName, '')
			END AS FormattedName 
		from tOffice (nolock) Where CompanyKey = @CompanyKey 
		order by OfficeID, OfficeName

	END

	RETURN
END

IF @List = 'tDepartment'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tDepartment (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *, DepartmentName AS FormattedName 
		 from tDepartment (nolock) Where CompanyKey = @CompanyKey 
		order by DepartmentName

	RETURN
END

IF @List = 'tGLCompany'
BEGIN
	declare @Admin int
	Select @Admin = ISNULL(Administrator, 0) from tUser (nolock) Where UserKey = @UserKey
	IF Exists(Select 1 from tPreference (nolock) Where CompanyKey = @CompanyKey and ISNULL(RestrictToGLCompany, 0) = 1) and @Admin = 0
	BEGIN
		-- add in a restriction layer if the person is not allowed to access a particular company
		select glc.*,
			CASE
				WHEN ISNULL(glc.GLCompanyID, '') <> '' THEN ISNULL(glc.GLCompanyName, '') + '-' + ISNULL(glc.GLCompanyID, '')
				ELSE ISNULL(glc.GLCompanyName, '')
			END AS FormattedName
			,gla.AccountNumber
			,gla.AccountName
		from tGLCompany glc (nolock) 
		LEFT JOIN tGLAccount gla (nolock) ON glc.BankAccountKey = gla.GLAccountKey
		inner join tUserGLCompanyAccess glca (nolock) on glc.GLCompanyKey = glca.GLCompanyKey
		Where glc.CompanyKey = @CompanyKey and glca.UserKey = @UserKey
		order by glc.GLCompanyID, glc.GLCompanyName
	END
	ELSE
	BEGIN
		select glc.*,
			CASE
				WHEN ISNULL(glc.GLCompanyID, '') <> '' THEN ISNULL(glc.GLCompanyName, '') + '-' + ISNULL(glc.GLCompanyID, '')
				ELSE ISNULL(glc.GLCompanyName, '')
			END AS FormattedName
			,gla.AccountNumber
			,gla.AccountName
		from tGLCompany glc (nolock) 
		LEFT JOIN tGLAccount gla (nolock) ON glc.BankAccountKey = gla.GLAccountKey
		Where glc.CompanyKey = @CompanyKey 
		order by glc.GLCompanyID, glc.GLCompanyName
	END
	RETURN
END

IF @List = 'tGLCompanyMap'
BEGIN
	/*IF Exists(Select 1 from tPreference (nolock) Where CompanyKey = @CompanyKey and ISNULL(RestrictToGLCompany, 0) = 1)
	BEGIN
		-- add in a restriction layer if the person is not allowed to access a particular company
		select glm.SourceGLCompanyKey, glc.GLCompanyKey, glc.GLCompanyID, glc.GLCompanyName, glc.Active
		from tGLCompany glc (nolock) 
		inner join tGLCompanyMap glm (nolock) on glc.GLCompanyKey = glm.TargetGLCompanyKey
		inner join tUserGLCompanyAccess glca (nolock) on glc.GLCompanyKey = glca.GLCompanyKey
		Where glc.CompanyKey = @CompanyKey and glca.UserKey = @UserKey
		order by glm.SourceGLCompanyKey, glc.GLCompanyID, glc.GLCompanyName
	END
	ELSE
	BEGIN */
		select glm.SourceGLCompanyKey, glc.GLCompanyKey, glc.GLCompanyID, glc.GLCompanyName, glc.Active
		from tGLCompany glc (nolock) 
		inner join tGLCompanyMap glm (nolock) on glc.GLCompanyKey = glm.TargetGLCompanyKey
		Where glc.CompanyKey = @CompanyKey
		order by glm.SourceGLCompanyKey, glc.GLCompanyID, glc.GLCompanyName
	--END
	RETURN
END

IF @List = 'tProjectStatus'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tProjectStatus (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select	*,
				CASE
					WHEN ISNULL(ProjectStatusID, '') <> '' THEN ISNULL(ProjectStatus, '') + '-' + ISNULL(ProjectStatusID, '')
					ELSE ISNULL(ProjectStatus, '')
				END AS FormattedName,
				ProjectStatus AS ProjectStatusName
		from	tProjectStatus (nolock) Where CompanyKey = @CompanyKey 
		order by DisplayOrder

	RETURN
END

IF @List = 'tProjectBillingStatus'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tProjectBillingStatus (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select	*,
				CASE
					WHEN ISNULL(ProjectBillingStatusID, '') <> '' THEN ISNULL(ProjectBillingStatus, '') + '-' + ISNULL(ProjectBillingStatusID, '')
					ELSE ISNULL(ProjectBillingStatus, '')
				END AS FormattedName,
				ProjectBillingStatus AS ProjectBillingStatusName
		from tProjectBillingStatus (nolock) Where CompanyKey = @CompanyKey 
		order by Active desc, DisplayOrder

	RETURN
END

IF @List = 'tProjectType'
BEGIN

	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tProjectType (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *, ProjectTypeName AS FormattedName 
		from tProjectType (nolock)
		where CompanyKey = @CompanyKey
		order by ProjectTypeName

	RETURN
END

IF @List = 'tWorkType'
BEGIN

	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tWorkType (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *, WorkTypeID + '-' + WorkTypeName as FormattedName,
				gl.AccountNumber AS SalesAccountNumber,
				gl.AccountName AS SalesAccountName,
				c.ClassID,
				c.ClassName,
				d.DepartmentName
		from tWorkType (nolock)		
		Left outer Join tGLAccount gl (nolock) on tWorkType.GLAccountKey = gl.GLAccountKey
		Left outer Join tClass c (nolock) on tWorkType.ClassKey = c.ClassKey
		Left outer Join tDepartment d (nolock) on tWorkType.DepartmentKey = d.DepartmentKey
		where tWorkType.CompanyKey = @CompanyKey
		order by tWorkType.DisplayOrder, WorkTypeID, WorkTypeName

	RETURN
END

IF @List = 'tTaskAssignmentType'
BEGIN

	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tTaskAssignmentType (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *
		from tTaskAssignmentType (nolock)
		where CompanyKey = @CompanyKey
		order by TaskAssignmentType

	RETURN
END

IF @List = 'tMasterTask'
BEGIN

	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tMasterTask (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *
		from tMasterTask (nolock)
		where CompanyKey = @CompanyKey
		order by TaskID, TaskName

	RETURN
END


IF @List = 'tVendor'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tCompany (nolock)
				WHERE	OwnerCompanyKey = @CompanyKey
				AND		Vendor = 1
				AND		LastModified > @CheckTime)
	BEGIN
		Select @RestrictToGLCompany = isnull(RestrictToGLCompany, 0) from tPreference (nolock) where CompanyKey = @CompanyKey

		select 
			CASE
				WHEN ISNULL(VendorID, '') <> '' THEN ISNULL(CompanyName, '') + '-' + ISNULL(VendorID, '')
				ELSE ISNULL(CompanyName, '')
			END AS FormattedName,
			CompanyKey,
			CompanyName,
			VendorID,
			Active,
			DefaultExpenseAccountKey,
			TermsPercent,
			TermsDays,
			TermsNet,
			CompanyName as VendorName,
			VendorID + '-' + CompanyName as FormattedName	

		From tCompany (nolock) Where OwnerCompanyKey = @CompanyKey and Vendor = 1
		and (
			@RestrictToGLCompany = 0
			Or 
			CompanyKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tCompany'
							and   uglca.UserKey = @UserKey
						  )
			)

		Order By VendorID, CompanyName
	
	END

	RETURN
END

IF @List = 'tClient'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tCompany (nolock)
				WHERE	OwnerCompanyKey = @CompanyKey
				AND		BillableClient = 1
				AND		LastModified > @CheckTime)
	BEGIN
		Select @RestrictToGLCompany = isnull(RestrictToGLCompany, 0) from tPreference (nolock) where CompanyKey = @CompanyKey

		select 
			CASE
				WHEN ISNULL(CustomerID, '') <> '' THEN ISNULL(CompanyName, '') + '-' + ISNULL(CustomerID, '')
				ELSE ISNULL(CompanyName, '')
			END AS FormattedName,
			CompanyName as ClientName,
			ParentCompany,
			ParentCompanyKey,
			CompanyKey,
			CompanyName,
			CustomerID as ClientID,
			Active,
			AccountManagerKey,
			DefaultTeamKey,
			PrimaryContact,
			GLCompanyKey,
			GetRateFrom,
			TimeRateSheetKey,
			GetMarkupFrom,
			ItemMarkup,
			IOCommission,
			BCCommission,
			IOBillAt,
			BCBillAt,
			DefaultBillingMethod,
			DefaultRetainerKey,
			DefaultExpensesNotIncluded
		From tCompany (nolock) Where OwnerCompanyKey = @CompanyKey and BillableClient = 1

		and (
			@RestrictToGLCompany = 0
			Or 
			CompanyKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tCompany'
							and   uglca.UserKey = @UserKey
						  )
			)

		Order By CompanyName

	END

	RETURN
END

IF @List = 'tClientDivision'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tClientDivision (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *, DivisionName AS FormattedName 
		from tClientDivision (nolock)
		where CompanyKey = @CompanyKey
		order by DivisionName

	RETURN
END

IF @List = 'tClientProduct'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tClientProduct (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *, ProductName AS FormattedName
		from tClientProduct (nolock)
		where CompanyKey = @CompanyKey
		order by ProductName

	RETURN
END

IF @List = 'strings'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tStringCompany (nolock) --Only need to check tStringCompany because it's the only table that can be modified
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
			select sg.StringGroupName
				,s.StringID
				,s.DisplayName
				,isnull(s.AllowDD, 0) as AllowDD
				,isnull(sc.StringSingular,s.StringSingular) as StringSingular
				,isnull(sc.StringPlural,s.StringPlural) as StringPlural
				,isnull(sc.StringDropDown, s.DefaultDD) as StringDropDown
			from tString s (nolock)
				INNER JOIN tStringGroup sg (nolock) ON s.StringGroupKey = sg.StringGroupKey
				LEFT OUTER JOIN tStringCompany sc (nolock) ON
					s.StringID = sc.StringID AND sc.CompanyKey = @CompanyKey  
			order by sg.DisplayOrder
				,s.DisplayOrder	

	RETURN
END

IF @List = 'preferences'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tPreference (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		SELECT	tPreference.*
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultARAccountKey) as DefaultARAccountNumber
				,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultARAccountKey) as DefaultARAccountName

				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultSalesAccountKey) as DefaultSalesAccountNumber
				,(Select AccountName   from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultSalesAccountKey) as DefaultSalesAccountName

				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultAPAccountKey) as DefaultAPAccountNumber
				,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultAPAccountKey) as DefaultAPAccountName

				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultExpenseAccountKey) as DefaultExpenseAccountNumber
				,(Select AccountName   from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultExpenseAccountKey) as DefaultExpenseAccountName

				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultCashAccountKey) as DefaultCashAccountNumber
				,(Select AccountName   from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultCashAccountKey) as DefaultCashAccountName

				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WriteOffAccountKey) as WriteOffAccountNumber

				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.AdvBillAccountKey) as AdvBillAccountNumber
				,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.AdvBillAccountKey) as AdvBillAccountName

				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.UnappliedCashAccountKey) as UnappliedCashAccountNumber
				,(Select AccountName   from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.UnappliedCashAccountKey) as UnappliedCashAccountName

				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.UnappliedPaymentAccountKey) as UnappliedPaymentAccountNumber
				,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.UnappliedPaymentAccountKey) as UnappliedPaymentAccountName

				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DiscountAccountKey) as DiscountAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPLaborAssetAccountKey) as WIPLaborAssetAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPLaborIncomeAccountKey) as WIPLaborIncomeAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPLaborWOAccountKey) as WIPLaborWOAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPExpenseAssetAccountKey) as WIPExpenseAssetAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPExpenseIncomeAccountKey) as WIPExpenseIncomeAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPExpenseWOAccountKey) as WIPExpenseWOAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPMediaAssetAccountKey) as WIPMediaAssetAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPMediaIncomeAccountKey) as WIPMediaIncomeAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPMediaWOAccountKey) as WIPMediaWOAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPVoucherAssetAccountKey) as WIPVoucherAssetAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPVoucherIncomeAccountKey) as WIPVoucherIncomeAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPVoucherWOAccountKey) as WIPVoucherWOAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.LaborOverUnderAccountKey) as LaborOverUnderAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.ExpenseOverUnderAccountKey) as ExpenseOverUnderAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.POAccruedExpenseAccountKey) as POAccruedExpenseAccountNumber
				,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.POPrebillAccrualAccountKey) as POPrebillAccrualAccountNumber
				,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.POPrebillAccrualAccountKey) as POPrebillAccrualAccountName

				,(Select ClassID from tClass (nolock) Where tClass.ClassKey = tPreference.DefaultClassKey) AS DefaultClassID
				,(Select ClassName from tClass (nolock) Where tClass.ClassKey = tPreference.DefaultClassKey) AS DefaultClassName
				,(Select GLCompanyID from tGLCompany (nolock) Where tGLCompany.GLCompanyKey = tPreference.DefaultGLCompanyKey) AS DefaultGLCompanyID
				,(Select GLCompanyName from tGLCompany (nolock) Where tGLCompany.GLCompanyKey = tPreference.DefaultGLCompanyKey) AS DefaultGLCompanyName

				,(Select FirstName + ' ' + LastName from tUser (nolock) where tUser.UserKey = tPreference.DefaultARApproverKey) as DefaultARApproverName
				,(Select FirstName + ' ' + LastName from tUser (nolock) where tUser.UserKey = tPreference.DefaultAPApproverKey) as DefaultAPApproverName
				,'' AS WebDAVServerOptions --Used in VB
		FROM	tPreference (NOLOCK) 
		WHERE	CompanyKey = @CompanyKey

	RETURN
END

IF @List = 'timePreferences'
BEGIN
	IF @CompanyKey IS NULL
		SELECT *
		FROM  tTimeOption (NOLOCK)
	ELSE
		IF @CheckTime IS NULL
			OR EXISTS
				(SELECT NULL
				FROM	tTimeOption (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
			SELECT *
			FROM tTimeOption (NOLOCK) 
			WHERE CompanyKey = @CompanyKey

	RETURN
END

IF @List = 'tSecurityGroup'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tSecurityGroup (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select * from tSecurityGroup (nolock) 
		where CompanyKey = @CompanyKey 
		order By GroupName

	RETURN
END

IF @List = 'tRptSecurityGroup'
BEGIN
	Select @SecurityGroupKey = SecurityGroupKey from tUser (nolock) Where UserKey = @UserKey
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tRptSecurityGroup rsg (nolock)
				INNER JOIN tSecurityGroup sg (nolock) ON rsg.SecurityGroupKey = sg.SecurityGroupKey 
				WHERE	sg.CompanyKey = @CompanyKey
				AND		sg.SecurityGroupKey = @SecurityGroupKey
				AND		(sg.LastModified > @CheckTime OR rsg.LastModified > @CheckTime))
		select * from tRptSecurityGroup rsg (nolock)
		inner join tSecurityGroup sg (nolock) on rsg.SecurityGroupKey = sg.SecurityGroupKey 
		where sg.CompanyKey = @CompanyKey 
		and sg.SecurityGroupKey = @SecurityGroupKey
		order By sg.GroupName

	RETURN
END

IF @List = 'tReport'
BEGIN
	Select @SecurityGroupKey = SecurityGroupKey from tUser (nolock) Where UserKey = @UserKey

	IF @CheckTime IS NULL
		OR EXISTS --Return the list if the user's record has been modified, since their SecurityGroupKey may have been changed
				(SELECT NULL
				FROM	tUser (nolock)
				WHERE	UserKey = @UserKey
				AND		LastModified > @CheckTime)
		OR EXISTS --Return the list if anything has changed in tRptSecurityGroup for the user's SecurityGroupKey
				(SELECT NULL
				FROM	tRptSecurityGroup (nolock)
				WHERE	SecurityGroupKey = @SecurityGroupKey
				AND		LastModified > @CheckTime)
		OR EXISTS --Return the list if anything has changed in tReport or tReportGroup for reports the user can see
				(SELECT NULL
				FROM	tReport r (nolock)
				LEFT JOIN tReportGroup rg (nolock) ON r.ReportGroupKey = rg.ReportGroupKey
				WHERE   r.CompanyKey = @CompanyKey
				and     r.ReportType = 0
				AND     r.ApplicationVersion = 2
				AND		((r.Private = 0 AND r.ReportKey IN 
								(SELECT rsg.ReportKey 
								FROM	tRptSecurityGroup rsg (NOLOCK)
								WHERE	rsg.SecurityGroupKey = @SecurityGroupKey))
						OR (r.UserKey = @UserKey))
				AND		(r.LastModified > @CheckTime OR rg.LastModified > @CheckTime))
		SELECT r.*,
			ISNULL(rg.GroupName, 'Other Reports') as GroupName,
			ISNULL(rg.ReportGroupKey, 0) as ReportGroupKey,
			ISNULL(rg.DisplayOrder, 0) as DisplayOrder
		FROM   tReport r (NOLOCK)
		left outer join tReportGroup rg (nolock) on r.ReportGroupKey = rg.ReportGroupKey
		WHERE	r.CompanyKey = @CompanyKey
		and		ReportType = 0 
		AND     ApplicationVersion = 2
		AND		((r.Private = 0 AND r.ReportKey IN 
					(SELECT rsg.ReportKey 
					FROM   tRptSecurityGroup rsg (NOLOCK)
					WHERE  rsg.SecurityGroupKey = @SecurityGroupKey))
				OR
				(r.UserKey = @UserKey))
		Order By DisplayOrder, GroupName, Name

	RETURN
END

IF @List = 'tReportGroup'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS --Return the list if anything in tReportGroup has changed
				(SELECT NULL
				FROM	tReportGroup (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)	
		OR EXISTS --Return the list if anything in tReport linked to the tReportGroups has changed (in case "HasReports" might have changed)
				(SELECT NULL
				FROM	tReport r (nolock)
				INNER JOIN tReportGroup rg (nolock) ON r.ReportGroupKey = rg.ReportGroupKey
				WHERE	rg.CompanyKey = @CompanyKey
				AND		r.LastModified > @CheckTime
				AND     r.ApplicationVersion = 2)	
		select rg.*
			  ,isnull((select top 1 1 
				from tReport r (nolock)
				where rg.ReportGroupKey = r.ReportGroupKey), 0) as HasReports	 
		from tReportGroup rg (nolock) 
		Where CompanyKey = @CompanyKey 
		Order By DisplayOrder

	RETURN
END

IF @List = 'tFormTemplate'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tFormTemplate (nolock)
				WHERE	(CompanyKey = @CompanyKey
						OR (Entity = 'user' AND EntityKey = @UserKey))
				AND		LastModified > @CheckTime)
	BEGIN
		-- cannot find it for entity, return company level default
		select * from tFormTemplate (nolock)
		where Entity = 'user' 
		and EntityKey = @UserKey
	END

	RETURN
END

IF @List = 'listings'
BEGIN
	Select @SecurityGroupKey = SecurityGroupKey from tUser (nolock) Where UserKey = @UserKey

	IF @CheckTime IS NULL
		OR EXISTS --Return the list if the user's record has been modified, since their SecurityGroupKey may have been changed
				(SELECT NULL
				FROM	tUser (nolock)
				WHERE	UserKey = @UserKey
				AND		LastModified > @CheckTime)
		OR EXISTS --Return the list if anything has changed in tRptSecurityGroup for the user's SecurityGroupKey
				(SELECT NULL
				FROM	tRptSecurityGroup (nolock)
				WHERE	SecurityGroupKey = @SecurityGroupKey
				AND		LastModified > @CheckTime)
		OR EXISTS --Return the list if anything has changed in tReport or tReportGroup for reports the user can see
				(SELECT NULL
				FROM	tReport r (nolock)
				LEFT JOIN tReportGroup rg (nolock) ON r.ReportGroupKey = rg.ReportGroupKey
				WHERE	r.ReportType = 1
				AND		ApplicationVersion = 2
				AND		(r.LastModified > @CheckTime OR rg.LastModified > @CheckTime))
		SELECT r.ReportKey
			  ,r.ViewKey
			  ,r.Name
			  ,r.ReportType
			  ,r.ReportFilter
			  ,r.Definition
			  ,r.FieldDefinition
			  ,r.ConditionDefinition
			  ,r.Private
			  ,r.UserKey
			  ,r.CompanyKey
			  ,r.ReportGroupKey
			  ,r.ReportHeading1
			  ,r.ReportHeading1Align
			  ,r.ReportHeading2
			  ,r.ReportHeading2Align
			  ,r.Orientation
			  ,r.GroupBy
			  ,r.ShowConditions
			  ,r.ReportID
			  ,r.GroupByDefinition
			  ,isnull(r.LockedColumns, 0) as LockedColumns
			  ,isnull(r.DefaultReportKey, 0) as DefaultReportKey
			  ,isnull(r.AutoExpandGroups, 0) as AutoExpandGroups
			  ,isnull(r.Deleted, 0) as Deleted
			  ,isnull(rg.GroupName, 'Other Reports') as GroupName
			  ,isnull(rg.ReportGroupKey, 0) as ReportGroupKey
			  ,isnull(rg.DisplayOrder, 0) as DisplayOrder
		FROM   tReport r (NOLOCK)
		left outer join tReportGroup rg (nolock) on r.ReportGroupKey = rg.ReportGroupKey
		WHERE	ReportType = 1 
		AND		ApplicationVersion = 2
		AND		r.CompanyKey = @CompanyKey
		Order By DisplayOrder, GroupName, Name

	RETURN
END

IF @List = 'dynamicReports'
	BEGIN
	IF @CheckTime IS NULL
		OR EXISTS --Return the list if the user's record has been modified, since their SecurityGroupKey may have been changed
				(SELECT NULL
				FROM	tUser (nolock)
				WHERE	UserKey = @UserKey
				AND		LastModified > @CheckTime)
		OR EXISTS --Return the list if anything has changed in tRptSecurityGroup for the user's SecurityGroupKey
				(SELECT NULL
				FROM	tRptSecurityGroup rsg (nolock)
				INNER JOIN tUser u (nolock) ON rsg.SecurityGroupKey = u.SecurityGroupKey
				WHERE	u.UserKey = @UserKey
				AND		rsg.LastModified > @CheckTime)
		OR EXISTS --Return the list if anything has changed for the user's dynamic reports
				(SELECT NULL
				FROM	tReport (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		ReportType = 2
				AND		UserKey = @UserKey
				AND		LastModified > @CheckTime)
		OR EXISTS --Return the list if anything has changed for reports that the user can see
				(SELECT NULL
				FROM	tReport r (nolock)
				INNER JOIN tRptSecurityGroup rsg (nolock) ON r.ReportKey = rsg.ReportKey
				INNER JOIN tUser u (nolock) ON rsg.SecurityGroupKey = u.SecurityGroupKey
				WHERE	r.CompanyKey = @CompanyKey
				AND		r.ReportType = 2
				AND		u.UserKey = @UserKey
				AND		r.ReportKey NOT IN
							(SELECT	ReportKey
							FROM	tReport (nolock)
							WHERE	CompanyKey = @CompanyKey
							AND		ReportType = 2
							AND		UserKey = @UserKey)
				AND		r.LastModified > @CheckTime)
	BEGIN				
		create table #tRptTemp
					(
					ReportKey int null
					,ViewKey int null
					,Name varchar(255) null
					,ReportType smallint null
					,ReportFilter varchar(50) null
					,Definition text null
					,FieldDefinition text null
					,ConditionDefinition text null
					,Private int null
					,UserKey int null
					,CompanyKey int null
					,ReportGroupKey int null
					,ReportHeading1 varchar(200) null
					,ReportHeading1Align smallint null
					,ReportHeading2 varchar(200) null
					,ReportHeading2Align smallint null
					,Orientation smallint null
					,GroupBy smallint null
					,ShowConditions tinyint null
					,ReportID varchar(50) null
					,GroupByDefinition text null
					,LockedColumns int null
					,DefaultReportKey int null
					,AutoExpandGroups tinyint null
					)


		--get any reports where the user is the owner, private and public
		insert #tRptTemp
					(ReportKey 
					,ViewKey
					,Name 
					,ReportType
					,ReportFilter 
					,Definition 
					,FieldDefinition
					,ConditionDefinition 
					,Private 
					,UserKey 
					,CompanyKey 
					,ReportGroupKey 
					,ReportHeading1 
					,ReportHeading1Align 
					,ReportHeading2 
					,ReportHeading2Align 
					,Orientation 
					,GroupBy 
					,ShowConditions 
					,ReportID 
					,GroupByDefinition 
					,LockedColumns 
					,DefaultReportKey
					,AutoExpandGroups 
					)
		select 
					r.ReportKey 
					,r.ViewKey
					,r.Name 
					,r.ReportType
					,r.ReportFilter 
					,r.Definition 
					,r.FieldDefinition
					,r.ConditionDefinition 
					,r.Private 
					,r.UserKey 
					,r.CompanyKey 
					,r.ReportGroupKey 
					,r.ReportHeading1 
					,r.ReportHeading1Align 
					,r.ReportHeading2 
					,r.ReportHeading2Align 
					,r.Orientation 
					,r.GroupBy 
					,r.ShowConditions 
					,r.ReportID 
					,r.GroupByDefinition 
					,r.LockedColumns 
					,r.DefaultReportKey
					,r.AutoExpandGroups 
		from tReport r (nolock) 
		where CompanyKey = @CompanyKey
		and ReportType = 2
		and UserKey = @UserKey

		--get any reports where the user has access through a security group
		insert #tRptTemp
					(ReportKey 
					,ViewKey
					,Name 
					,ReportType
					,ReportFilter 
					,Definition 
					,FieldDefinition
					,ConditionDefinition 
					,Private 
					,UserKey 
					,CompanyKey 
					,ReportGroupKey 
					,ReportHeading1 
					,ReportHeading1Align 
					,ReportHeading2 
					,ReportHeading2Align 
					,Orientation 
					,GroupBy 
					,ShowConditions 
					,ReportID 
					,GroupByDefinition 
					,LockedColumns 
					,DefaultReportKey
					,AutoExpandGroups 
					)
		select 
					r.ReportKey 
					,r.ViewKey
					,r.Name 
					,r.ReportType
					,r.ReportFilter 
					,r.Definition 
					,r.FieldDefinition
					,r.ConditionDefinition 
					,r.Private 
					,r.UserKey 
					,r.CompanyKey 
					,r.ReportGroupKey 
					,r.ReportHeading1 
					,r.ReportHeading1Align 
					,r.ReportHeading2 
					,r.ReportHeading2Align 
					,r.Orientation 
					,r.GroupBy 
					,r.ShowConditions 
					,r.ReportID 
					,r.GroupByDefinition 
					,r.LockedColumns 
					,r.DefaultReportKey
					,r.AutoExpandGroups 	
		from tReport r (nolock) inner join tRptSecurityGroup rsg (nolock) on r.ReportKey = rsg.ReportKey
		inner join tUser u (nolock) on rsg.SecurityGroupKey = u.SecurityGroupKey
		where r.CompanyKey = @CompanyKey
		and r.ReportType = 2
		and u.UserKey = @UserKey
		and r.ReportKey not in (select ReportKey
								from tReport r (nolock) 
								where CompanyKey = @CompanyKey
								and ReportType = 2
								and UserKey = @UserKey)

		select * 
		from #tRptTemp
		order by Name
	END

	RETURN
END

IF @List = 'widgets'
BEGIN
	Declare @WidgetKey int, @HasLegacy smallint
	
	Select @SecurityGroupKey = SecurityGroupKey,
		@CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey)
	From tUser (nolock)
	Where UserKey = @UserKey

	Select @HasLegacy = ISNULL(CHARINDEX('legacyforms', Customizations), 0) from tPreference where CompanyKey = @CompanyKey
	if @HasLegacy = 0 
		Select @WidgetKey = 15

	IF @CheckTime IS NULL
		OR EXISTS --Return the list if the user's record has been modified, since their SecurityGroupKey may have been changed
				(SELECT NULL
				FROM	tUser (nolock)
				WHERE	UserKey = @UserKey
				AND		LastModified > @CheckTime)
		OR EXISTS --Return the list if tWidgetCompany has changed
				(SELECT NULL
				FROM	tWidgetCompany (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		OR EXISTS --Return the list if tWidgetSecurity has changed
				(SELECT NULL
				FROM	tWidgetSecurity (nolock)
				WHERE	SecurityGroupKey = @SecurityGroupKey
				AND		LastModified > @CheckTime)
		Select w.*, wc.Settings as CompanySettings, ISNULL(ws.CanView, 0) as CanView, ISNULL(ws.CanEdit, 0) as CanEdit
		From 
			tWidget w (nolock)
			left outer join (Select * from tWidgetCompany Where CompanyKey = @CompanyKey) as wc on w.WidgetKey = wc.WidgetKey
			left outer join (Select * from tWidgetSecurity Where SecurityGroupKey = @SecurityGroupKey) as ws on w.WidgetKey = ws.WidgetKey
		Where (w.CompanyKey is null or w.CompanyKey = @CompanyKey)
          And (isnull(@WidgetKey, 0) = 0 or w.WidgetKey <> @WidgetKey)
		Order by w.DisplayName
	RETURN
END

IF @List = 'tCampaign'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tCampaign (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select
			 CampaignKey
			,CampaignID + '-' + CampaignName as FormattedName
			,ClientKey
			,Active
			,GetActualsBy
			,isnull(MultipleSegments, 0) as MultipleSegments
			,BillBy
		from tCampaign (nolock)
		where CompanyKey = @CompanyKey
		order by CampaignID

	RETURN
END

IF @List = 'tLaborBudget'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tLaborBudget (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		SELECT	*
		FROM	tLaborBudget (nolock)
		WHERE	CompanyKey = @CompanyKey 
		Order By BudgetName

	RETURN
END

IF @List = 'tLeadOutcome'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tLeadOutcome (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *
		from tLeadOutcome (nolock)
		where CompanyKey = @CompanyKey
		order by Outcome

	RETURN
END

IF @List = 'tLeadStage'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tLeadStage (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *
			  ,cast(tLeadStage.DisplayOrder as varchar) + ' - ' + tLeadStage.LeadStageName AS StageNameWithOrder
		from tLeadStage (nolock)
		where CompanyKey = @CompanyKey
		order by DisplayOrder

	RETURN
END

IF @List = 'tLeadStatus'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tLeadStatus (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *
		from tLeadStatus (nolock)
		where CompanyKey = @CompanyKey
		order by DisplayOrder

	RETURN
END

IF @List = 'tCompanyType'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tCompanyType (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
			SELECT	*
			FROM	tCompanyType (nolock)
			WHERE	CompanyKey = @CompanyKey
			Order By CompanyTypeName

	RETURN
END

IF @List = 'tPaymentTerms'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tPaymentTerms (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		SELECT	*
		FROM	tPaymentTerms (NOLOCK) 
		WHERE	CompanyKey = @CompanyKey

	RETURN
END

IF @List = 'tCheckMethod'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tCheckMethod (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		SELECT	*
		FROM	tCheckMethod (nolock)
		WHERE	CompanyKey = @CompanyKey
		Order By CheckMethod

	RETURN
END

IF @List = 'tRequestDef'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tRequestDef (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		SELECT *,
			Case Active When 1 then 'YES' else 'NO' end as ActiveText
		FROM tRequestDef (NOLOCK) 
		WHERE 	CompanyKey = @CompanyKey
		Order By Active DESC, RequestName

	RETURN
END

IF @List = 'tPurchaseOrderType'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tPurchaseOrderType (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
			SELECT *
			FROM 
				tPurchaseOrderType (NOLOCK) 
			WHERE
				CompanyKey = @CompanyKey
			order by
				PurchaseOrderTypeName

	RETURN
END

IF @List = 'tStandardText'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tStandardText (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		SELECT	*
		FROM	tStandardText (NOLOCK) 
		WHERE	CompanyKey = @CompanyKey
		Order By TextName

	RETURN
END

IF @List = 'ActionLogActions'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tActionLog (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		Entity <> 'FileVersion'
				AND		LastModified > @CheckTime)
		Select Distinct Action
		From tActionLog (nolock)
		Where CompanyKey = @CompanyKey and Entity <> 'FileVersion'
		Order By Action

	RETURN
END

IF @List = 'ActionLogSection'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS --Return a new list if any ActionLog item (except a FileVersion) has changed in case an Entity has been added or deleted
				(SELECT NULL
				FROM	tActionLog (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		Entity <> 'FileVersion'
				AND		LastModified > @CheckTime)
		Select Distinct Entity
		From tActionLog (nolock)
		Where CompanyKey = @CompanyKey and Entity <> 'FileVersion'
		Order By Entity

	RETURN
END

IF @List = 'currentUser'
BEGIN

	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tUser (nolock)
				WHERE	UserKey = @UserKey
				AND		LastModified > @CheckTime)
		SELECT	*
				,ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS UserName
				,ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS FormattedName
				,c.CustomLogo -- Comment to trick the Update Manager
				,sg.ChangeLayout, sg.ChangeDesktop, sg.ChangeWindow,ISNULL(sg.SecurityLevel, 1) as SecurityLevel
				,s.ServiceCode, s.Description as ServiceName, d.DepartmentName
				,app.BackupApprover as BackupExpenseApprover  -- The backup approver for the expense approver
		FROM	tUser u (NOLOCK)
				left outer join tCompany c (nolock) on u.CompanyKey = c.CompanyKey
				left outer join tSecurityGroup sg (nolock) on u.SecurityGroupKey = sg.SecurityGroupKey
				left outer join tService s (nolock) on u.DefaultServiceKey = s.ServiceKey
				left outer join tDepartment d (nolock) on u.DepartmentKey = d.DepartmentKey
				left outer join tUser app (nolock) on u.ExpenseApprover = app.UserKey
		WHERE	u.UserKey = @UserKey

	RETURN
END


IF @List = 'tItemRateSheet'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS 
				(SELECT NULL
				FROM	tItemRateSheet rs (nolock)
				WHERE	rs.CompanyKey = @CompanyKey
				AND		rs.LastModified > @CheckTime)
	SELECT	rs.*
	FROM	tItemRateSheet rs (nolock)
	WHERE	rs.CompanyKey = @CompanyKey
	Order By RateSheetName
	RETURN
END

IF @List = 'tItemRateSheetDetail'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS 
				(SELECT NULL
				FROM	tItemRateSheet rs (nolock)
				WHERE	rs.CompanyKey = @CompanyKey
				AND		rs.LastModified > @CheckTime)
	SELECT	rsd.*
	FROM	tItemRateSheetDetail rsd (nolock)
	INNER JOIN tItemRateSheet rs (nolock) ON rsd.ItemRateSheetKey = rs.ItemRateSheetKey
	WHERE	rs.CompanyKey = @CompanyKey

	RETURN
END

IF @List = 'tCalendarType'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tCalendarType (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *
		from tCalendarType (nolock) 
		Where CompanyKey = @CompanyKey 
		order by DisplayOrder, TypeName

	RETURN
END

IF @List = 'tContactDatabase'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tContactDatabase (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		Select	cd.ContactDatabaseKey, cd.DatabaseName
		From	tContactDatabase cd (nolock),
				tContactDatabaseUser cdu (nolock)
		Where	cd.ContactDatabaseKey = cdu.ContactDatabaseKey and
				cdu.UserKey = @UserKey
		Order By cd.DatabaseName

	RETURN
END

IF @List = 'tSkill'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tSkill (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		SELECT	*,
				SkillName AS FormattedName
		FROM	tSkill (NOLOCK) 
		WHERE	CompanyKey = @CompanyKey
		ORDER BY SkillName

	RETURN
END

IF @List = 'tSkillSpecialty'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tSkillSpecialty ss (nolock)
				INNER JOIN tSkill s (NOLOCK) ON s.SkillKey = ss.SkillKey
				WHERE	s.CompanyKey = @CompanyKey
				AND		ss.LastModified > @CheckTime)
		SELECT	tSkillSpecialty.*
		FROM	tSkillSpecialty (NOLOCK) 
		inner join tSkill (NOLOCK) on tSkill.SkillKey = tSkillSpecialty.SkillKey
		WHERE	tSkill.CompanyKey = @CompanyKey
		ORDER BY SpecialtyName

	RETURN
END


IF @List = 'tUserSkill'
BEGIN
	Select 
		us.UserKey,
		us.SkillKey,
		us.Rating,
		us.Description
	from tUserSkill us (nolock)
	Inner Join tSkill s (nolock) on us.SkillKey = s.SkillKey
	Where
		s.CompanyKey = @CompanyKey

	RETURN
END

IF @List = 'tUserSkillSpecialty'
BEGIN
	Select 
		us.UserKey,
		ss.SkillKey,
		ss.SkillSpecialtyKey,
		us.Rating,
		us.Description
	from tUserSkillSpecialty us (nolock)
	inner join tSkillSpecialty ss (nolock) on us.SkillSpecialtyKey = ss.SkillSpecialtyKey
	Inner Join tSkill s (nolock) on ss.SkillKey = s.SkillKey
	Where
		s.CompanyKey = @CompanyKey

	RETURN
END


IF @List = 'tTeam'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tTeam (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
	SELECT	*
	FROM	tTeam (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	ORDER BY TeamName
END	


IF @List = 'tMarketingList'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tMarketingList (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
	SELECT	*
	FROM	tMarketingList (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	ORDER BY ListName
END	


IF @List = 'tSyncFolder'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tSyncFolder (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
	SELECT	*
	FROM	tSyncFolder (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	ORDER BY SyncFolderName
END					



IF @List = 'tCMFolderContact'
BEGIN
	Select @SecurityGroupKey = SecurityGroupKey from tUser (nolock) Where UserKey = @UserKey
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tCMFolder (nolock)
				WHERE	Entity = 'tUser' and CompanyKey = @CompanyKey
				AND (UserKey = 0 or UserKey = @UserKey)
				AND		LastModified > @CheckTime)
	BEGIN
		DECLARE	@DefaultContactCMFolderKey int

		SELECT	@DefaultContactCMFolderKey = DefaultContactCMFolderKey
		FROM	tUser (nolock)
		WHERE	UserKey = @UserKey	

		SELECT	f.CMFolderKey,
				f.FolderName,
				f.ParentFolderKey,
				f.UserKey,
				f.CompanyKey,
				f.Entity,
				f.SyncFolderKey,
				f.LastModified,
				f.URL,
				f.BlockoutAttendees,
				f.CalendarColor,
				'Personal' as FolderType,
				1  as CanView,
				1 as CanAdd,
				ISNULL(sf.SyncDirection, 1) AS SyncDirection,
				CASE
					WHEN iis.CMFolderKey IS NOT NULL THEN 1
					ELSE 0
				END AS IncludeInSync,
				CASE
					WHEN f.CMFolderKey = @DefaultContactCMFolderKey THEN 1
					ELSE 0
				END AS IsDefault,
				ISNULL(sfg.SyncDirection, 1) AS GoogleSyncDirection,
				ISNULL(f.GoogleSyncFolderKey, 0) AS GoogleSyncFolderKey,
				ISNULL(sfg.SyncFolderName,'DO NOT SYNC') AS GoogleSyncFolderName,
				f.GoogleAccessCode,
				f.GoogleRefreshToken,
				sfg.GoogleLastSync				
		FROM	tCMFolder f (NOLOCK)
		LEFT JOIN tSyncFolder sf (nolock) ON f.SyncFolderKey = sf.SyncFolderKey
		LEFT JOIN tSyncFolder sfg (nolock) ON f.GoogleSyncFolderKey = sfg.SyncFolderKey
		LEFT JOIN tCMFolderIncludeInSync iis (nolock) ON f.CMFolderKey = iis.CMFolderKey AND iis.UserKey = @UserKey
		WHERE	f.Entity = 'tUser'
		AND		f.CompanyKey = @CompanyKey
		AND		f.UserKey = @UserKey

		UNION

		SELECT	f.CMFolderKey,
				f.FolderName,
				f.ParentFolderKey,
				f.UserKey,
				f.CompanyKey,
				f.Entity,
				f.SyncFolderKey,
				f.LastModified,
				f.URL,
				f.BlockoutAttendees,
				f.CalendarColor,
				'Public' as FolderType,
				ISNULL(securityUser.CanView, ISNULL(securityGroup.CanView, 0)) as CanView, -- Not required?
				ISNULL(securityUser.CanAdd, ISNULL(securityGroup.CanAdd, 0)) as CanAdd,
				ISNULL(sf.SyncDirection, 1) AS SyncDirection,
				CASE
					WHEN iis.CMFolderKey IS NOT NULL THEN 1
					ELSE 0
				END AS IncludeInSync,
				0 AS IsDefault,
				ISNULL(sfg.SyncDirection, 1) AS GoogleSyncDirection,
				ISNULL(f.GoogleSyncFolderKey, 0) AS GoogleSyncFolderKey,
				ISNULL(sfg.SyncFolderName,'DO NOT SYNC') AS GoogleSyncFolderName,
				f.GoogleAccessCode,
				f.GoogleRefreshToken,
				sfg.GoogleLastSync							
		FROM	tCMFolder f (NOLOCK)
		left outer join (Select * from tCMFolderSecurity (nolock) 
			Where Entity = 'tSecurityGroup' and EntityKey = @SecurityGroupKey) as securityGroup 
				on f.CMFolderKey = securityGroup.CMFolderKey
		left outer join (Select * from tCMFolderSecurity (nolock) Where Entity = 'tUser' and EntityKey = @UserKey) as securityUser
			on f.CMFolderKey = securityUser.CMFolderKey
		LEFT JOIN tSyncFolder sf (nolock) ON f.SyncFolderKey = sf.SyncFolderKey
		LEFT JOIN tSyncFolder sfg (nolock) ON f.GoogleSyncFolderKey = sfg.SyncFolderKey
		LEFT JOIN tCMFolderIncludeInSync iis (nolock) ON f.CMFolderKey = iis.CMFolderKey AND iis.UserKey = @UserKey
		WHERE	f.Entity = 'tUser' 
		AND		f.CompanyKey = @CompanyKey
		AND		f.UserKey = 0
	END
END



IF @List = 'tCMFolderCompany'
BEGIN
	Select @SecurityGroupKey = SecurityGroupKey from tUser (nolock) Where UserKey = @UserKey
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tCMFolder (nolock)
				WHERE	Entity = 'tCompany' and CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)


	SELECT	f.*,
			'Public' as FolderType,
			ISNULL(securityUser.CanView, ISNULL(securityGroup.CanView, 0)) as CanView, -- Not required?
			ISNULL(securityUser.CanAdd, ISNULL(securityGroup.CanAdd, 0)) as CanAdd
	FROM	tCMFolder f (NOLOCK)
			left outer join (Select * from tCMFolderSecurity (nolock) 
			Where Entity = 'tSecurityGroup' and EntityKey = @SecurityGroupKey) as securityGroup 
				on f.CMFolderKey = securityGroup.CMFolderKey
			left outer join (Select * from tCMFolderSecurity (nolock) Where Entity = 'tUser' and EntityKey = @UserKey) as securityUser
				on f.CMFolderKey = securityUser.CMFolderKey
	WHERE	f.Entity = 'tCompany' and CompanyKey = @CompanyKey

	ORDER BY FolderName
END	


IF @List = 'tCMFolderLead'
BEGIN
	Select @SecurityGroupKey = SecurityGroupKey from tUser (nolock) Where UserKey = @UserKey
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tCMFolder (nolock)
				WHERE	Entity = 'tUserLead' and CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)


	SELECT	f.*,
			'Public' as FolderType,
			ISNULL(securityUser.CanView, ISNULL(securityGroup.CanView, 0)) as CanView, -- Not required?
			ISNULL(securityUser.CanAdd, ISNULL(securityGroup.CanAdd, 0)) as CanAdd
	FROM	tCMFolder f (NOLOCK)
			left outer join (Select * from tCMFolderSecurity (nolock) 
			Where Entity = 'tSecurityGroup' and EntityKey = @SecurityGroupKey) as securityGroup 
				on f.CMFolderKey = securityGroup.CMFolderKey
			left outer join (Select * from tCMFolderSecurity (nolock) Where Entity = 'tUser' and EntityKey = @UserKey) as securityUser
				on f.CMFolderKey = securityUser.CMFolderKey
	WHERE	f.Entity = 'tUserLead' and CompanyKey = @CompanyKey

	ORDER BY FolderName
END	

IF @List = 'tCMFolderOpportunity'
BEGIN
	Select @SecurityGroupKey = SecurityGroupKey from tUser (nolock) Where UserKey = @UserKey
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tCMFolder (nolock)
				WHERE	Entity = 'tLead' and CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)


	SELECT	f.*,
			'Public' as FolderType,
			ISNULL(securityUser.CanView, ISNULL(securityGroup.CanView, 0)) as CanView, -- Not required?
			ISNULL(securityUser.CanAdd, ISNULL(securityGroup.CanAdd, 0)) as CanAdd
	FROM	tCMFolder f (NOLOCK)
			left outer join (Select * from tCMFolderSecurity (nolock) 
			Where Entity = 'tSecurityGroup' and EntityKey = @SecurityGroupKey) as securityGroup 
				on f.CMFolderKey = securityGroup.CMFolderKey
			left outer join (Select * from tCMFolderSecurity (nolock) Where Entity = 'tUser' and EntityKey = @UserKey) as securityUser
				on f.CMFolderKey = securityUser.CMFolderKey
	WHERE	f.Entity = 'tLead' and CompanyKey = @CompanyKey

	ORDER BY FolderName
END	


IF @List = 'tCMFolderActivity'
BEGIN
	Select @SecurityGroupKey = SecurityGroupKey from tUser (nolock) Where UserKey = @UserKey
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tCMFolder (nolock)
				WHERE	Entity = 'tActivity' and CompanyKey = @CompanyKey
				AND (UserKey = 0 or UserKey = @UserKey)
				AND		LastModified > @CheckTime)


	SELECT	f.*,
			Case When f.UserKey = 0 then 'Public' else 'Personal' end as FolderType,
			Case When f.UserKey > 0 then  1 else ISNULL(securityUser.CanView, ISNULL(securityGroup.CanView, 0)) end as CanView,
			Case When f.UserKey > 0 then  1 else ISNULL(securityUser.CanAdd, ISNULL(securityGroup.CanAdd, 0)) end as CanAdd
	FROM	tCMFolder f (NOLOCK)
			left outer join (Select * from tCMFolderSecurity (nolock) Where Entity = 'tSecurityGroup' and EntityKey = @SecurityGroupKey) as securityGroup 
				on f.CMFolderKey = securityGroup.CMFolderKey
			left outer join (Select * from tCMFolderSecurity (nolock) Where Entity = 'tUser' and EntityKey = @UserKey) as securityUser
				on f.CMFolderKey = securityUser.CMFolderKey
	WHERE	f.Entity = 'tActivity' and CompanyKey = @CompanyKey
			AND (UserKey = 0 or UserKey = @UserKey)

	ORDER BY UserKey DESC, FolderName
END	


IF @List = 'tSource'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tSource (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
	SELECT	*
	FROM	tSource (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	ORDER BY SourceName
END	


IF @List = 'tNotification'
BEGIN
	SELECT	*
	FROM	tNotification (NOLOCK)
	ORDER BY DisplayGroup, DisplayOrder
END	


IF @List = 'tUserRole'
BEGIN
	SELECT	*
	FROM	tUserRole (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	ORDER BY UserRole
END	

IF @List = 'tDistributionGroup'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tDistributionGroup (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
	SELECT	*, 
			GroupName AS UserName --For use by the Calendar Add Users component
	FROM	tDistributionGroup (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	AND		(ISNULL(Personal, 0) = 0 OR UserKey = @UserKey)
	ORDER BY GroupName
END

IF @List = 'tCalendarResource'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tCalendarResource (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
	SELECT	*, 
			ResourceName AS UserName --For use by the Calendar Add Users component
	FROM	tCalendarResource (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	ORDER BY ResourceName
END


IF @List = 'tSalesTax'
BEGIN
	SELECT	st.*,
			v.VendorID AS PayToID,
			v.CompanyName AS PayToName,
			pgl.AccountNumber AS PayableGLAccountNumber,
			pgl.AccountName AS PayableGLAccountName,
			apgl.AccountNumber AS APPayableGLAccountNumber,
			apgl.AccountName AS APPayableGLAccountName
	FROM	tSalesTax st (NOLOCK)
	LEFT JOIN tCompany v (nolock) ON st.PayTo = v.CompanyKey
	LEFT JOIN tGLAccount pgl (nolock) ON st.PayableGLAccountKey = pgl.GLAccountKey
	LEFT JOIN tGLAccount apgl (nolock) ON st.APPayableGLAccountKey = apgl.GLAccountKey
	WHERE	st.CompanyKey = @CompanyKey
	ORDER BY st.Active DESC, st.SalesTaxID, st.SalesTaxName
END	

IF @List = 'tInvoiceTemplate'
BEGIN
 SELECT *, TemplateName AS FormattedName
 FROM tInvoiceTemplate (NOLOCK)
 WHERE CompanyKey = @CompanyKey
 ORDER BY TemplateName
END

IF @List = 'tEstimateTemplate'
BEGIN
	SELECT *, TemplateName AS FormattedName
	FROM	tEstimateTemplate (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	ORDER BY TemplateName
END

IF @List = 'tViewSecurityGroup'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tViewSecurityGroup (nolock) inner join tSecurityGroup (nolock) on tViewSecurityGroup.SecurityGroupKey = tSecurityGroup.SecurityGroupKey
				WHERE	tSecurityGroup.CompanyKey = @CompanyKey
				AND		tViewSecurityGroup.LastModified > @CheckTime)
	SELECT	tViewSecurityGroup.*
	FROM	tViewSecurityGroup (NOLOCK) inner join tSecurityGroup (nolock) on tViewSecurityGroup.SecurityGroupKey = tSecurityGroup.SecurityGroupKey
	WHERE	tSecurityGroup.CompanyKey = @CompanyKey
END

IF @List = 'tActivityType'
BEGIN
	SELECT	a.*
	FROM	tActivityType a (NOLOCK) 
	WHERE	a.CompanyKey = @CompanyKey
	Order By TypeName
END



IF @List = 'tMediaUnitType'
BEGIN
	SELECT	tMediaUnitType.*
	FROM	tMediaUnitType (NOLOCK) 
	Order By POKind, DisplayOrder
END


IF @List = 'tMediaAffiliate'
BEGIN
-- List for networks for broadcast stations
	SELECT	tMediaAffiliate.*
	FROM	tMediaAffiliate (NOLOCK) 
	WHERE	tMediaAffiliate.CompanyKey = @CompanyKey
	Order By AffiliateID, AffiliateName
END

IF @List = 'tMediaMarket'
BEGIN
	SELECT	tMediaMarket.*
	FROM	tMediaMarket (NOLOCK) 
	WHERE	tMediaMarket.CompanyKey = @CompanyKey
	Order By MarketID, MarketName
END

IF @List = 'tMediaPosition'
BEGIN
	SELECT	tMediaPosition.*
	FROM	tMediaPosition (NOLOCK) 
	WHERE	tMediaPosition.CompanyKey = @CompanyKey
	Order By PositionID, PositionName
END

IF @List = 'tMediaSpace'
BEGIN
	SELECT	tMediaUnitType.UnitTypeName, tMediaUnitType.UnitTypeID, tMediaSpace.*,
	CASE ISNULL(tMediaUnitType.Qty1, '') 
		WHEN '' THEN ISNULL(tMediaSpace.Qty1,0)
		ELSE ISNULL(tMediaSpace.Qty1,0) * ISNULL(tMediaSpace.Qty2, 0)
	END AS Quantity
	FROM	tMediaSpace (NOLOCK) 
	LEFT OUTER JOIN tMediaUnitType (NOLOCK) ON tMediaUnitType.MediaUnitTypeKey = tMediaSpace.MediaUnitTypeKey
	WHERE	tMediaSpace.CompanyKey = @CompanyKey
	Order By SpaceID, SpaceName
END

IF @List = 'tMediaDemographic'
BEGIN
	SELECT	tMediaDemographic.*
	FROM	tMediaDemographic (NOLOCK) 
	WHERE	tMediaDemographic.CompanyKey = @CompanyKey
	Order By DemographicID, DemographicName
END

IF @List = 'tMediaCategory'
BEGIN
	SELECT	tMediaCategory.*
	FROM	tMediaCategory (NOLOCK) 
	WHERE	tMediaCategory.CompanyKey = @CompanyKey
	Order By CategoryID, CategoryName
END

IF @List = 'tMediaDays'
BEGIN
	SELECT	tMediaDays.*
	FROM	tMediaDays (NOLOCK) 
	WHERE	tMediaDays.CompanyKey = @CompanyKey
	Order By tMediaDays.Days
END

IF @List = 'tMediaStdComment'
BEGIN
	SELECT	tMediaStdComment.*
	FROM	tMediaStdComment (NOLOCK) 
	WHERE	tMediaStdComment.CompanyKey = @CompanyKey
	Order By tMediaStdComment.CommentID
END

IF @List = 'tMediaPremium'
BEGIN
	SELECT	tMediaPremium.*
	FROM	tMediaPremium (NOLOCK) 
	WHERE	tMediaPremium.CompanyKey = @CompanyKey
END

IF @List = 'tMediaBroadcastLength'
BEGIN
	SELECT	tMediaBroadcastLength.*
	FROM	tMediaBroadcastLength (NOLOCK) 
	WHERE	tMediaBroadcastLength.CompanyKey = @CompanyKey
	Order By tMediaBroadcastLength.BroadcastLengthID
END

-- Added Days to the list for Display
IF @List = 'tMediaDayPart'
BEGIN
	SELECT	tMediaDayPart.*, tMediaDays.Days
	FROM	tMediaDayPart (NOLOCK) 
	left outer join tMediaDays (NOLOCK) on tMediaDayPart.MediaDayKey = tMediaDays.MediaDayKey
	WHERE	tMediaDayPart.CompanyKey = @CompanyKey
	Order By tMediaDayPart.DayPartID
END

IF @List = 'tMediaRevisionReason'
BEGIN
	SELECT	tMediaRevisionReason.*
	FROM	tMediaRevisionReason (NOLOCK) 
	WHERE	tMediaRevisionReason.CompanyKey = @CompanyKey
	Order By ReasonID
END

IF @List = 'tWriteOffReason'
BEGIN
	SELECT	tWriteOffReason.*
	FROM	tWriteOffReason (NOLOCK) 
	WHERE	tWriteOffReason.CompanyKey = @CompanyKey
	Order By ReasonName
END

IF @List = 'tRequestRejectReason'
BEGIN
	SELECT	tRequestRejectReason.*
	FROM	tRequestRejectReason (NOLOCK) 
	WHERE	tRequestRejectReason.CompanyKey = @CompanyKey
	Order By ReasonName
END

IF @List = 'tEstimate'
BEGIN
	SELECT	tEstimate.*
			,EstimateName as FormattedName
	FROM	tEstimate (NOLOCK) 
	WHERE	tEstimate.CompanyKey = @CompanyKey
	AND     tEstimate.ProjectKey IS NULL
	AND     tEstimate.CampaignKey IS NULL
	AND     tEstimate.LeadKey IS NULL
	Order By EstimateName
END

IF @List = 'POLineType'
BEGIN
  SELECT *
  FROM tFieldSet (NOLOCK)
  WHERE
   OwnerEntityKey = @CompanyKey AND
   AssociatedEntity = 'PO_Detail'
  ORDER BY AssociatedEntity, FieldSetName
END

IF @List = 'tLayout'
BEGIN
	SELECT * 
	FROM tLayout (NOLOCK) 
	WHERE CompanyKey = @CompanyKey 
	ORDER BY LayoutName
END

IF @List = 'tTimelineSegment'
BEGIN
	SELECT	*,
			SegmentName as FormattedName
	FROM	tTimelineSegment (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	ORDER BY SegmentName
END

IF @List = 'tAddress'
	BEGIN
		EXEC sptAddressGetDDList NULL, @CompanyKey, '', '', 0
	END

IF @List = 'tWebDavServer'
	SELECT	*
	FROM	tWebDavServer (nolock)
	WHERE	CompanyKey = @CompanyKey
	ORDER BY URL

IF @List = 'tCheckFormat'
	SELECT	*
	FROM	tCheckFormat (nolock)
	WHERE	CompanyKey = @CompanyKey
	ORDER BY FormatName

IF @List = 'ProjectTemplates'
	SELECT	*, ISNULL(ProjectNumber, '') + '-' + ISNULL(ProjectName, '')  AS DisplayName
	FROM	tProject (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		Template = 1
	ORDER BY ProjectNumber

IF @List = 'tFlatFile'
	SELECT *
	FROM tFlatFile (nolock)
	WHERE CompanyKey = @CompanyKey
	ORDER BY LayoutName

IF @List = 'tPublishCalendar'
BEGIN
	SELECT	@SecurityGroupKey = SecurityGroupKey,
			@Administrator = Administrator
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey

	SELECT	*
	FROM	tPublishCalendar (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		(@Administrator = 1
		OR	PublishCalendarKey IN (SELECT PublishCalendarKey FROM tPublishCalendarSecurity (nolock) WHERE SecurityGroupKey = @SecurityGroupKey))
	ORDER BY PublishCalendarName
END

IF @List = 'tColumnSet'
	SELECT	*
	FROM	tColumnSet (nolock)
	WHERE	CompanyKey = @CompanyKey
	ORDER BY SetName	


IF @List = 'tBillingGroup'
BEGIN

	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tBillingGroup (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *,
			glc.GLCompanyID,
			glc.GLCompanyName
		 from tBillingGroup (nolock) 
		 Left Outer Join tGLCompany glc (nolock) on tBillingGroup.GLCompanyKey = glc.GLCompanyKey
		 Where tBillingGroup.CompanyKey = @CompanyKey 	
		 order by BillingGroupCode, tBillingGroup.Description

	RETURN
END

IF @List = 'tCompanyMediaContract'
	SELECT	*
	FROM	tCompanyMediaContract (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	ORDER BY ContractID


IF @List = 'tCurrency'
BEGIN
	-- This is a seeded list of currencies, used by the exchange rate extractor
	-- also used to select from on bank accounts and credit cards

	declare @HomeCurrencyID varchar(10)
	select @HomeCurrencyID = CurrencyID from tPreference (nolock) where CompanyKey = @CompanyKey

	SELECT	*
	FROM	tCurrency (NOLOCK) 
	where   CurrencyID <> isnull(@HomeCurrencyID, '') 
	Order By CurrencyID
END

IF @List = 'tCurrencyCompany'
BEGIN
	-- This is a list of currencies on bank accounts for the company
	-- which represents a shorter list of currencies that a company trades with
	select distinct gla.CurrencyID, curr.Description
	from   tGLAccount gla (nolock)
		inner join tPreference pref (nolock) on gla.CompanyKey = pref.CompanyKey 
		inner join tCurrency curr (nolock) on gla.CurrencyID = curr.CurrencyID
	where gla.CompanyKey = @CompanyKey
	and   gla.AccountType = 10 -- Bank Account
	and   gla.CurrencyID is not null
	and   pref.CurrencyID is not null
	and   pref.MultiCurrency = 1 -- only if we use multiple currencies
	and   gla.CurrencyID <> pref.CurrencyID -- different from the home currency
	order by gla.CurrencyID
END

IF @List = 'tTitle'
BEGIN
	SELECT	tTitle.*
	       ,d.DepartmentName
	       ,wt.WorkTypeID, wt.WorkTypeName
	       ,gla.AccountNumber AS SalesAccountNumber, gla.AccountName AS SalesAccountName
	FROM	tTitle (nolock) left outer Join tDepartment d (nolock) on tTitle.DepartmentKey = d.DepartmentKey
							left outer join tWorkType wt (nolock) on tTitle.WorkTypeKey =  wt.WorkTypeKey 
							left outer join tGLAccount gla (nolock) on tTitle.GLAccountKey = gla.GLAccountKey
	WHERE	tTitle.CompanyKey = @CompanyKey
	Order By tTitle.TitleID, tTitle.TitleName
END

IF @List = 'tTitleRateSheet'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tTitleRateSheet (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select *
		 from tTitleRateSheet (nolock) Where CompanyKey = @CompanyKey 
		order by RateSheetName

	RETURN
END

IF @List = 'tTitleRateSheetDetail'
BEGIN
	IF @CheckTime IS NULL
		OR EXISTS
				(SELECT NULL
				FROM	tTitleRateSheet (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		LastModified > @CheckTime)
		select tsd.*
		 from tTitleRateSheetDetail tsd (nolock) 
		 inner join tTitleRateSheet ts (nolock) on tsd.TitleRateSheetKey = ts.TitleRateSheetKey
		 Where CompanyKey = @CompanyKey 

	RETURN
END
GO
