USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGlobalSearch]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGlobalSearch]
	(
	@CompanyKey int,
	@UserKey int,
	@SearchText varchar(200),
	@ActiveProjects int,
	@InactiveProjects int,
    @Invoices int,
    @Receipts int,
    @PurchaseOrders int,
    @VendorInvoices int,
    @VendorPayments int,
    @BroadcastOrders int,
    @InsertionOrders int,
    @Meetings int,
    @Companies int,
    @Contacts int,
    @Opportunities int,
    @Leads int,
    @Activities int,
	@ActivityNotes int,
	@TrackingForms int,
	@CreditCardCharges int,
	@ActiveCampaigns int,
	@InactiveCampaigns int,
	@RestrictToGLCompany int = 0
	)

AS

/*
|| When      Who Rel      What
|| 10/20/09  CRG 10.5.1.2 Added Recurring and ParentKey to the Meeting queries
|| 11/10/09  GWG 10.5.1.3 Added Tracking Forms
|| 11/11/09  GWG 10.5.1.4 Changed a join on the invoice search
|| 03/08/10	 RLB 10.5.1.9 Added Administrator Right to filters
|| 3/8/10    CRG 10.5.1.9 Modified so that if user is an Administrator, we won't have to query tRightAssigned
|| 5/2/10    GWG 10.5.2.2 Modified the project search to active only.
|| 7/22/10   RLB 10.5.3.2 Changed projects to active projects and added inactive projects
|| 4/4/11    RLB 10.5.4.2 (106484) Added Primary contact and any people on a lead for Opportunities
|| 07/27/11  GHL 10.5.4.6 (115679) Added @ActivityNotes so that we can avoid to search activity notes (takes too long)
|| 09/23/11  RLB 10.5.4.8 (122023) fixed some admin rights in a few sections
|| 05/01/12  GWG 10.5.5.5 Added company name on user lead search
|| 05/13/12  GWG 10.5.5.5 Added distinct clause to opportunity search w join down to person, it was returning more than 1 row 
|| 05/29/12  GHL 10.5.5.6 Added support for GLCompany restriction
||                        Projects should be checked in tAssignment OR tUserGLCompanyAccess 
|| 06/14/12  RLB 10.5.5.7 (146475) Wrapped First and Last Name in an ISNULL in case there is none on contact and Leads
|| 12/07/12  GHL 10.5.6.2 For vouchers, added CreditCard = 0
|| 12/07/12  GHL 10.5.6.3 Added credit card charges
|| 12/10/13  RLB 10.5.7.5 (196191) Added Active and inactive campaigns
*/

declare @SecurityGroupKey int, @ClientVendorLogin tinyint, @Administrator tinyint

Select @SecurityGroupKey = SecurityGroupKey, @ClientVendorLogin = ISNULL(ClientVendorLogin, 0), @Administrator = ISNULL(Administrator, 0)  from tUser Where UserKey = @UserKey
if (@ActiveProjects = 1) 
BEGIN
if ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 90918 and EntityType = 'Security Group' and EntityKey = @SecurityGroupKey))
	SELECT 
		p.ProjectKey as EntityKey,
		p.ProjectNumber + ' - ' + p.ProjectName as EntityName,
		'Active Projects' as Entity,
		c.CustomerID,
		c.CompanyName
	From tProject p (nolock)
	left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	Where
		p.CompanyKey = @CompanyKey
		AND p.Active = 1
		AND (p.ProjectNumber like '%' + @SearchText + '%' OR p.ProjectName like '%' + @SearchText + '%')
		AND (@RestrictToGLCompany = 0 
		    OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
			)
	Order By EntityName
ELSE
	SELECT 
		p.ProjectKey as EntityKey,
		p.ProjectNumber + ' - ' + p.ProjectName as EntityName,
		'Active Projects' as Entity,
		c.CustomerID,
		c.CompanyName
	From tProject p (nolock)
	inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
	left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	Where
		p.CompanyKey = @CompanyKey
		AND a.UserKey = @UserKey
		AND p.Active = 1
		AND (p.ProjectNumber like '%' + @SearchText + '%' OR p.ProjectName like '%' + @SearchText + '%')
	Order By EntityName
