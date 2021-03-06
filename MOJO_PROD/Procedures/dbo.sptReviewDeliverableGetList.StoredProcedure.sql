USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewDeliverableGetList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptReviewDeliverableGetList]
 @ProjectKey int
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 08/02/11	MAS 10.5.x.x	Created - Same fields as vListing_Deliverables just without the user friendly names
  || 12/02/11   QMD 10.5.5.0    keeping it columns selected the same as the view
  || 01/27/11   QMD 10.5.5.3    Fixed paused
  || 01/30/11   QMD 10.5.5.3    Changed Status clause for RoundReview
  || 02/14/12   QMD 10.5.5.3    Included LastCompletedRoundKey in join clause
  || 02/14/12   QMD 10.5.5.8    Fixed case and left join to tReviewRound to match listing.
  || 06/27/14   QMD 10.5.8.1    (220962) Fixed unsubmitted ApproverStatus
  || 09/12/14   QMD 10.5.8.4    Added when r.Status = 1 
  || 04/27/15   GWG 10.5.9.2    Added Issue Counts
  */

 -- Same fields as vListing_Deliverables just without the user friendly names
 Select
	 rd.ReviewDeliverableKey
	,rd.OwnerKey 
	,rd.CompanyKey	
	,p.ProjectKey
	,p.ClientKey
	,r.ReviewRoundKey
	,rd.Description
	,rd.DeliverableName
	,rd.DueDate
	,p.ProjectNumber
	,p.ProjectName
	,r.RoundName
	,a.Internal
	,CASE a.Internal 
		WHEN 1 THEN 'Internal'
		WHEN 0 THEN 'External'
	 END AS CurrentStep
	,r.DateSent 
	,Case When a.ActiveStep = 1 then a.ApproverStatus 
	 Else
		Case When rd.Approved = 1 then 'Approved' 
		Else 
			Case When r.Status IS NULL or r.Status = 1 then 'Unsubmitted'
			Else 'Resubmit' 
			End
		End 
	 End as ApproverStatus

	
	,Case a.EnableRouting
		WHEN 1 THEN 'In Order'
		WHEN 0 THEN 'Everyone'
	 END AS [Routing]
	 ,CASE ISNULL(a.Pause,0)
		WHEN 1 THEN 'YES'
		WHEN 0 THEN 'NO'
	 END AS [Paused]
	 ,CASE a.LoginRequired
		WHEN 1 THEN 'YES'
		WHEN 0 THEN 'NO'
	 END AS LoginRequired
	 ,CASE a.AllApprove
		WHEN 1 THEN 'YES'
		WHEN 0 THEN 'NO'
	 END AS [EveryoneMustReview]
	 ,ISNULL((Select count(*) from tActivity a (nolock) inner join tActivityLink al (nolock) on a.ActivityKey = al.ActivityKey 
			Where al.Entity = 'tReviewDeliverable' and EntityKey = rd.ReviewDeliverableKey and a.Completed = 0), 0) as OpenIssueCount
	 ,ISNULL((Select count(*) from tActivity a (nolock) inner join tActivityLink al (nolock) on a.ActivityKey = al.ActivityKey 
			Where al.Entity = 'tReviewDeliverable' and EntityKey = rd.ReviewDeliverableKey and a.Completed = 1), 0) as ClosedIssueCount
 From tReviewDeliverable rd (nolock)
	left outer join tProject p (nolock) on p.ProjectKey = rd.ProjectKey
	left outer join tReviewRound r (NOLOCK) ON rd.ReviewDeliverableKey = r.ReviewDeliverableKey AND r.LatestRound = 1
	left outer join tApprovalStep a (nolock) on a.EntityKey = r.ReviewRoundKey and a.Entity = 'tReviewRound' and a.ActiveStep = 1

 Where rd.ProjectKey = @ProjectKey
Order By DeliverableName
GO
