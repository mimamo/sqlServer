USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spApprovalGetCFRequests]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spApprovalGetCFRequests]
	(
	@UserKey int
	,@GetCustomFieldKeys int
	)
AS
	SET NOCOUNT ON

  /*
  || When     Who Rel      What
  || 09/09/14 GHL 10.584   Creation for an enhancement for Kohl
  ||                       For project requests, pull Custom Fields
  ||                       Call this sp twice:
  ||                       1) call sp to get the custom field keys
  ||                       2) VB code will populate field values on limited number of CFs selected on the screen
  ||                       3) call sp a second time to join request data with custom fields 
  */
	/* assume done in VB
	create table #cf(CustomFieldKey int null, [CF_Budget] varchar(8000), etc...)
	*/

	if @GetCustomFieldKeys = 1
	begin
		insert #cf (CustomFieldKey)
		SELECT  r.CustomFieldKey
			FROM tApprovalStep step (nolock) 
				inner join tApprovalStepUser asu on step.ApprovalStepKey = asu.ApprovalStepKey
				inner join tRequest r on step.EntityKey = r.RequestKey
			WHERE
			step.Entity = 'ProjectRequest' and
			asu.AssignedUserKey = @UserKey and
			asu.ActiveUser = 1
	end

	else
		SELECT 'Project Requests' AS Type
			,'tRequest' As Entity
			,r.RequestKey As EntityKey
			,asu.DateActivated as SortDate
			,1 as ShowCheckBox
			,NULL As ApprovalComments 
			,r.RequestID As Reference
			,0 AS Selected
			,r.CustomFieldKey
			,r.RequestKey,
			r.RequestID,
			r.RequestedBy,
			r.NotifyEmail,
			asu.DateActivated,
			asu.DueDate,
			step.Instructions,
			asu.Comments,
			c.CustomerID,
			c.CompanyName,
			rd.RequestName,
			r.Subject,
			#cf.*
		FROM tApprovalStep step (nolock) 
			inner join tApprovalStepUser asu on step.ApprovalStepKey = asu.ApprovalStepKey
			inner join tRequest r on step.EntityKey = r.RequestKey
			inner join tRequestDef rd on r.RequestDefKey = rd.RequestDefKey
			left outer join tCompany c on r.ClientKey = c.CompanyKey
			left outer join #cf on r.CustomFieldKey = #cf.CustomFieldKey
		WHERE
		step.Entity = 'ProjectRequest' and
		asu.AssignedUserKey = @UserKey and
		asu.ActiveUser = 1 
		Order By
			asu.DueDate
		

	RETURN
GO