END
if (@InactiveProjects = 1) 
BEGIN
if ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 90918 and EntityType = 'Security Group' and EntityKey = @SecurityGroupKey))
	SELECT 
		p.ProjectKey as EntityKey,
		p.ProjectNumber + ' - ' + p.ProjectName as EntityName,
		'Inactive Projects' as Entity,
		c.CustomerID,
		c.CompanyName
	From tProject p (nolock)
	left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	Where
		p.CompanyKey = @CompanyKey
		AND p.Active = 0
		AND (p.ProjectNumber like '%' + @SearchText + '%' OR p.ProjectName like '%' + @SearchText + '%')
		AND (@RestrictToGLCompany = 0 
		    OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
			)
	Order By EntityName
ELSE
	SELECT 
		p.ProjectKey as EntityKey,
		p.ProjectNumber + ' - ' + p.ProjectName as EntityName,
		'Inactive Projects' as Entity,
		c.CustomerID,
		c.CompanyName
	From tProject p (nolock)
	inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
	left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	Where
		p.CompanyKey = @CompanyKey
		AND a.UserKey = @UserKey
		AND p.Active = 0
		AND (p.ProjectNumber like '%' + @SearchText + '%' OR p.ProjectName like '%' + @SearchText + '%')
	Order By EntityName
END

if (@Invoices = 1) AND ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 30100 and EntityType = 'Security Group' and EntityKey = @SecurityGroupKey))
	SELECT 
		InvoiceKey as EntityKey,
		InvoiceNumber as EntityName,
		'Invoices' as Entity,
		InvoiceDate,
		c.CustomerID,
		c.CompanyName
	From tInvoice i (nolock) 
	inner join tCompany c on i.ClientKey = c.CompanyKey
	Where i.CompanyKey = @CompanyKey and InvoiceNumber like '%' + @SearchText + '%'
	AND (@RestrictToGLCompany = 0 
		    OR i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
		)

	Order By EntityName

if (@Receipts = 1) AND ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 30200 and EntityKey = @SecurityGroupKey))
	SELECT 
		CheckKey as EntityKey,
		ReferenceNumber as EntityName,
		'Receipts' as Entity,
		CheckDate,
		CustomerID,
		CompanyName
	From tCheck (nolock) 
	inner join tCompany on tCheck.ClientKey = tCompany.CompanyKey
	Where OwnerCompanyKey = @CompanyKey and ReferenceNumber like '%' + @SearchText + '%'
	AND (@RestrictToGLCompany = 0 
		    OR tCheck.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
		)	
	Order By EntityName

if (@PurchaseOrders = 1) AND ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 60100 and EntityKey = @SecurityGroupKey))
	SELECT 
		PurchaseOrderKey as EntityKey,
		PurchaseOrderNumber as EntityName,
		'Purchase Orders' as Entity,
		p.PODate,
		c.VendorID,
		c.CompanyName
	From tPurchaseOrder p (nolock) 
	inner join tCompany c (nolock) on p.VendorKey = c.CompanyKey
	Where p.CompanyKey = @CompanyKey and POKind = 0 and PurchaseOrderNumber like '%' + @SearchText + '%'
	AND (@RestrictToGLCompany = 0 
		    OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
		)	

	Order By EntityName
	
if (@VendorInvoices = 1) AND ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 60300 and EntityKey = @SecurityGroupKey))
	SELECT 
		VoucherKey as EntityKey,
		InvoiceNumber as EntityName,
		'Vendor Invoices' as Entity,
		InvoiceDate,
		c.VendorID,
		c.CompanyName
	From tVoucher v (nolock) 
	inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
	Where v.CompanyKey = @CompanyKey and InvoiceNumber like '%' + @SearchText + '%'
	and   isnull(v.CreditCard, 0) = 0
	AND (@RestrictToGLCompany = 0 
		    OR v.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
		)	

	Order By EntityName

