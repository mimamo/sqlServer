USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserGetReviewList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserGetReviewList]

	@Entity varchar(50),
	@UserKey int,
	@ActiveOnly tinyint


AS --Encrypt

if @Entity = 'ProjectRequest'
	if @ActiveOnly = 1
		SELECT 
			r.RequestKey,
			r.RequestID,
			r.RequestedBy,
			r.NotifyEmail,
			asu.DateActivated,
			asu.DueDate,
			step.Instructions,
			asu.Comments,
			c.CustomerID,
			c.CompanyName,
			rd.RequestName
		FROM tApprovalStep step (nolock) 
			inner join tApprovalStepUser asu on step.ApprovalStepKey = asu.ApprovalStepKey
			inner join tRequest r on step.EntityKey = r.RequestKey
			inner join tRequestDef rd on r.RequestDefKey = rd.RequestDefKey
			left outer join tCompany c on r.ClientKey = c.CompanyKey
		WHERE
		step.Entity = @Entity and
		asu.AssignedUserKey = @UserKey and
		asu.ActiveUser = 1
		Order By
			asu.DueDate
	else
		SELECT 
			r.RequestKey,
			r.RequestID,
			r.RequestedBy,
			r.NotifyEmail,
			asu.DateActivated,
			asu.DueDate,
			step.Instructions,
			asu.Comments,
			c.CustomerID,
			c.CompanyName,
			rd.RequestName
		FROM tApprovalStep step (nolock)
			inner join tApprovalStepUser asu on step.ApprovalStepKey = asu.ApprovalStepKey
			inner join tRequest r on step.EntityKey = r.RequestKey
			inner join tRequestDef rd on r.RequestDefKey = rd.RequestDefKey
			left outer join tCompany c on r.ClientKey = c.CompanyKey
		WHERE
		step.Entity = @Entity and
		asu.AssignedUserKey = @UserKey and
		asu.CompletedUser = 1
		Order By
			asu.DueDate	
			
			
RETURN 1
GO
