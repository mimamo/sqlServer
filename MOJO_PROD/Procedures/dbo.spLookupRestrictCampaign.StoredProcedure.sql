USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLookupRestrictCampaign]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLookupRestrictCampaign]

	(
		@CompanyKey int,
		@SearchOption smallint, -- 1 By ID else By name
		@ClientID varchar(50),
		@SearchPhrase varchar(200),
		@GLCompanyKey int,
		@UserKey int,
		@SearchMode varchar(50),
		@ClientKey int = NULL
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 05/13/08  GHL 8.510  (26281) Added back ClientID to where clauses
||                      There is no a textbox on the lookup for the ClientID
|| 07/23/12  GHL 10.558 Added UserKey/SearchMode for GL company restrictions
|| 10/14/13  KMC 10.573 (192746) Added search by client key
*/


	if @SearchOption = 1
	begin
		if @SearchMode = 'transactions'

		Select tCampaign.*, CustomerID
		From tCampaign (nolock)
			inner join tCompany (nolock) on tCampaign.ClientKey = tCompany.CompanyKey
		Where
			tCampaign.CompanyKey = @CompanyKey and
			tCampaign.Active = 1 and
			CampaignID like @SearchPhrase + '%' and
			(@ClientID is null Or tCompany.CustomerID = @ClientID or tCampaign.ClientKey = @ClientKey) and
			isnull(tCampaign.GLCompanyKey, 0) = @GLCompanyKey

		Order By CampaignID

		if @SearchMode <> 'transactions' -- for reports

		Select tCampaign.*, CustomerID
		From tCampaign (nolock)
			inner join tCompany (nolock) on tCampaign.ClientKey = tCompany.CompanyKey
		Where
			tCampaign.CompanyKey = @CompanyKey and
			tCampaign.Active = 1 and
			CampaignID like @SearchPhrase + '%' and
			(@ClientID is null Or tCompany.CustomerID = @ClientID or tCampaign.ClientKey = @ClientKey) and
			(isnull(tCampaign.GLCompanyKey, 0) in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey))

 		Order By CampaignID

	end

	if @SearchOption <> 1
	begin
		if @SearchMode = 'transactions'

		Select tCampaign.* , CustomerID
		From tCampaign (nolock)
			inner join tCompany (nolock) on tCampaign.ClientKey = tCompany.CompanyKey
		Where
			tCampaign.CompanyKey = @CompanyKey and
			tCampaign.Active = 1 and
			CampaignName like @SearchPhrase + '%' and
			(@ClientID is null Or tCompany.CustomerID = @ClientID or tCampaign.ClientKey = @ClientKey)  and
			isnull(tCampaign.GLCompanyKey, 0) = @GLCompanyKey

		Order By CampaignName

		if @SearchMode <> 'transactions' -- for reports

		Select tCampaign.*, CustomerID
		From tCampaign (nolock)
			inner join tCompany (nolock) on tCampaign.ClientKey = tCompany.CompanyKey
		Where
			tCampaign.CompanyKey = @CompanyKey and
			tCampaign.Active = 1 and
			CampaignName like @SearchPhrase + '%' and
			(@ClientID is null Or tCompany.CustomerID = @ClientID or tCampaign.ClientKey = @ClientKey) and
			(isnull(tCampaign.GLCompanyKey, 0) in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey))

 		Order By CampaignID

	end
GO
