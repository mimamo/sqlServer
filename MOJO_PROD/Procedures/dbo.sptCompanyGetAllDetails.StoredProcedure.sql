USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetAllDetails]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyGetAllDetails]
	(
	 @UserKey int
	,@CompanyKey int
	,@AllDetails int = 1
	)
AS --Encrypt

  /*
  || When     Who Rel      What
  || 07/03/08 GHL 10.5	Creation for multi details page
  || 12/30/08 GHL 10.5  Added ContactName for CMContactLookup
  || 5/21/09  CRG 10.5  Added GL Account Number and Name for use by the GL Account lookup on the CompanyEdit screen
  || 05/22/09 GHL 10.5  Added AllDetails to get basic info 
  || 07/09/09 MAS 10.5  (56191)Added ActiveStatus so in Flex we could sort based on the user's status
  || 7/21/09  CRG 10.5.0.5 (57838) Fixed the retainer query
  || 9/3/09   GWG 10.5.09 Added a restriction so nothing for 0 CompanyKey gets pulled
  || 9/11/09  GWG 10.5.1.0 Missed the restrict on addresses also
  || 1/5/10   GWG 10.5.1.6 Added Layout to the get
  || 9/30/10  CRG 10.5.3.6 Added AccountManager
  || 12/14/10 RLB 10.5.3.9 (74138) Added SalesPersonName for lookup
  || 02/27/12 GHL 10.5.5.3 (135372) Return active retainers only
  || 04/25/12 GHL 10.5.5.5 Added GLCompany info to show on lookups
  || 06/12/12 GHL 10.5.5.7 Added tGLCompanyAccess records
  || 06/14/12 RLB 10.5.5.7 (146475) Wrapped First and Last Name in an ISNULL in case there is none
  || 09/10/12 MFT 10.5.5.9 Added ParentDivisionName, AlternatePayerClientID/AlternatePayerCompanyName to support lookups
  || 01/16/13 WDF 10.5.6.4 (160367) Added GL Company restriction to Contacts
  || 05/03/13 MFT 10.5.6.7 Added BillingManager field
  || 09/12/13 GHL 10.5.7.2 Get owner company key from user rather than company because in add mode company key = 0
  || 01/13/14 RLB 10.5.7.6 (201587) Added OfficeName, OfficeID and Team Name because the key is defaulted in and the rest is needed
  || 07/23/14 GHL 10.5.8.2 (222235) Added info for BillingEmailContact field. This user is the person we must email
  ||                       client invoices and client statements to 
  || 08/01/14 RLB 10.5.8.3 Added for Plat
  || 08/05/14 RLB 10.5.8.3 Added App Fav data
  || 09/08/14 RLB 10.5.8.4 Added check to view other Contacts and remove other counts they are not needed with changes
  || 09/12/14 RLB 10.5.8.5 Added GLCompanyName to the data pulled for gl restrict access
  || 10/06/14 CRG 10.5.8.5 Added CCAccountNumber and CCAccountName
  */
  
	SET NOCOUNT ON

	declare @DefaultRetainerKey int
		,@OwnerCompanyKey int
		,@RestrictToGLCompany int
		,@Administrator tinyint
		,@CanNotViewOthersCompanies tinyint
		,@SecurityGroupKey int

	-- get owner company key from user rather than company because in add mode company key = 0
	select @OwnerCompanyKey = isnull(OwnerCompanyKey,CompanyKey),
		   @SecurityGroupKey = SecurityGroupKey,
		   @Administrator = Administrator
	  from tUser (nolock)
	 where UserKey = @UserKey   

	select @DefaultRetainerKey = DefaultRetainerKey
	from tCompany (nolock) where CompanyKey = @CompanyKey

	select @RestrictToGLCompany = isnull(RestrictToGLCompany, 0)
	from tPreference (nolock) 
	where CompanyKey = @OwnerCompanyKey

	SELECT @CanNotViewOthersCompanies = 1

	IF @Administrator = 1
		SELECT @CanNotViewOthersCompanies = 0
	ELSE
	if exists (select 1 from tRight r (nolock)
			inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
			where ra.EntityType = 'Security Group'
			and   ra.EntityKey = @SecurityGroupKey
			and   r.RightID = 'viewOtherCompanies')
		select @CanNotViewOthersCompanies = 0
 

	SELECT c.* 
		,la.DateCompleted as LastActivityDate
		,la.Subject as LastActivitySubject
		,lau.FirstName + ' ' + lau.LastName as LastActivityAssignedTo
		,na.ActivityDate as NextActivityDate
		,na.Subject as NextActivitySubject
		,nau.FirstName + ' ' + nau.LastName as NextActivityAssignedTo
		,cbu.FirstName + ' ' + cbu.LastName as CreatedByName
		,mbu.FirstName + ' ' + mbu.LastName as ModifiedByName
		,sp.FirstName + ' ' + sp.LastName as SalesPersonName
		,cnt.FirstName + ' ' + cnt.LastName as ContactOwnerName
		,pc.CompanyName as ParentCompanyName
		,con.FirstName + ' ' + con.LastName as ContactName
		,glAP.AccountNumber AS DefaultAPAccountNumber
		,glAP.AccountName AS DefaultAPAccountName
		,glExp.AccountNumber AS DefaultExpenseAccountNumber
		,glExp.AccountName AS DefaultExpenseAccountName
		,glSales.AccountNumber AS DefaultSalesAccountNumber
		,glSales.AccountName AS DefaultSalesAccountName
		,l.LayoutName
		,am.UserName AS AccountManagerName
		,glc.GLCompanyID
		,glc.GLCompanyName
		,cpo.OfficeID
		,cpo.OfficeName
		,ctm.TeamName
		,cd.DivisionName AS ParentCompanyDivisionName
		,ap.CustomerID AS AlternatePayerClientID
		,ap.CompanyName AS AlternatePayerCompanyName
		,bm.UserName AS BillingManagerName
		,beu.UserName AS BillingEmailContactName
		,beu.Email AS BillingEmailContactEmail
		,ct.CompanyTypeName
		,cmf.FolderName
		,CASE WHEN ISNULL(af.AppFavoriteKey, 0) > 0 THEN 1 ELSE 0 END AS IsFavorite
		,Case @CanNotViewOthersCompanies
			when 1 then (Select COUNT(*) FROM tUser (NOLOCK) WHERE CompanyKey = c.CompanyKey  AND OwnerKey = @UserKey) 
			else  (Select COUNT(*) FROM tUser (NOLOCK) WHERE CompanyKey = c.CompanyKey )
		END as ContactCount
		,cca.AccountNumber AS CCAccountNumber
		,cca.AccountName AS CCAccountName
	FROM   tCompany c (NOLOCK)
		LEFT OUTER JOIN tActivity la (NOLOCK) ON c.LastActivityKey = la.ActivityKey
		LEFT OUTER JOIN tUser lau (NOLOCK) ON la.AssignedUserKey = lau.UserKey
		LEFT OUTER JOIN tActivity na (NOLOCK) ON c.NextActivityKey = na.ActivityKey
		LEFT OUTER JOIN tUser nau (NOLOCK) ON na.AssignedUserKey = nau.UserKey
		LEFT OUTER JOIN tUser cbu (NOLOCK) ON c.CreatedBy = cbu.UserKey
		LEFT OUTER JOIN tUser mbu (NOLOCK) ON c.ModifiedBy = mbu.UserKey
		left outer join tUser con (nolock) on c.PrimaryContact = con.UserKey
		LEFT OUTER JOIN tUser sp (NOLOCK) ON c.SalesPersonKey = sp.UserKey
		LEFT OUTER JOIN tUser cnt (NOLOCK) ON c. ContactOwnerKey = cnt.UserKey
		LEFT OUTER JOIN vUserName am (nolock) ON c.AccountManagerKey = am.UserKey
		LEFT OUTER JOIN tCompany pc (NOLOCK) ON c.ParentCompanyKey = pc.CompanyKey
		LEFT OUTER JOIN tGLAccount glAP (NOLOCK) ON c.DefaultAPAccountKey = glAP.GLAccountKey
		LEFT OUTER JOIN tGLAccount glExp (NOLOCK) ON c.DefaultExpenseAccountKey = glExp.GLAccountKey
		LEFT OUTER JOIN tGLAccount glSales (NOLOCK) ON c.DefaultSalesAccountKey = glSales.GLAccountKey
		LEFT OUTER JOIN tLayout l (NOLOCK) on c.LayoutKey = l.LayoutKey
		LEFT OUTER JOIN tGLCompany glc (NOLOCK) on c.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tOffice cpo (NOLOCK) on c. OfficeKey = cpo.OfficeKey
		LEFT OUTER JOIN tTeam ctm (NOLOCK) on c.DefaultTeamKey = ctm.TeamKey
		LEFT OUTER JOIN tClientDivision cd (nolock) ON c.ParentCompanyDivisionKey = cd.ClientDivisionKey
		LEFT OUTER JOIN tCompany ap (nolock) ON c.AlternatePayerKey = ap.CompanyKey
		LEFT OUTER JOIN vUserName bm (nolock) ON c.BillingManagerKey = bm.UserKey
		LEFT OUTER JOIN vUserName beu (nolock) ON c.BillingEmailContact = beu.UserKey
		LEFT OUTER JOIN tCompanyType ct (nolock) on c.CompanyTypeKey = ct.CompanyTypeKey
		LEFT OUTER JOIN tCMFolder cmf (nolock) on c.CMFolderKey = cmf.CMFolderKey
		LEFT OUTER JOIN tAppFavorite af (nolock) on c.CompanyKey = af.ActionKey AND af.ActionID = 'cm.companies' and af.UserKey = @UserKey
		LEFT OUTER JOIN tGLAccount cca (nolock) ON c.CCAccountKey = cca.GLAccountKey

	WHERE  c.CompanyKey = @CompanyKey
	
	-- no need to stress the database if all details are not required
	IF @AllDetails = 0
		RETURN 1
		
	SELECT *
	FROM   tAddress (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    Entity IS NULL and CompanyKey > 0
	ORDER BY AddressName


	declare @GLAccess TABLE (UserKey int)
 
	If (@Administrator = 0 and @RestrictToGLCompany = 1)
	BEGIN
		Insert into @GLAccess
		SELECT glca.EntityKey  
		  FROM tUserGLCompanyAccess uglca (nolock) INNER JOIN tGLCompanyAccess glca (nolock) ON uglca.GLCompanyKey = glca.GLCompanyKey AND 
																							    glca.Entity        = 'tUser'  
		 WHERE uglca.UserKey = @UserKey
		   AND glca.CompanyKey = @OwnerCompanyKey
	END
   	
	SELECT ISNULL(FirstName + ' ', '') + ISNULL(LastName, '') AS FormattedName,
		   Case ISNULL(Active,0)
			When 1 then 'Active'
			else 'In-Active' end as [ActiveStatus],
		   Case @Administrator
		    When 0 then
				   Case @RestrictToGLCompany
					When 1 then
						   Case 
							  When UserKey IN ( SELECT UserKey from @GLAccess ) THEN 1
							  else 0
						   end 
					else 1 end
			else 1 end as [CanEdit], *
	FROM   tUser (NOLOCK)
	WHERE  CompanyKey = @CompanyKey and CompanyKey > 0
	ORDER BY FirstName + ' ' + LastName
	
	Select RetainerKey, Title, Active
	From tRetainer (nolock) 
	Where ClientKey = @CompanyKey and ClientKey > 0
	and  (Active = 1 Or RetainerKey = @DefaultRetainerKey)
	Order By Title
	
	Select * from tClientDivision (nolock)
	where ClientKey = @CompanyKey and ClientKey > 0
	Order By DivisionName
	
	Select cp.*, cd.DivisionName 
	from tClientProduct cp (nolock)
		Left outer join tClientDivision cd (nolock) on cp.ClientDivisionKey = cd.ClientDivisionKey
	where cp.ClientKey = @CompanyKey and cp.ClientKey > 0
	Order By DivisionName, ProductName
	
   SELECT *
   FROM   tLevelHistory lh (NOLOCK)
   WHERE  EntityKey = @CompanyKey and Entity = 'tCompany' and EntityKey > 0
   Order By LevelDate DESC
	
	SELECT glca.*, glc.GLCompanyName
	FROM   tGLCompanyAccess glca (nolock)
		inner join tGLCompany glc (nolock) on glca.GLCompanyKey = glc.GLCompanyKey
	WHERE  glca.CompanyKey = @OwnerCompanyKey
	AND    glca.Entity = 'tCompany'
	AND    glca.EntityKey = @CompanyKey
	order by glc.GLCompanyName

RETURN 1
GO
