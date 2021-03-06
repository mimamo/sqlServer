USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyListingGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyListingGet]
	 @CompanyKey int,
	 @UserKey int,
	 @Search varchar(100),
	 @GetFavorite tinyint,
	 @GetRecent tinyint
AS --Encrypt
	
/*
|| When     Who Rel     What
|| 07/23/14 RLB 105.8.2 Created for New App Company Dash
|| 09/08/14 RLB 105.8.4 Add check for rights to view other contacts
|| 10/07/14 RLB 105.8.5 Added GL Restict check
|| 02/09/15 GWG 10.589  Fixed the action id on recent
|| 03/20/15 RLB 10.590  Fixed the recent call not ordering DESC
|| 04/23/15 RLB 10.591  add isFavorite on search and recent 
*/ 	

	DECLARE	@UseCompanyFolders tinyint,
			@Administrator tinyint,
			@CanNotViewOthersCompanies tinyint,
			@CanNotViewOthersContacts tinyint,
			@SecurityGroupKey int,
			@GLCompanyRestrict tinyint
	
	SELECT	@SecurityGroupKey = SecurityGroupKey,
			@Administrator = Administrator
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey

	SELECT @CanNotViewOthersCompanies = 1

	SELECT @CanNotViewOthersContacts = 1

	-- check rights on other companies
	IF @Administrator = 1
		SELECT @CanNotViewOthersCompanies = 0
	ELSE
	if exists (select 1 from tRight r (nolock)
			inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
			where ra.EntityType = 'Security Group'
			and   ra.EntityKey = @SecurityGroupKey
			and   r.RightID = 'viewOtherCompanies')
		select @CanNotViewOthersCompanies = 0
		
	-- check rights on other contacts
	IF @Administrator = 1
		SELECT @CanNotViewOthersContacts = 0
	ELSE
	if exists (select 1 from tRight r (nolock)
			inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
			where ra.EntityType = 'Security Group'
			and   ra.EntityKey = @SecurityGroupKey
			and   r.RightID = 'viewOtherContacts')
		select @CanNotViewOthersContacts = 0

	SELECT	@UseCompanyFolders = ISNULL(UseCompanyFolders, 0),
			@GLCompanyRestrict = ISNULL(RestrictToGLCompany, 0)
	FROM	tPreference (nolock)
	WHERE	CompanyKey = @CompanyKey


	CREATE TABLE #folders
			(CMFolderKey int null)

	IF @UseCompanyFolders = 1
	BEGIN
			--Get a list of public activity folders that the logged user can see
		INSERT	#folders
				(CMFolderKey)
		SELECT 	f.CMFolderKey
		FROM	tCMFolder f (nolock)
		INNER JOIN tCMFolderSecurity fs (nolock) ON f.CMFolderKey = fs.CMFolderKey
		WHERE	f.CompanyKey = @CompanyKey
		AND		f.Entity = 'tCompany'
		AND		f.UserKey = 0
		AND		(
					(fs.Entity = 'tUser' AND fs.EntityKey = @UserKey)
					OR
					(fs.Entity = 'tSecurityGroup' AND fs.EntityKey = @SecurityGroupKey)
				)
		AND		(fs.CanView = 1 OR fs.CanAdd = 1)

		--Add the logged user's own personal folders
		INSERT	#folders
				(CMFolderKey)
		SELECT	CMFolderKey
		FROM	tCMFolder (nolock)
		WHERE	Entity = 'tCompany'
		AND		UserKey = @UserKey			

	END

	IF @GetFavorite = 1