if @CreditCardCharges = 1
begin
	declare @EditOtherCreditCardCharge int
	select @EditOtherCreditCardCharge = 0
	if @Administrator = 1 Or exists  (Select 1 from tRightAssigned (nolock) Where RightKey = 60402 and EntityKey = @SecurityGroupKey) 
		select @EditOtherCreditCardCharge =1
	
	SELECT 
		VoucherKey as EntityKey,
		InvoiceNumber as EntityName,
		'Credit Card Charges' as Entity,
		InvoiceDate,
		c.VendorID,
		c.CompanyName
	From tVoucher v (nolock) 
	inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
	Where v.CompanyKey = @CompanyKey and InvoiceNumber like '%' + @SearchText + '%'
	and   isnull(v.CreditCard, 0) = 1
	AND (@RestrictToGLCompany = 0 
		    OR v.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
		)	
	AND (@EditOtherCreditCardCharge =1
			Or v.BoughtByKey = @UserKey
		)

	Order By EntityName
end

if (@VendorPayments = 1) AND ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 61300 and EntityKey = @SecurityGroupKey))
	SELECT 
		PaymentKey as EntityKey,
		CheckNumber as EntityName,
		'Vendor Payments' as Entity,
		PaymentDate,
		c.VendorID,
		c.CompanyName
	From tPayment p (nolock) 
	inner join tCompany c (nolock) on p.VendorKey = c.CompanyKey
	Where p.CompanyKey = @CompanyKey and CheckNumber like '%' + @SearchText + '%'
	AND (@RestrictToGLCompany = 0 
		    OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
		)	

	Order By EntityName


if (@InsertionOrders = 1) AND ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 500010 and EntityKey = @SecurityGroupKey))
	SELECT 
		PurchaseOrderKey as EntityKey,
		PurchaseOrderNumber as EntityName,
		'Insertion Orders' as Entity,
		p.PODate,
		c.VendorID,
		c.CompanyName
	From tPurchaseOrder p (nolock) 
	inner join tCompany c (nolock) on p.VendorKey = c.CompanyKey
	Where p.CompanyKey = @CompanyKey and POKind = 1 and PurchaseOrderNumber like '%' + @SearchText + '%'
	AND (@RestrictToGLCompany = 0 
		    OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
		)	

	Order By EntityName
	

if (@BroadcastOrders = 1) AND ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 500020 and EntityKey = @SecurityGroupKey))
	SELECT 
		PurchaseOrderKey as EntityKey,
		PurchaseOrderNumber as EntityName,
		'Broadcast Orders' as Entity,
		p.PODate,
		c.VendorID,
		c.CompanyName
	From tPurchaseOrder p (nolock) 
	inner join tCompany c (nolock) on p.VendorKey = c.CompanyKey 
	Where p.CompanyKey = @CompanyKey and POKind = 2 and PurchaseOrderNumber like '%' + @SearchText + '%'
	AND (@RestrictToGLCompany = 0 
		    OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
		)	

	Order By EntityName
	
	

