USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundGetReviewers]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundGetReviewers]
 @ReviewRoundKey INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 09/19/12	QMD 10.5.6.0	Created to get reviewers
  || 10/5/12    GWG 10.5.6.0    Added in With Changes
  || 07/10/13   QMD 10.5.7.0    Changed descriptoin from Rejected to Changes Needed
  */
  
    SELECT s.[Subject], s.Instructions, s.Completed, su.*,
	LTRIM(RTRIM(ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName, ''))) As UserName,
	Case WHEN su.Action = 1 and su.WithChanges = 1 then 'Approved With Changes'
		 WHEN su.Action = 1 and ISNULL(su.WithChanges, 0) = 0 then 'Approved'
		 WHEN su.Action = 2 then 'Changes Needed'
		 Else 'No Decision'	
	END as ActionDescription 
  FROM tApprovalStepUser su (NOLOCK)
  INNER JOIN tApprovalStep s (NOLOCK) ON s.ApprovalStepKey = su.ApprovalStepKey
  INNER JOIN tUser u (NOLOCK) ON u.UserKey = su.AssignedUserKey 
  WHERE Entity = 'tReviewRound'
  And EntityKey = @ReviewRoundKey
  Order By su.ApprovalStepKey, LTRIM(RTRIM(ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName, '')))
GO
