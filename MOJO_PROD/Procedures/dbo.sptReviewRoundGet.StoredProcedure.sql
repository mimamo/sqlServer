USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundGet]
 @ReviewRoundKey INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 08/04/11	QMD 10.5.4.7	Created for new ArtReview
  || 09/15/11	QMD 10.5.4.8	Added DeliverableName
  || 09/15/11	MAS 10.5.4.8	Sort Approval Users by DisplayOrder
  || 09/28/11	QMD 10.5.4.8	Added sp call for getting files
  || 11/30/11	QMD 10.5.5.0	Added StatusDescription
  || 12/06/11	QMD 10.5.5.1	Added ClientKey
  || 12/28/11	QMD 10.5.5.1	Added CompanyKey
  || 01/12/12	QMD 10.5.5.2	Added QS
  || 01/20/12	QMD 10.5.5.2	Removed QS
  || 02/08/12   QMD 10.5.5.3    Modified status descriptions
  || 02/08/12   QMD 10.5.5.3    Added action descriptions
  || 02/13/12   QMD 10.5.5.3    Added rejected subquery
  || 10/12/12   QMD 10.5.6.2    Added TimeZoneIndex, OriginalDueDate and OriginalNextReminder select
  || 04/26/13   QMD 10.5.6.7    Changed TimeZoneIndex to pull from the table
  || 02/04/14   QMD 10.5.7.6    (201409) Changed Rejected to Resubmit
  || 08/29/14   QMD 10.5.8.3    (226526) Added action description skipped
  || 02/05/15   QMD 10.5.8.8    (244033) Added Order By to steps get.
  */
  
  SELECT	r.*, p.ProjectKey, p.ProjectName, p.ProjectNumber, 
			ISNULL(p.ProjectNumber,'') + ' - ' + ISNULL(p.ProjectName,'')AS ProjectFormattedName,
			c.CustomerID as ClientID, c.CompanyName as ClientName,
			d.DeliverableName,
			CASE r.Status
				WHEN 1 THEN 'New'
				WHEN 1 THEN 'New'
				WHEN 2 THEN 'Submitted'
				WHEN 3 THEN 'Resubmit'
				WHEN 4 THEN 'Cancelled'
				WHEN 5 THEN 'Complete'
			END AS StatusDescription,
			p.ClientKey,
			d.CompanyKey
  FROM		tReviewRound r (NOLOCK) 
  INNER JOIN tReviewDeliverable d (NOLOCK) ON d.ReviewDeliverableKey = r.ReviewDeliverableKey
  INNER JOIN tProject p (NOLOCK) ON p.ProjectKey = d.ProjectKey
  left outer join tCompany c (NOLOCK) on p.ClientKey = c.CompanyKey
  WHERE		ReviewRoundKey = @ReviewRoundKey

  -- Get all the steps for this round	  
  SELECT s.*, ISNULL(a.Rejected,0) AS Rejected, s.TimeZoneIndex
  FROM tApprovalStep s (NOLOCK) 
			LEFT JOIN ( SELECT	s.ApprovalStepKey, COUNT(ISNULL(asu.Action,0)) as Rejected
					 FROM	tApprovalStep s (NOLOCK) INNER JOIN tApprovalStepUser asu (NOLOCK) ON s.ApprovalStepKey = asu.ApprovalStepKey
					 WHERE	asu.Action = 2
					 GROUP BY s.ApprovalStepKey ) a ON s.ApprovalStepKey = a.ApprovalStepKey
  WHERE s.Entity = 'tReviewRound'
		And s.EntityKey = @ReviewRoundKey
  ORDER BY s.DisplayOrder ASC


  -- Get all the approval users for this particular round across all steps
  SELECT su.*,
	LTRIM(RTRIM(ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName, ''))) As UserName,
	su.DueDate as OriginalDueDate,
	su.NextReminder as OriginalNextReminder,
	CASE su.Action
		WHEN 1 THEN 'Approved'
		WHEN 2 THEN 'Resubmit'
		WHEN 3 THEN 'Skipped'
	END as ActionDescription 
  FROM tApprovalStepUser su (NOLOCK)
  INNER JOIN tApprovalStep s (NOLOCK) ON s.ApprovalStepKey = su.ApprovalStepKey
  INNER JOIN tUser u (NOLOCK) ON u.UserKey = su.AssignedUserKey 
  WHERE Entity = 'tReviewRound'
  And EntityKey = @ReviewRoundKey
  Order By su.DisplayOrder


  -- Get all the notify users for this particular round across all steps
  SELECT sn.*,
	LTRIM(RTRIM(ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName, ''))) As UserName
  FROM tApprovalStepNotify sn (NOLOCK)
  INNER JOIN tApprovalStep s (NOLOCK) ON s.ApprovalStepKey = sn.ApprovalStepKey
  INNER JOIN tUser u (NOLOCK) ON u.UserKey = sn.AssignedUserKey
  WHERE Entity = 'tReviewRound'
  And EntityKey = @ReviewRoundKey

  -- Get all the files
  EXEC sptReviewRoundFileGet @ReviewRoundKey
GO