if (@Meetings = 1) AND ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 120100 and EntityKey = @SecurityGroupKey))
	SELECT 
		CalendarKey as EntityKey,
		Subject as EntityName,
		'Meetings' as Entity,
		EventStart,
		EventEnd,
		AllDayEvent,
		Recurring,
		ParentKey
	From tCalendar c (nolock) 
	Inner join (Select Distinct f.CMFolderKey from tCMFolderSecurity fs (nolock) 
		inner join tCMFolder f (nolock) on fs.CMFolderKey = f.CMFolderKey
		Where (fs.Entity = 'tSecurityGroup' and fs.EntityKey = @SecurityGroupKey 
		OR fs.Entity = 'tUser' and EntityKey = @UserKey) 
		and CanView = 1 and f.Entity = 'tCalendar') as tbl on c.CMFolderKey = tbl.CMFolderKey
	Where CompanyKey = @CompanyKey  and Subject like '%' + @SearchText + '%' 

	UNION
	
	SELECT 
		c.CalendarKey as EntityKey,
		Subject as EntityName,
		'Meetings' as Entity,
		EventStart,
		EventEnd,
		AllDayEvent,
		Recurring,
		ParentKey
	From tCalendar c (nolock)
	inner join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey 
	Where CompanyKey = @CompanyKey and ca.Entity in ('Organizer', 'Attendee') 
		and ca.EntityKey = @UserKey and Status <> 3 
		and Subject like '%' + @SearchText + '%' 
	
	Order By EntityName
	
Declare @UseFolder tinyint, @ViewOthers tinyint
	
if (@Leads = 1) AND ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 931400 and EntityKey = @SecurityGroupKey))
BEGIN
	Select @UseFolder = ISNULL(UseLeadFolders, 0) from tPreference (nolock) Where CompanyKey = @CompanyKey
	Select @ViewOthers = 1 From tRightAssigned (nolock) Where RightKey = 931401 and EntityKey = @SecurityGroupKey
	if @UseFolder = 1
		SELECT 
			UserLeadKey as EntityKey,
			ISNULL(FirstName + ' ', '') + ISNULL(LastName, '') as EntityName,
			'Leads' as Entity
		From tUserLead t (nolock) 
		Where CompanyKey = @CompanyKey  and (ISNULL(FirstName + ' ', '') + ISNULL(LastName, '') like '%' + @SearchText + '%'  OR  CompanyName like '%' + @SearchText + '%')
			AND (@Administrator = 1 OR @ViewOthers = 1 OR OwnerKey = @UserKey)
			AND (CMFolderKey is null OR CMFolderKey in (Select Distinct f.CMFolderKey from tCMFolderSecurity fs (nolock) inner join tCMFolder f (nolock) on fs.CMFolderKey = f.CMFolderKey
								Where (fs.Entity = 'tSecurityGroup' and fs.EntityKey = @SecurityGroupKey 
								OR fs.Entity = 'tUser' and EntityKey = @UserKey) and CanView = 1 and f.Entity = 'tUserLead') )
	ELSE
		SELECT 
			UserLeadKey as EntityKey,
			ISNULL(FirstName + ' ', '') + ISNULL(LastName, '') as EntityName,
			'Leads' as Entity
		From tUserLead t (nolock) 
		Where CompanyKey = @CompanyKey  and (ISNULL(FirstName + ' ', '') + ISNULL(LastName, '') like '%' + @SearchText + '%'  OR  CompanyName like '%' + @SearchText + '%')
		AND (@Administrator = 1 OR @ViewOthers = 1 OR OwnerKey = @UserKey)
END

