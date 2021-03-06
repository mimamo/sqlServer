USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepGetReminders]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepGetReminders]

/*
|| When     Who Rel			What
|| 10/05/12 QMD 10.5.6.0    Created to get the hourly reminders
|| 03/23/15 RLB 10.5.9.0    (250722) Default Time Zone Index to 35 if it is null
|| 04/21/15 QMD 10.5.9.1    (252900) Limit to active projects
*/

AS --Encrypt
		
	-- Get reviewers when step that is sent to "everyone at once"	
	SELECT	p.CompanyKey, p.ProjectName, p.ProjectNumber, d.DeliverableName, d.Description, r.RoundName, s.Subject, s.Instructions,
			u.Email, ISNULL(u.TimeZoneIndex, 35) as TimeZoneIndex, asu.DueDate, s.LoginRequired, s.ApprovalStepKey, asu.AssignedUserKey, r.ReviewRoundKey, s.ReminderType,
			asu.StartReminder, asu.NextReminder, asu.ApprovalStepUserKey
	FROM	tApprovalStep s (NOLOCK) INNER JOIN tReviewRound r (NOLOCK) ON r.ReviewRoundKey = s.EntityKey AND Entity = 'tReviewRound'
				INNER JOIN tReviewDeliverable d (NOLOCK) ON r.ReviewDeliverableKey = d.ReviewDeliverableKey
				INNER JOIN tApprovalStepUser asu (NOLOCK) ON s.ApprovalStepKey = asu.ApprovalStepKey
				INNER JOIN tUser u (NOLOCK) ON asu.AssignedUserKey = u.UserKey
				INNER JOIN tProject p (NOLOCK) ON d.ProjectKey = p.ProjectKey
	WHERE	s.Completed = 0
			AND s.ActiveStep = 1	
			AND s.SendReminder = 1
			AND r.[Status] = 2
			AND ISNULL(asu.[Action],0) = 0
			AND ISNULL(asu.CompletedUser,0) = 0
			AND asu.ActiveUser = 1			
			AND  GETUTCDATE() >= CAST(ISNULL(asu.NextReminder, asu.StartReminder) AS DATETIME) 
			AND GETUTCDATE() <= asu.DueDate
			AND p.Active = 1
GO
