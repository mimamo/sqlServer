USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewDeliverableGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptReviewDeliverableGet]
 @ReviewDeliverableKey int

  /*
  || When		Who Rel			What
  || 08/23/11	QMD 10.5.x.x	Added tPreference Join
  || 09/23/11	QMD 10.5.4.8	Added tCompany join
  || 01/19/12	MAS 10.5.5.2	Added additional tPreference options
  || 01/20/12	QMD 10.5.5.2	Added ClientName
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
 From tReviewDeliverable rd (nolock)
	 inner join tProject p (nolock) on p.ProjectKey = rd.ProjectKey 
	 left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey 
	 left outer join tUser u (nolock) on u.UserKey = rd.OwnerKey
	 left outer join tPreference pref (nolock) on p.CompanyKey = pref.CompanyKey
 Where ReviewDeliverableKey = @ReviewDeliverableKey
GO
