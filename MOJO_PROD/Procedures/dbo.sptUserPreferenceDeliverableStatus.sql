USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceDeliverableStatus]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserPreferenceDeliverableStatus]

	(
	@CompanyKey int,
	@UserKey int,
	@Value1 int,
	@Value2 int
	)

AS


--'1*All Deliverables I own on Active Projects|2*All Deliverables on Active Projects I am assigned to|3*All Deliverables on Active Projects I am the Account Manager', 
--'0*Due On or Before Today|2*Due in the next 2 days|3*Due in the next 3 days|5*Due in the next 5 days')


Declare @EndDate smalldatetime 

Select @EndDate = dbo.fFormatDateNoTime(GETDATE())
if @Value2 = 2
	Select @EndDate = DATEADD(d, 2, @EndDate)
if @Value2 = 3
	Select @EndDate = DATEADD(d, 3, @EndDate)
if @Value2 = 5
	Select @EndDate = DATEADD(d, 5, @EndDate)

--All Deliverables I own on Active Projects
if @Value1 = 1
BEGIN

	Select d.ReviewDeliverableKey, d.ProjectKey, p.ProjectNumber, p.ProjectName, d.DeliverableName, d.Description, d.DueDate
		,rr.RoundName, rr.DateSent, su.DateActivated, su.DueDate as UserDueDate, s.ApproverStatus, s.Subject, u.UserName, ISNULL(su.Action, 0) as Action, su.WithChanges  
	From 
		tReviewDeliverable d (nolock) 
		INNER JOIN tProject p on d.ProjectKey = p.ProjectKey
		INNER JOIN tReviewRound rr on d.ReviewDeliverableKey = rr.ReviewDeliverableKey
		INNER JOIN tApprovalStep s (NOLOCK) on s.EntityKey = rr.ReviewRoundKey and s.Entity = 'tReviewRound'
		INNER JOIN tApprovalStepUser su (NOLOCK) on su.ApprovalStepKey = s.ApprovalStepKey
		INNER JOIN vUserName u (NOLOCK) on u.UserKey = su.AssignedUserKey
	Where 
		p.Active = 1
		and p.CompanyKey = @CompanyKey
		and rr.Status = 2
		and su.DueDate <= @EndDate
		and d.OwnerKey = @UserKey
	Order By ProjectNumber, DeliverableName
END


--All Deliverables on Active Projects I am assigned to
if @Value1 = 2
BEGIN
	Select d.ReviewDeliverableKey, d.ProjectKey, p.ProjectNumber, p.ProjectName, d.DeliverableName, d.Description, d.DueDate
		,rr.RoundName, rr.DateSent, su.DateActivated, su.DueDate as UserDueDate, s.ApproverStatus, s.Subject, u.UserName, ISNULL(su.Action, 0) as Action, su.WithChanges
	From 
		tReviewDeliverable d (nolock) 
		INNER JOIN tProject p on d.ProjectKey = p.ProjectKey
		INNER JOIN tAssignment a on p.ProjectKey = a.ProjectKey
		INNER JOIN tReviewRound rr on d.ReviewDeliverableKey = rr.ReviewDeliverableKey
		INNER JOIN tApprovalStep s (NOLOCK) on s.EntityKey = rr.ReviewRoundKey and s.Entity = 'tReviewRound'
		INNER JOIN tApprovalStepUser su (NOLOCK) on su.ApprovalStepKey = s.ApprovalStepKey
		INNER JOIN vUserName u (NOLOCK) on u.UserKey = su.AssignedUserKey
	Where 
		p.Active = 1
		and p.CompanyKey = @CompanyKey
		and rr.Status = 2
		and su.DueDate <= @EndDate
		and a.UserKey = @UserKey
	Order By ProjectNumber, DeliverableName
END


--All Deliverables on Active Projects I am the Account Manager
if @Value1 = 3
BEGIN
	Select d.ReviewDeliverableKey, d.ProjectKey, p.ProjectNumber, p.ProjectName, d.DeliverableName, d.Description, d.DueDate
		,rr.RoundName, rr.DateSent, su.DateActivated, su.DueDate as UserDueDate, s.ApproverStatus, s.Subject, u.UserName, ISNULL(su.Action, 0) as Action, su.WithChanges  
	From 
		tReviewDeliverable d (nolock) 
		INNER JOIN tProject p on d.ProjectKey = p.ProjectKey
		INNER JOIN tReviewRound rr on d.ReviewDeliverableKey = rr.ReviewDeliverableKey
		INNER JOIN tApprovalStep s (NOLOCK) on s.EntityKey = rr.ReviewRoundKey and s.Entity = 'tReviewRound'
		INNER JOIN tApprovalStepUser su (NOLOCK) on su.ApprovalStepKey = s.ApprovalStepKey
		INNER JOIN vUserName u (NOLOCK) on u.UserKey = su.AssignedUserKey
	Where 
		p.Active = 1
		and p.CompanyKey = @CompanyKey
		and rr.Status = 2
		and su.DueDate <= @EndDate
		and p.AccountManager = @UserKey
	Order By ProjectNumber, DeliverableName
END
GO