if (@Contacts = 1) AND ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 931600 and EntityKey = @SecurityGroupKey))
BEGIN
	Select @UseFolder = ISNULL(UseContactFolders, 0) from tPreference (nolock) Where CompanyKey = @CompanyKey
	Select @ViewOthers = 1 From tRightAssigned (nolock) Where RightKey = 931601 and EntityKey = @SecurityGroupKey
	if @UseFolder = 1
		SELECT 
			UserKey as EntityKey,
			ISNULL(FirstName + ' ', '') + ISNULL(LastName, '') as EntityName,
			'Contacts' as Entity,
			ISNULL(u.UserCompanyName, c.CompanyName) as CompanyName,
			u.Email,
			u.Phone1 AS Phone1
		From tUser u (nolock) 
		left outer join tCompany c on u.CompanyKey = c.CompanyKey
		Where u.OwnerCompanyKey = @CompanyKey  and (ISNULL(FirstName + ' ', '')  + ISNULL(LastName, '') like '%' + @SearchText + '%' OR c.CompanyName like '%' + @SearchText + '%')
			AND (@Administrator = 1 OR @ViewOthers = 1 OR OwnerKey = @UserKey)
			AND (u.CMFolderKey is null OR u.CMFolderKey in (Select Distinct f.CMFolderKey from tCMFolderSecurity fs (nolock) inner join tCMFolder f (nolock) on fs.CMFolderKey = f.CMFolderKey
								Where (fs.Entity = 'tSecurityGroup' and fs.EntityKey = @SecurityGroupKey 
								OR fs.Entity = 'tUser' and EntityKey = @UserKey) and CanView = 1 and f.Entity = 'tUser') )
	ELSE
		SELECT 
			UserKey as EntityKey,
			ISNULL(FirstName + ' ', '') + ISNULL(LastName, '') as EntityName,
			'Contacts' as Entity,
			u.Email,
			ISNULL(u.UserCompanyName, c.CompanyName) as CompanyName,
			u.Phone1 AS Phone1
		From tUser u (nolock)
		left outer join tCompany c on u.CompanyKey = c.CompanyKey
		Where u.OwnerCompanyKey = @CompanyKey  and (ISNULL(FirstName + ' ', '') + ISNULL(LastName, '') like '%' + @SearchText + '%' OR c.CompanyName like '%' + @SearchText + '%')
		AND (@Administrator = 1 OR @ViewOthers = 1 OR OwnerKey = @UserKey)
END



if (@Companies = 1) AND ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 931700 and EntityKey = @SecurityGroupKey))
BEGIN
	Select @UseFolder = ISNULL(UseCompanyFolders, 0) from tPreference (nolock) Where CompanyKey = @CompanyKey
	Select @ViewOthers = 1 From tRightAssigned (nolock) Where RightKey = 931701 and EntityKey = @SecurityGroupKey
	if @UseFolder = 1
		SELECT  
			CompanyKey as EntityKey,
			CompanyName as EntityName,
			'Companies' as Entity,
			Phone as Phone
		From tCompany t (nolock) 
		Where OwnerCompanyKey = @CompanyKey  and CompanyName like '%' + @SearchText + '%'  
			AND (@Administrator = 1 OR @ViewOthers = 1 OR AccountManagerKey = @UserKey)
			AND (CMFolderKey is null OR CMFolderKey in (Select Distinct f.CMFolderKey from tCMFolderSecurity fs (nolock) inner join tCMFolder f (nolock) on fs.CMFolderKey = f.CMFolderKey
								Where (fs.Entity = 'tSecurityGroup' and fs.EntityKey = @SecurityGroupKey 
								OR fs.Entity = 'tUser' and EntityKey = @UserKey) and CanView = 1 and f.Entity = 'tCompany') )
	ELSE
		SELECT 
			CompanyKey as EntityKey,
			CompanyName as EntityName,
			'Companies' as Entity,
			Phone as Phone
		From tCompany t (nolock) 
		Where OwnerCompanyKey = @CompanyKey  and CompanyName like '%' + @SearchText + '%'
		AND (@Administrator = 1 OR @ViewOthers = 1 OR AccountManagerKey = @UserKey)
END


