USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceArtReviewReminder]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserPreferenceArtReviewReminder]

	@UserKey int,
	@DueInDays int = 3	-- Start sending reminders when due X days from now

AS --Encrypt

/*
|| When     Who Rel	      What
|| 1/05/12  MAS 10.5.5.2  Created
|| 4/02/12  QMD 10.5.5.5  Added AssignedUserKey, CompanyKey and LoginRequired.
||						  Changed the logic to use the tApprovalStepUser due 
|| 04/21/15 QMD 10.5.9.1  (252900) Limit to active projects
*/

SELECT  rr.ReviewRoundKey,
	rr.RoundName,
	rr.DueDate, 
	rr.TaskKey, 
	t.TaskName,
	u.Email,
	LTRIM(RTRIM(ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName, ''))) As FullName,
	s.Subject,
	s.Instructions,
	s.ApprovalStepKey,
	d.ReviewDeliverableKey,
	d.DeliverableName,
	p.ProjectNumber,
	p.ProjectName,
	ISNULL(DATEDIFF(dd,GetDate(),su.DueDate),0) AS DueInDays,
	su.AssignedUserKey,
	s.LoginRequired,
	d.CompanyKey

FROM tReviewRound rr (NOLOCK)
	INNER JOIN tReviewDeliverable d (NOLOCK) on d.ReviewDeliverableKey = rr.ReviewDeliverableKey
	INNER JOIN tApprovalStep s(NOLOCK) on s.EntityKey = rr.ReviewRoundKey
	INNER JOIN tApprovalStepUser su (NOLOCK) on su.ApprovalStepKey = s.ApprovalStepKey
	INNER JOIN tUser u (NOLOCK) on u.UserKey = su.AssignedUserKey
	INNER JOIN tProject p (NOLOCK) on p.ProjectKey = d.ProjectKey
	LEFT OUTER JOIN tTask t (NOLOCK) on rr.TaskKey = t.TaskKey	

WHERE 
	u.UserKey = @UserKey AND u.Email IS NOT NULL
	-- Review Round 
	AND ISNULL(rr.Status,0) = 2  -- Submitted(Sent)
	AND rr.DateSent IS NOT NULL  
	AND rr.CancelledDate IS NULL 
	AND ISNULL(DATEDIFF(dd,GetDate(),su.DueDate),0) <= @DueInDays
	-- tApprovalStep
	AND s.Entity = 'tReviewRound'
	AND ISNULL(s.ActiveStep,0) = 1 
	AND ISNULL(s.Completed,0) = 0
	AND ISNULL(s.Pause,0) = 0
	AND ISNULL(s.SendReminder,0) > 0
	-- tApprovalStepUser
	AND su.DateActivated IS NOT NULL
	AND su.DateCompleted IS NULL
	AND p.Active = 1
Order By DueInDays
GO
