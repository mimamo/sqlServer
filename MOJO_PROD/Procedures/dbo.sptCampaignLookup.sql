USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignLookup]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignLookup]

	(
		@CompanyKey int,
		@SearchOption smallint,
		@ClientID varchar(50),
		@SearchPhrase varchar(200),
		@ClientKey int = NULL
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 05/13/08  GHL 8.510  (26281) Added back ClientID to where clauses
||                      There is no a textbox on the lookup for the ClientID
|| 10/14/13  KMC 10.573 (192746) Added search by client key
*/

if @ClientID is null
BEGIN

	if @ClientKey is null
	BEGIN

		if @SearchOption = 1
			Select tCampaign.*, CustomerID
			From tCampaign (nolock)
				inner join tCompany (nolock) on tCampaign.ClientKey = tCompany.CompanyKey
			Where
				tCampaign.CompanyKey = @CompanyKey and
				tCampaign.Active = 1 and
				CampaignID like @SearchPhrase + '%'
			Order By CampaignID
		else
			Select tCampaign.* , CustomerID
			From tCampaign (nolock)
				inner join tCompany (nolock) on tCampaign.ClientKey = tCompany.CompanyKey
			Where
				tCampaign.CompanyKey = @CompanyKey and
				tCampaign.Active = 1 and
				CampaignName like @SearchPhrase + '%'
			Order By CampaignName
	END
	ELSE
	BEGIN

		if @SearchOption = 1
			Select tCampaign.*, CustomerID 
			From tCampaign (nolock)
				inner join tCompany (nolock) on tCampaign.ClientKey = tCompany.CompanyKey
			Where
				tCampaign.ClientKey = @ClientKey and
				tCampaign.CompanyKey = @CompanyKey and
				tCampaign.Active = 1 and
				CampaignID like @SearchPhrase + '%'
			Order By CampaignID
		else
			Select tCampaign.*, CustomerID 
			From tCampaign (nolock)
				inner join tCompany (nolock) on tCampaign.ClientKey = tCompany.CompanyKey
			Where
				tCampaign.ClientKey = @ClientKey and
				tCampaign.CompanyKey = @CompanyKey and
				tCampaign.Active = 1 and
				CampaignName like @SearchPhrase + '%'
			Order By CampaignName
	END
END
ELSE
BEGIN

	if @SearchOption = 1
		Select tCampaign.*, CustomerID 
		From tCampaign (nolock)
			inner join tCompany (nolock) on tCampaign.ClientKey = tCompany.CompanyKey
		Where
			tCompany.CustomerID = @ClientID and
			tCampaign.CompanyKey = @CompanyKey and
			tCampaign.Active = 1 and
			CampaignID like @SearchPhrase + '%'
		Order By CampaignID
	else
		Select tCampaign.*, CustomerID 
		From tCampaign (nolock)
			inner join tCompany (nolock) on tCampaign.ClientKey = tCompany.CompanyKey
		Where
			tCompany.CustomerID = @ClientID and
			tCampaign.CompanyKey = @CompanyKey and
			tCampaign.Active = 1 and
			CampaignName like @SearchPhrase + '%'
		Order By CampaignName

END
GO
