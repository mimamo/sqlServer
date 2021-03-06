USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadGetAllDetails]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadGetAllDetails]
	(
	@CompanyKey int, --needed by sptWorkTypeCustomGetLeadList (can't get it from tLead because @LeadKey might be 0)
	@LeadKey int
	)
AS --Encrypt

  /*
  || When     Who Rel      What
  || 08/15/08 GHL 10.5	   Creation for multi details page
  || 01/13/09 GHL 10.5	   Removed history tables, they are now called on demand
  || 02/9/09  GWG 10.5     Changed the entity on the attachments
  || 3/9/10   CRG 10.5.2.0 Added queries for CampaignSegment and BillingItems
  || 3/10/10  CRG 10.5.2.0 Added TemplateProjectNumber, TemplateProjectName, LayoutName
  || 3/10/10  CRG 10.5.2.0 Added @CompanyKey
  || 3/15/10  CRG 10.5.2.0 Added LinkCampaignKey, LinkProjectKey, BillableClient, CustomerID
  || 04/01/10 MFT 10.5.2.1 Removed LinkCampaignKey & LinkProjectKey;Added ConvertEntity & ConvertEntityKey
  || 04/05/10 MFT 10.5.2.1 ISNULL on ProjectTypeKey
  || 04/21/11 QMD 10.5.4.3 Added AccountManagerName, LeadStatusName, LeadStageName
  || 05/15/11 GWG 10.5.4.4 Added project type and folder for mobile
  || 06/21/12 GHL 10.5.5.7 Added GL Company info 
  || 10/02/13 MAS 10.5.7.3 (179034) Added ClientDivisionKey & ClientProductKey
  || 08/13/14 QMD 10.5.8.3 Added cell, phone1 and email to get
  */
  
	SET NOCOUNT ON

	-- Will need 3 lists tLeadStatus, tLeadStage, tLeadOutcome
		
	SELECT l.* 
		   ,la.ActivityDate as LastActivityDate
		   ,la.Subject as LastActivitySubject
		   ,na.ActivityDate as NextActivityDate
		   ,na.Subject as NextActivitySubject
		   ,con.FirstName + ' ' + con.LastName as ContactName
		   ,c.CompanyName
		   ,cbu.FirstName + ' ' + cbu.LastName as CreatedByName
		   ,mbu.FirstName + ' ' + mbu.LastName as ModifiedByName
		   ,p.ProjectNumber AS TemplateProjectNumber
		   ,p.ProjectName AS TemplateProjectName
		   ,lay.LayoutName
		   ,c.BillableClient
		   ,c.CustomerID
		   ,ConvertEntity
		   ,ConvertEntityKey
		   ,case when ConvertEntity = 'tCampaign' then
				(Select CampaignID + ' ' + CampaignName from tCampaign (nolock) Where CampaignKey = ConvertEntityKey)
				when ConvertEntity = 'tProject' then
				(Select ProjectNumber + ' ' + ProjectName from tProject (nolock) Where ProjectKey = ConvertEntityKey) end as ConvertEntityName
		   ,ISNULL(am.FirstName,'') + ' ' + ISNULL(am.LastName,'') as AccountManagerName
		   ,ls.LeadStatusName
		   ,lsg.LeadStageName
		   ,pt.ProjectTypeName
		   ,f.FolderName
		   ,o.Outcome
		   ,glc.GLCompanyID
		   ,glc.GLCompanyName
		   ,cd.DivisionName
		   ,cp.ProductName
		   ,con.Cell
		   ,con.Phone1
		   ,con.Email
	FROM   tLead l (NOLOCK)
		LEFT OUTER JOIN tActivity la (NOLOCK) ON l.LastActivityKey = la.ActivityKey
		LEFT OUTER JOIN tActivity na (NOLOCK) ON l.NextActivityKey = na.ActivityKey
		LEFT OUTER JOIN tUser cbu (NOLOCK) ON l.AddedByKey = cbu.UserKey
		LEFT OUTER JOIN tUser mbu (NOLOCK) ON l.UpdatedByKey = mbu.UserKey	
		left outer join tCompany c (nolock) on l.ContactCompanyKey = c.CompanyKey	
		left outer join tUser con (nolock) on l.ContactKey = con.UserKey
		LEFT OUTER JOIN tProject p (nolock) ON l.TemplateProjectKey = p.ProjectKey
		LEFT OUTER JOIN tLayout lay (nolock) ON l.LayoutKey = lay.LayoutKey
		LEFT OUTER JOIN tUser am (nolock) on l.AccountManagerKey = am.UserKey
		LEFT OUTER JOIN tLeadStatus ls (nolock) on l.LeadStatusKey = ls.LeadStatusKey
		LEFT OUTER JOIN tLeadStage lsg (nolock) on l.LeadStageKey = lsg.LeadStageKey
		LEFT OUTER JOIN tProjectType pt (nolock) on l.ProjectTypeKey = pt.ProjectTypeKey
		LEFT OUTER JOIN tCMFolder f (nolock) on l.CMFolderKey = f.CMFolderKey
		LEFT OUTER JOIN tLeadOutcome o (nolock) on l.LeadOutcomeKey = o.LeadOutcomeKey
		LEFT OUTER JOIN tGLCompany glc (nolock) on l.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tClientDivision cd (nolock) on l.ClientDivisionKey = cd.ClientDivisionKey
		LEFT OUTER JOIN tClientProduct cp (nolock) on l.ClientProductKey = cp.ClientProductKey

	WHERE  l.LeadKey = @LeadKey
		
	-- last activity
	Select a.*, u.FirstName + ' ' + u.LastName as AssignedUserName
		from tActivity a (nolock)
		inner join tLead cont (nolock) on cont.LastActivityKey = a.ActivityKey
		left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
	Where 
		cont.LeadKey = @LeadKey

	-- next activity
	Select a.*, u.FirstName + ' ' + u.LastName as AssignedUserName
		from tActivity a (nolock)
		inner join tLead cont (nolock) on cont.NextActivityKey = a.ActivityKey
		left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
	Where 
		cont.LeadKey = @LeadKey
	

   SELECT lu.*
		  ,u.FirstName + ' ' + u.LastName as UserName
   FROM   tLeadUser lu (NOLOCK)
		INNER JOIN tUser u (NOLOCK) ON lu.UserKey = u.UserKey
   WHERE  lu.LeadKey = @LeadKey
   
      
   SELECT SpecSheetKey, Subject, Description
   FROM tSpecSheet (nolock)
   WHERE Entity = 'Lead' and EntityKey = @LeadKey
   Order By Subject
   
   -- Attachments
	Select *
	From tAttachment (nolock)
	Where
	 AssociatedEntity = 'Lead' AND EntityKey = @LeadKey
	Order By FileName
	
	SELECT
		CampaignSegmentKey,
		CampaignKey,
		SegmentName,
		SegmentDescription,
		DisplayOrder,
		PlanStart,
		PlanComplete,
		LeadKey,
		ISNULL(ProjectTypeKey, 0) AS ProjectTypeKey
	FROM	tCampaignSegment (nolock) 
	WHERE	LeadKey = @LeadKey
	ORDER BY DisplayOrder

	EXEC sptWorkTypeCustomGetLeadList @CompanyKey, @LeadKey
	
	-- Divisions
	Select cd.* 
	from tClientDivision cd(nolock)
	Join tLead l (nolock) on l.ContactCompanyKey = cd.ClientKey
	Where l.LeadKey =  @LeadKey
	
	-- Products
	Select cp.* 
	from tClientProduct cp(nolock)
	Join tClientDivision cd(nolock) on cd.ClientDivisionKey = cp.ClientDivisionKey
	Join tLead l (nolock) on l.ClientDivisionKey = cp.ClientDivisionKey
	Where l.LeadKey =  @LeadKey
		
	RETURN 1
GO