if (@Opportunities = 1) AND ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 931100 and EntityKey = @SecurityGroupKey))
BEGIN
	Select @UseFolder = ISNULL(UseOppFolders, 0) from tPreference (nolock) Where CompanyKey = @CompanyKey
	Select @ViewOthers = 1 From tRightAssigned (nolock) Where RightKey = 931101 and EntityKey = @SecurityGroupKey
	if @UseFolder = 1
		SELECT DISTINCT
			l.LeadKey as EntityKey,
			Subject as EntityName,
			'Opportunities' as Entity,
			c.CompanyName,
			l.SaleAmount,
			u.Phone1 AS Phone1
		From tLead l (nolock) 
		inner join tCompany c on l.ContactCompanyKey = c.CompanyKey
		left outer join tLeadUser lu (nolock) on l.LeadKey = lu.LeadKey
		left outer join tUser u (nolock) on l.ContactKey = u.UserKey
		left outer join tUser luo (nolock) on lu.UserKey = luo.UserKey
		Where l.CompanyKey = @CompanyKey  and (Subject like '%' + @SearchText + '%' OR u.FirstName + ' ' + u.LastName like '%' + @SearchText + '%' OR luo.FirstName + ' ' + luo.LastName like '%' + @SearchText + '%') 
			AND (@Administrator = 1 OR @ViewOthers = 1 OR l.AccountManagerKey = @UserKey)
			AND (l.CMFolderKey is null OR l.CMFolderKey in (Select Distinct f.CMFolderKey from tCMFolderSecurity fs (nolock) inner join tCMFolder f (nolock) on fs.CMFolderKey = f.CMFolderKey
								Where (fs.Entity = 'tSecurityGroup' and fs.EntityKey = @SecurityGroupKey 
								OR fs.Entity = 'tUser' and EntityKey = @UserKey) and CanView = 1 and f.Entity = 'tLead') )
	ELSE
		SELECT DISTINCT
			l.LeadKey as EntityKey,
			Subject as EntityName,
			'Opportunities' as Entity,
			c.CompanyName,
			l.SaleAmount,
			u.Phone1 AS Phone1
		From tLead l (nolock) 
		inner join tCompany c on l.ContactCompanyKey = c.CompanyKey
		left outer join tLeadUser lu (nolock) on l.LeadKey = lu.LeadKey
		left outer join tUser u (nolock) on l.ContactKey = u.UserKey
		left outer join tUser luo (nolock) on lu.UserKey = luo.UserKey
		Where l.CompanyKey = @CompanyKey  and (Subject like '%' + @SearchText + '%' OR u.FirstName + ' ' + u.LastName like '%' + @SearchText + '%' OR luo.FirstName + ' ' + luo.LastName like '%' + @SearchText + '%') 
			AND (@Administrator = 1 OR @ViewOthers = 1 OR l.AccountManagerKey = @UserKey)
END


if (@Activities = 1) 
AND (
	(@Administrator = 1) OR exists 
	(Select 1 from tRightAssigned (nolock) Where RightKey = 931500 and EntityKey = @SecurityGroupKey)
	)
BEGIN
	Select @UseFolder = ISNULL(UseActivityFolders, 0) from tPreference (nolock) Where CompanyKey = @CompanyKey
	Select @ViewOthers = 1 From tRightAssigned (nolock) Where RightKey = 931501 and EntityKey = @SecurityGroupKey
	if @UseFolder = 1
		SELECT 
			ActivityKey as EntityKey,
			Subject as EntityName,
			'Activities' as Entity,
			ProjectNumber,
			u.FirstName + ' ' + u.LastName as ContactName,
			ass.FirstName + ' ' + ass.LastName as AssignedTo
		From tActivity a (nolock) 
			left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey
			left outer join tUser u (nolock) on a.ContactKey = u.UserKey
			left outer join tUser ass (nolock) on a.ContactKey = ass.UserKey
		Where a.CompanyKey = @CompanyKey  
		and (
			Subject like '%' + @SearchText + '%' 
			OR (@ActivityNotes = 1 And (Notes like '%' + @SearchText + '%')) 
			OR p.ProjectNumber like '%' + @SearchText + '%' 
			)
		AND (@Administrator = 1 OR @ViewOthers = 1 OR AssignedUserKey = @UserKey or OriginatorUserKey = @UserKey)
		AND (a.CMFolderKey is null OR a.CMFolderKey in (Select Distinct f.CMFolderKey from tCMFolderSecurity fs (nolock) inner join tCMFolder f (nolock) on fs.CMFolderKey = f.CMFolderKey
								Where (fs.Entity = 'tSecurityGroup' and fs.EntityKey = @SecurityGroupKey 
								OR fs.Entity = 'tUser' and EntityKey = @UserKey) and CanView = 1 and f.Entity = 'tActivity') )
	ELSE
		SELECT 
			ActivityKey as EntityKey,
			Subject as EntityName,
			'Activities' as Entity,
			ProjectNumber,
			u.FirstName + ' ' + u.LastName as ContactName,
			ass.FirstName + ' ' + ass.LastName as AssignedTo
		From tActivity a (nolock) 
			left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey
			left outer join tUser u (nolock) on a.ContactKey = u.UserKey
			left outer join tUser ass (nolock) on a.ContactKey = ass.UserKey
		Where a.CompanyKey = @CompanyKey  
		and (
			Subject like '%' + @SearchText + '%'
			OR (@ActivityNotes = 1 And (Notes like '%' + @SearchText + '%')) 
			OR p.ProjectNumber like '%' + @SearchText + '%'
			)
		AND (@Administrator = 1 OR @ViewOthers = 1 OR AssignedUserKey = @UserKey or OriginatorUserKey = @UserKey)
