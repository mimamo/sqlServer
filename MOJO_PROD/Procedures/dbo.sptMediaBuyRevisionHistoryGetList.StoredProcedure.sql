USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaBuyRevisionHistoryGetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaBuyRevisionHistoryGetList]
	(
	@CompanyKey int
	,@Entity varchar(50)
	,@EntityKey int
	)
AS
	SET NOCOUNT ON

/*
|| When     Who	Rel			What
|| 05/14/14 GHL 10.580    Creation for the media buy action log
|| 06/03/14 GHL 10.580    Added sorts, so that it will be better on the report
|| 06/05/14 GHL 10.581    Added support for manual premium (no MediaPremiumKey)
*/


	select hist.*
		   ,u.UserName
		   ,isnull(prem.PremiumID, hist.PremiumID) as MediaPremiumID
	from   tMediaBuyRevisionHistory hist (nolock)
		left outer join vUserName u (nolock) on hist.UserKey =  u.UserKey
		left outer join tMediaPremium prem (nolock) on hist.MediaPremiumKey = prem.MediaPremiumKey 
	where  hist.CompanyKey = @CompanyKey
	and    hist.Entity = @Entity
	and    hist.EntityKey = @EntityKey
	Order By hist.Revision DESC, hist.ActionDate DESC
	, hist.Action -- this ways BUY changes are before ORDER changes 
	, hist.Comments desc

	RETURN 1
GO
