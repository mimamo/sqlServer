USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewDeliverableGetByReviewRoundKey]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewDeliverableGetByReviewRoundKey]
 @ReviewRoundKey INT

  /*
  || When		Who Rel			What
  || 03/14/14	QMD 10.5.7.8	Get the deliverable by review round key
  */
 
AS --Encrypt

	Select rd.*
		,p.ProjectNumber
		,p.ProjectName
		,RTRIM(LTRIM(ISNull(p.ProjectNumber,'') + ' - ' + ISNULL(p.ProjectName,''))) as ProjectFormattedName
		,u.UserKey As OwnerUserKey
		,RTRIM(LTRIM(ISNull(u.FirstName,'') + ' ' + ISNULL(u.LastName,''))) as OwnerName
		,u.CompanyKey As OwnerCompanyKey
		,c.CustomerID AS ClientID
		,c.CompanyName AS ClientName
		,(Select count(*) from tReviewRound rr (nolock) Where rr.ReviewDeliverableKey = rd.ReviewDeliverableKey) as RoundCount
		,rr.ReviewRoundKey
	From tReviewDeliverable rd (nolock)
	 inner join tReviewRound rr (nolock) on rd.ReviewDeliverableKey = rr.ReviewDeliverableKey
	 inner join tProject p (nolock) on p.ProjectKey = rd.ProjectKey 
	 left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey 
	 left outer join tUser u (nolock) on u.UserKey = rd.OwnerKey
	 left outer join tPreference pref (nolock) on p.CompanyKey = pref.CompanyKey
	Where rr.ReviewRoundKey = @ReviewRoundKey
GO