END

if (@TrackingForms = 1)
BEGIN
-- Tracking Forms

	SELECT 
			FormKey as EntityKey,
			FormPrefix + '-' + Cast(FormNumber as Varchar) + ' - ' + Subject as EntityName,
			'Tracking Forms' as Entity,
			ProjectNumber,
			u.FirstName + ' ' + u.LastName as AssignedTo
	FROM
			tForm f (nolock) 
			inner join tFormDef fd (nolock) on f.FormDefKey = fd.FormDefKey
			inner join tSecurityAccess sa (nolock) on f.FormDefKey = sa.EntityKey and sa.Entity = 'tFormDef'
			left outer join tProject p (nolock) on f.ProjectKey = p.ProjectKey
			left outer join tUser u (nolock) on f.AssignedTo = u.UserKey
	WHERE
			sa.SecurityGroupKey = @SecurityGroupKey
			and f.CompanyKey = @CompanyKey
			and (f.Subject like '%' + @SearchText + '%' OR p.ProjectNumber like '%' + @SearchText + '%' OR f.FormNumber like '%' + @SearchText + '%')
END


if (@ActiveCampaigns = 1) and ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 90800 and EntityType = 'Security Group' and EntityKey = @SecurityGroupKey))
	SELECT
			cp.CampaignKey as EntityKey,
			cp.CampaignID + ' - ' + cp.CampaignName as EntityName,
			'Active Campaigns' as Entity,
			c.CustomerID,
			c.CompanyName
	FROM tCampaign cp (nolock)
	left outer join tCompany c (nolock) on cp.ClientKey = c.CompanyKey
	WHERE
			cp.CompanyKey = @CompanyKey
			ANd cp.Active = 1
			AND (cp.CampaignID like '%' + @SearchText + '%' OR cp.CampaignName like '%' + @SearchText + '%')
			AND (@RestrictToGLCompany = 0 
				OR cp.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
				)
	Order By EntityName


if (@InactiveCampaigns = 1) and ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 90800 and EntityType = 'Security Group' and EntityKey = @SecurityGroupKey))
	SELECT
				cp.CampaignKey as EntityKey,
				cp.CampaignID + ' - ' + cp.CampaignName as EntityName,
				'Inactive Campaigns' as Entity,
				c.CustomerID,
				c.CompanyName
		FROM tCampaign cp (nolock)
		left outer join tCompany c (nolock) on cp.ClientKey = c.CompanyKey
		WHERE
				cp.CompanyKey = @CompanyKey
				ANd cp.Active = 0
				AND (cp.CampaignID like '%' + @SearchText + '%' OR cp.CampaignName like '%' + @SearchText + '%')
				AND (@RestrictToGLCompany = 0 
					OR cp.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
					)
		Order By EntityName
GO