---------Get Favorities Select--------------------------------------------------------------
	BEGIN
		SELECT
				c.*,
				ad.Address1 as Address1,		-- For backward compatibility
				ad.Address2 as Address2,		-- For backward compatibility
				ad.Address3 as Address3,		-- For backward compatibility
				ad.City as City, 				-- For backward compatibility
				ad.State as State, 				-- For backward compatibility
				ad.PostalCode as PostalCode, 	-- For backward compatibility
				ad.Country as Country,			-- For backward compatibility
				
				ad.Address1 as DAddress1,
				ad.Address2 as DAddress2,
				ad.Address3 as DAddress3,
				ad.City as DCity, 
				ad.State as DState, 
				ad.PostalCode as DPostalCode, 
				ad.Country as DCountry, 
				ad.AddressName as DAddressName,
				adb.Address1 as DBAddress1,
				adb.Address2 as DBAddress2,
				adb.Address3 as DBAddress3,
				adb.City as DBCity, 
				adb.State as DBState, 
				adb.PostalCode as DBPostalCode, 
				adb.Country as DBCountry, 
				adb.AddressName as DBAddressName,
				gl.AccountNumber as DefaultExpenseAccountNumber,
				gl.AccountName as DefaultExpenseAccountName,
				gl2.AccountNumber as DefaultSalesAccountNumber,
				gl2.AccountName as DefaultSalesAccountName,
				gl3.AccountNumber as DefaultAPAccountNumber,
				gl3.AccountName as DefaultAPAccountName,
				it.TemplateName,
				pc.CompanyName as ParentCompanyName,
				co.UserName as ContactOwnerName,
				pcu.FirstName + ' ' + pcu.LastName as PrimaryContactName,
				pcu.UserRole,
				c.CompanyKey as ContactCompanyKey,  -- name compatibility with the activities history
				am.FirstName + ' ' + am.LastName as AccountManagerName,
				apc.CustomerID as AlternatePayerClientID,
				apc.CompanyName as AlternatePayerCompanyName,
			    Case @CanNotViewOthersContacts
					when 1 then (Select COUNT(*) FROM tUser (NOLOCK) WHERE CompanyKey = c.CompanyKey  AND OwnerKey = @UserKey) 
					else  (Select COUNT(*) FROM tUser (NOLOCK) WHERE CompanyKey = c.CompanyKey )
				END as ContactCount
		  FROM tCompany c (nolock)
			left outer join tGLAccount gl (nolock) on c.DefaultExpenseAccountKey = gl.GLAccountKey
			left outer join tGLAccount gl2 (nolock) on c.DefaultSalesAccountKey = gl2.GLAccountKey
			left outer join tGLAccount gl3 (nolock) on c.DefaultAPAccountKey = gl3.GLAccountKey
			left outer join tInvoiceTemplate it (nolock) on c.InvoiceTemplateKey = it.InvoiceTemplateKey
			left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
			left outer join tAddress adb (nolock) on c.BillingAddressKey = adb.AddressKey
			left outer join tCompany pc (nolock) on c.ParentCompanyKey = pc.CompanyKey
			left outer join vUserName co (nolock) on c.ContactOwnerKey = co.UserKey
			left outer join tUser pcu (nolock) on c.PrimaryContact = pcu.UserKey
			left outer join tUser am (nolock) on c.AccountManagerKey = am.UserKey 
			left outer join tCompany apc (nolock) on c.AlternatePayerKey = apc.CompanyKey
			inner join tAppFavorite af (nolock) on c.CompanyKey = af.ActionKey AND af.ActionID = 'cm.companies' and af.UserKey = @UserKey
		  WHERE
		   c.OwnerCompanyKey = @CompanyKey
		   AND	(
					@UseCompanyFolders = 0
					OR 
					c.CMFolderKey IS NULL
					OR
					c.CMFolderKey IN (SELECT CMFolderKey FROM #folders)
				)
			AND (
					@CanNotViewOthersCompanies = 0
					OR
					c.ContactOwnerKey IS NULL
					OR
					c.ContactOwnerKey = @UserKey
				)
		   
		   RETURN 1
	END

	IF @GetRecent = 1
-------------------------Get Recent Select----------------------------------------------------------------------------------------
	BEGIN
		SELECT
					c.*,
					ad.Address1 as Address1,		-- For backward compatibility
					ad.Address2 as Address2,		-- For backward compatibility
					ad.Address3 as Address3,		-- For backward compatibility
					ad.City as City, 				-- For backward compatibility
					ad.State as State, 				-- For backward compatibility
					ad.PostalCode as PostalCode, 	-- For backward compatibility
					ad.Country as Country,			-- For backward compatibility
					
					ad.Address1 as DAddress1,
					ad.Address2 as DAddress2,
					ad.Address3 as DAddress3,
					ad.City as DCity, 
					ad.State as DState, 
					ad.PostalCode as DPostalCode, 
					ad.Country as DCountry, 
					ad.AddressName as DAddressName,
					adb.Address1 as DBAddress1,
					adb.Address2 as DBAddress2,
					adb.Address3 as DBAddress3,
					adb.City as DBCity, 
					adb.State as DBState, 
					adb.PostalCode as DBPostalCode, 
					adb.Country as DBCountry, 
					adb.AddressName as DBAddressName,
					gl.AccountNumber as DefaultExpenseAccountNumber,
					gl.AccountName as DefaultExpenseAccountName,
					gl2.AccountNumber as DefaultSalesAccountNumber,
					gl2.AccountName as DefaultSalesAccountName,
					gl3.AccountNumber as DefaultAPAccountNumber,
					gl3.AccountName as DefaultAPAccountName,
					it.TemplateName,
					pc.CompanyName as ParentCompanyName,
					co.UserName as ContactOwnerName,
					pcu.FirstName + ' ' + pcu.LastName as PrimaryContactName,
					pcu.UserRole,
					c.CompanyKey as ContactCompanyKey,  -- name compatibility with the activities history
					am.FirstName + ' ' + am.LastName as AccountManagerName,
					apc.CustomerID as AlternatePayerClientID,
					apc.CompanyName as AlternatePayerCompanyName,
					CASE WHEN ISNULL(af.ActionKey, 0) > 0 THEN 1 ELSE 0 END AS IsFavorite,
				    Case @CanNotViewOthersContacts
						when 1 then (Select COUNT(*) FROM tUser (NOLOCK) WHERE CompanyKey = c.CompanyKey  AND OwnerKey = @UserKey) 
						else  (Select COUNT(*) FROM tUser (NOLOCK) WHERE CompanyKey = c.CompanyKey )
					END as ContactCount,
					ah.DateAdded AS RecentSort
			  FROM tCompany c (nolock)
				left outer join tGLAccount gl (nolock) on c.DefaultExpenseAccountKey = gl.GLAccountKey
				left outer join tGLAccount gl2 (nolock) on c.DefaultSalesAccountKey = gl2.GLAccountKey
				left outer join tGLAccount gl3 (nolock) on c.DefaultAPAccountKey = gl3.GLAccountKey
				left outer join tInvoiceTemplate it (nolock) on c.InvoiceTemplateKey = it.InvoiceTemplateKey
				left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
				left outer join tAddress adb (nolock) on c.BillingAddressKey = adb.AddressKey
				left outer join tCompany pc (nolock) on c.ParentCompanyKey = pc.CompanyKey
				left outer join vUserName co (nolock) on c.ContactOwnerKey = co.UserKey
				left outer join tUser pcu (nolock) on c.PrimaryContact = pcu.UserKey 
				left outer join tUser am (nolock) on c.AccountManagerKey = am.UserKey
				left outer join tCompany apc (nolock) on c.AlternatePayerKey = apc.CompanyKey
				left outer join tAppFavorite af (nolock) on c.CompanyKey = af.ActionKey AND af.ActionID = 'cm.companies' and af.UserKey = @UserKey
				inner join (select top 10 ActionKey, DateAdded
							from tAppHistory (nolock) 
							where  tAppHistory.ActionID = 'cm.companies.edit' 
							and tAppHistory.UserKey = @UserKey 
							order by tAppHistory.DateAdded DESC
							) ah ON c.CompanyKey = ah.ActionKey
			  WHERE
			  c.OwnerCompanyKey = @CompanyKey
			 AND (
					@UseCompanyFolders = 0
					OR 
					c.CMFolderKey IS NULL
					OR
					c.CMFolderKey IN (SELECT CMFolderKey FROM #folders)
				)
			AND (
					@CanNotViewOthersCompanies = 0
					OR
					c.ContactOwnerKey IS NULL
					OR
					c.ContactOwnerKey = @UserKey
			    )
			ORDER BY RecentSort DESC
			   RETURN 1
	END
-------------- Search Select----------------------------------------------------------------------------
	SELECT
					c.*,
					ad.Address1 as Address1,		-- For backward compatibility
					ad.Address2 as Address2,		-- For backward compatibility
					ad.Address3 as Address3,		-- For backward compatibility
					ad.City as City, 				-- For backward compatibility
					ad.State as State, 				-- For backward compatibility
					ad.PostalCode as PostalCode, 	-- For backward compatibility
					ad.Country as Country,			-- For backward compatibility
					
					ad.Address1 as DAddress1,
					ad.Address2 as DAddress2,
					ad.Address3 as DAddress3,
					ad.City as DCity, 
					ad.State as DState, 
					ad.PostalCode as DPostalCode, 
					ad.Country as DCountry, 
					ad.AddressName as DAddressName,
					adb.Address1 as DBAddress1,
					adb.Address2 as DBAddress2,
					adb.Address3 as DBAddress3,
					adb.City as DBCity, 
					adb.State as DBState, 
					adb.PostalCode as DBPostalCode, 
					adb.Country as DBCountry, 
					adb.AddressName as DBAddressName,
					gl.AccountNumber as DefaultExpenseAccountNumber,
					gl.AccountName as DefaultExpenseAccountName,
					gl2.AccountNumber as DefaultSalesAccountNumber,
					gl2.AccountName as DefaultSalesAccountName,
					gl3.AccountNumber as DefaultAPAccountNumber,
					gl3.AccountName as DefaultAPAccountName,
					it.TemplateName,
					pc.CompanyName as ParentCompanyName,
					co.UserName as ContactOwnerName,
					pcu.FirstName + ' ' + pcu.LastName as PrimaryContactName,
					pcu.UserRole,
					c.CompanyKey as ContactCompanyKey,  -- name compatibility with the activities history
					am.FirstName + ' ' + am.LastName as AccountManagerName,
					apc.CustomerID as AlternatePayerClientID,
					apc.CompanyName as AlternatePayerCompanyName,
					CASE WHEN ISNULL(af.ActionKey, 0) > 0 THEN 1 ELSE 0 END AS IsFavorite,
					Case @CanNotViewOthersContacts
						when 1 then (Select COUNT(*) FROM tUser (NOLOCK) WHERE CompanyKey = c.CompanyKey  AND OwnerKey = @UserKey) 
						else  (Select COUNT(*) FROM tUser (NOLOCK) WHERE CompanyKey = c.CompanyKey )
					END as ContactCount
			  FROM tCompany c (nolock)
				left outer join tGLAccount gl (nolock) on c.DefaultExpenseAccountKey = gl.GLAccountKey
				left outer join tGLAccount gl2 (nolock) on c.DefaultSalesAccountKey = gl2.GLAccountKey
				left outer join tGLAccount gl3 (nolock) on c.DefaultAPAccountKey = gl3.GLAccountKey
				left outer join tInvoiceTemplate it (nolock) on c.InvoiceTemplateKey = it.InvoiceTemplateKey
				left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
				left outer join tAddress adb (nolock) on c.BillingAddressKey = adb.AddressKey
				left outer join tCompany pc (nolock) on c.ParentCompanyKey = pc.CompanyKey
				left outer join vUserName co (nolock) on c.ContactOwnerKey = co.UserKey
				left outer join tUser pcu (nolock) on c.PrimaryContact = pcu.UserKey 
				left outer join tUser am (nolock) on c.AccountManagerKey = am.UserKey
				left outer join tCompany apc (nolock) on c.AlternatePayerKey = apc.CompanyKey
				left outer join tAppFavorite af (nolock) on c.CompanyKey = af.ActionKey AND af.ActionID = 'cm.companies' and af.UserKey = @UserKey
			  WHERE
			   c.OwnerCompanyKey = @CompanyKey
			   AND (
						LOWER(ISNULL(am.FirstName, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
						LOWER(ISNULL(am.LastName, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
						LOWER(ISNULL(pcu.FirstName, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
						LOWER(ISNULL(pcu.LastName, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
						LOWER(ISNULL(c.CompanyName, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
						LOWER(ISNULL(pc.CompanyName, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
						LOWER(ISNULL(c.VendorID, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
						LOWER(ISNULL(c.CustomerID, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%'
					)
			   AND	(
						@UseCompanyFolders = 0
						OR 
						c.CMFolderKey IS NULL
						OR
						c.CMFolderKey IN (SELECT CMFolderKey FROM #folders)
					)
				AND (
						@CanNotViewOthersCompanies = 0
						OR
						c.ContactOwnerKey IS NULL
						OR
						c.ContactOwnerKey = @UserKey
					)
				AND (
						@GLCompanyRestrict = 0
						OR
						c.CompanyKey in (
							SELECT DISTINCT(EntityKey) from tGLCompanyAccess glca (nolock) where  glca.Entity = 'tCompany' and glca.GLCompanyKey in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey)
						)

					)
				ORDER BY c.CompanyName
				
	 RETURN 1
GO
