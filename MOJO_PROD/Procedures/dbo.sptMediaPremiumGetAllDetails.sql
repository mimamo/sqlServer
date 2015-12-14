USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaPremiumGetAllDetails]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaPremiumGetAllDetails]
	@CompanyKey int,
	@POKind smallint
AS --Encrypt

/*
|| When     Who Rel     What
|| 03/11/14 GHL 10.578  Added user names
*/

Select * from tMediaPremium mp (nolock) 
Where CompanyKey = @CompanyKey 
and POKind = @POKind
order by PremiumID


Select mpd.*,
cm.StationID as PublicationID,
cm.Name as PublicationName,
ua.UserName as AddedByName,
uu.UserName as UpdatedByName
from tMediaPremiumDetail mpd (nolock)
inner join tMediaPremium mp (nolock)  on mpd.MediaPremiumKey = mp.MediaPremiumKey
left outer join tCompanyMedia cm (nolock) on mpd.CompanyMediaKey = cm.CompanyMediaKey
left outer join vUserName ua (nolock) on mpd.AddedBy = ua.UserKey
left outer join vUserName uu (nolock) on mpd.UpdatedBy = uu.UserKey
Where mp.CompanyKey = @CompanyKey 
and POKind = @POKind
order by cm.Name, mpd.StartDate
GO
