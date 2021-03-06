USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundGetList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
|| When     Who Rel			What
|| 08/01/11 MAS 10.5.4.8    Created
|| 12/12/11 QMD 10.5.5.1    Added Status Description
|| 12/13/11 QMD 10.5.5.1    Added CancelledDate,  CancelledByUserName
|| 01/11/12 QMD 10.5.5.2    Added QS
|| 01/30/12 QMD 10.5.5.3    Removed QS
|| 02/08/12 QMD 10.5.5.3    Added status 5 description, completeddate
|| 04/16/13 QMD 10.5.6.7    Added InternalStepDateCompleted and StepName
|| 02/04/14 QMD 10.5.7.6    Changed Rejected to Resubmit
*/


CREATE Procedure [dbo].[sptReviewRoundGetList]
 @ReviewDeliverableKey int
 
AS --Encrypt
 Declare @ReviewRoundKey int 
 
 Select @ReviewRoundKey = MIN(ReviewRoundKey) 
 From	tReviewRound (Nolock)
 Where	ReviewDeliverableKey = @ReviewDeliverableKey

 Select rr.ReviewRoundKey
		,rr.ReviewDeliverableKey
		,ISNULL(rr.CompleteTaskWhenDone,0) as CompleteTaskWhenDone
		,rr.DueDate
		,ISNULL(rr.WorkflowType,0) as WorkflowType
		,ISNULL(rr.Status,0) as Status
		,rr.DateSent
		,rr.SentByUserKey
		,rr.RoundName
 		,t.TaskKey
		,t.TaskID
		,t.TaskName
		,case ISNULL(rr.Status,0)
			when 1 then 'New'
			when 2 then 'Submitted'
			when 3 then 'Resubmit'
			when 4 then 'Cancelled'
			when 5 then 'Complete'
		 end AS StatusDescription
		 ,rr.CancelledDate
		 ,u.UserFullName as CancelledByUserName
		 ,rr.CompletedDate
		 ,rr.RejectedDate
		 ,x.InternalStepDateCompleted
		 ,x.StepName		 
 From tReviewRound rr (nolock)
 left outer join tTask t (nolock) on t.TaskKey = rr.TaskKey
 left outer join vUserName u (nolock) on u.UserKey = rr.CancelledByUserKey
 left outer join (
		SELECT	a.EntityKey AS ReviewRoundKey, MAX(asu.DateCompleted) AS InternalStepDateCompleted,
					(SELECT 'Internal Review ' + CONVERT(Varchar(20), count(*) )
					 FROM tApprovalStep aa (NOLOCK) INNER JOIN tReviewRound rr (NOLOCK) ON aa.EntityKey = rr.ReviewRoundKey
					 WHERE Internal = 1
							AND EntityKey >= @ReviewRoundKey
							AND EntityKey <= a.EntityKey
							AND rr.CancelledDate IS NULL) AS StepName
		FROM	tApprovalStep a INNER JOIN tApprovalStepUser asu ON a.ApprovalStepKey = asu.ApprovalStepKey
		WHERE	a.Entity = 'tReviewRound' 
				AND a.EntityKey >= @ReviewRoundKey
				AND a.Internal = 1
				AND asu.DateCompleted IS NOT NULL
		GROUP BY a.EntityKey
	) AS x ON x.ReviewRoundKey = rr.ReviewRoundKey   
 Where ReviewDeliverableKey = @ReviewDeliverableKey
 Order by rr.ReviewRoundKey
GO
