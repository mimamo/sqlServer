USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignGetDetail]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignGetDetail]
	@CampaignKey int

AS --Encrypt

/*
|| When      Who Rel      What
|| 12/14/09  CRG 10.5.1.4 Added AEName
|| 1/12/10   CRG 10.5.1.6 Added call to sptWorkTypeCustomGetCampaignList
|| 1/14/10   CRG 10.5.1.7 Added @CompanyKey on call to sptWorkTypeCustomGetCampaignList
|| 3/5/10    CRG 10.5.1.9 Added LayoutName
|| 4/6/10    GHL 10.5.2.1 Added ContactName
|| 5/13/10   CRG 10.5.2.2 (80503) Now retruning EditBillBy to tell the UI whether the BillBy can be changed.
||                        EditBillBy is 0 if any projects are linked to this campaign where their ClientKey does not match the campaign's ClientKey.
|| 8/9/10    GHL 10.5.3.3 (86008) Added list of projects for the campaign
|| 8/17/10   CRG 10.5.3.3 Modified to use sptCampaignGetProjectList which already existed, so that the project data coming back is consistent. 
|| 8/19/10   CRG 10.5.3.3 Now calling sptCampaignSegmentGetList so that all segment lists returned are the same.
||                        Also consolidated the get for ClientKey and CompanyKey into one query
|| 11/2/10   CRG 10.5.3.7 (92555) Added a check to see if estimates exists to determine whether the "Use Multiple Segments" checkbox is enabled.
||                        We have to check here because the campaign's estimates aren't loaded on the screen until the user goes to the "Estimates" tab.
|| 11/17/10  GHL 10.538   Added project template list for drag and drop on segment grid 
|| 09/14/11  GWG 10.548   Expanded logic to edit bill by to include companies in the parent child chain
|| 09/15/11  GWG 10.548   Fixed the expanded logic. needed an AND instead of an OR
|| 04/25/12  GHL 10.555   Added GL company info
*/

	DECLARE	@EditBillBy tinyint,
			@CompanyKey int,
			@ClientKey int,
			@EstimatesExist tinyint
	
	SELECT	@EditBillBy = 1, --Default to allow BillBy edit
			@EstimatesExist = 0 --Default to No
	
	SELECT	@ClientKey = ClientKey,
			@CompanyKey = CompanyKey
	FROM	tCampaign (nolock)
	WHERE	CampaignKey = @CampaignKey
	
	--If there are projects tied to this campaign where their ClientKey does not match the campaign's ClientKey or the parent company, then the BillBy cannot be edited
	IF EXISTS
			(SELECT	NULL
			FROM	tProject p (nolock)
			INNER JOIN tCompany c (nolock) ON c.CompanyKey = p.ClientKey
			WHERE	CampaignKey = @CampaignKey
			AND		(c.CompanyKey <> @ClientKey AND c.ParentCompanyKey <> @ClientKey))
		SELECT @EditBillBy = 0

	IF EXISTS
			(SELECT	NULL
			FROM	tEstimate (nolock)
			WHERE	CampaignKey = @CampaignKey)
		SELECT @EstimatesExist = 1

	SELECT	ca.*
			,glc.GLCompanyID
			,glc.GLCompanyName
			,c.CustomerID
			,c.CompanyName
			,u.UserName AS AEName
			,l.LayoutName
			,cont.UserName as ContactName
			,@EditBillBy AS EditBillBy
			,@EstimatesExist AS EstimatesExist
	FROM	tCampaign ca (nolock)
	INNER JOIN tCompany c (nolock) ON c.CompanyKey = ca.ClientKey
	LEFT JOIN tLayout l (nolock) ON ca.LayoutKey = l.LayoutKey
	LEFT JOIN vUserName u (nolock) ON ca.AEKey = u.UserKey
	LEFT JOIN vUserName cont (nolock) ON ca.ContactKey = cont.UserKey
	LEFT JOIN tGLCompany glc (nolock) ON ca.GLCompanyKey = glc.GLCompanyKey
	WHERE	CampaignKey = @CampaignKey
			
	EXEC sptCampaignSegmentGetList @CampaignKey
	
	EXEC sptWorkTypeCustomGetCampaignList @CompanyKey, @CampaignKey

	EXEC sptCampaignGetProjectList @CampaignKey, 0 --Include Tasks

	select ProjectKey, ProjectNumber, ProjectName, isnull(ProjectNumber + ' - ', '') + isnull(ProjectName, '') as ProjectFullName 
	from tProject (nolock) where CompanyKey = @CompanyKey 
	and Template = 1
	order by isnull(ProjectNumber + ' - ', '') + isnull(ProjectName, '')
GO
