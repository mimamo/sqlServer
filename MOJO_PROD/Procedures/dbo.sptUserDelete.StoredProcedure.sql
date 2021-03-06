USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserDelete]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserDelete]
 @UserKey int
AS --Encrypt

/*
|| When     Who Rel     What
|| 01/03/07 RTC 8.4001  Added deletion of tTeamUser rows
|| 01/04/07 RTC 8.4001  Added validation to prevent deletion of a user when they are designated as the internal approver on an estimate
|| 03/09/07 CRG 8.4.0.6 Added deletion of tCalendarAttendeeGroup
|| 05/30/08 GWG 10.0.0  Added a check for tTaskUser 
|| 06/22/08 GWG 10.0.0.3 Added deletion of tAssignment
|| 08/15/09 GWG 10.5.0.7 Added Deletion from marketing lists
|| 02/25/10 GWG 10.5.1.9 Modified restriction for assignments to only stop on active projects
|| 08/25/10 RLB 10.5.3.4 (88304) removed check for user checked out by and added by
*/	

DECLARE @CompanyKey int
 
	BEGIN
	SELECT @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey)
	FROM   tUser (NOLOCK)
	WHERE  UserKey = @UserKey 
	
	IF @CompanyKey IS NOT NULL 
	IF NOT EXISTS (SELECT 1
	      FROM   tUser (NOLOCK)
	      WHERE  Administrator = 1
	      AND    Active        = 1
	      AND    CompanyKey    = @CompanyKey
	      AND    UserKey      != @UserKey)
	RETURN -1
	END


	if exists(select 1 from tApprovalList tbl (nolock) where tbl.UserKey = @UserKey)
		Return -2
/*
	if exists(select 1 from tAttachment tbl (nolock) where tbl.AddedBy = @UserKey)
		Return -4
*/
	if exists(select 1 from tCalendar tbl (nolock) 
		inner join tCalendarAttendee ca (NOLOCK) on tbl.CalendarKey = ca.CalendarKey 
		where ca.Entity = 'Organizer' and ca.EntityKey = @UserKey)
		Return -5
	if exists(select 1 from tContactActivity tbl (nolock) where tbl.ContactKey = @UserKey)
		Return -8
	if exists(select 1 from tExpenseEnvelope tbl (nolock) where tbl.UserKey = @UserKey)
		Return -9
	--if exists(select 1 from tDAFile tbl (nolock) where tbl.CheckedOutByKey = @UserKey OR tbl.AddedByKey = @UserKey)
	--	Return -10
	if exists(select 1 from tForm tbl (nolock) where tbl.AssignedTo = @UserKey OR tbl.Author = @UserKey)
		Return -12
	if exists(select 1 from tInvoice tbl (nolock) where tbl.ApprovedByKey = @UserKey Or tbl.PrimaryContactKey = @UserKey)
		Return -14
	if exists(select 1 from tLead tbl (nolock) where tbl.ContactKey = @UserKey OR tbl.AccountManagerKey = @UserKey)
		Return -15
	if exists(select 1 from tLink tbl (nolock) where tbl.AddedBy = @UserKey)
		Return -16
	if exists(select 1 from tPurchaseOrder tbl (nolock) where tbl.ApprovedByKey = @UserKey)
		Return -19
	if exists(select 1 from tTimeSheet tbl (nolock) where tbl.UserKey = @UserKey)
		Return -21
	if exists(select 1 from tVoucher tbl (nolock) where tbl.ApprovedByKey = @UserKey)
		Return -22
	if exists(select 1 from tEstimate tbl (nolock) where tbl.PrimaryContactKey = @UserKey)
		Return -23
	if exists(select 1 from tEstimate tbl (nolock) where tbl.InternalApprover = @UserKey)
		Return -24
	if exists(select 1 from tTaskUser tbl (nolock) 
		inner join tTask t (nolock) on tbl.TaskKey = t.TaskKey
		inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey 
		where tbl.UserKey = @UserKey and p.Active = 1)
		Return -25
		

		
Begin Tran M1

	declare @CustomFieldKey int
	Select @CustomFieldKey = CustomFieldKey from tUser (nolock) Where UserKey = @UserKey
	exec spCF_tObjectFieldSetDelete @CustomFieldKey

	Update tActivationLog
	Set DateDeactivated = GETDATE()
	Where UserKey = @UserKey and DateDeactivated IS NULL
 
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99					   	
	  end

	DELETE	tCalendarAttendeeGroup
	WHERE	CalendarAttendeeKey IN
			(SELECT	CalendarAttendeeKey
			FROM	tCalendarAttendee (nolock)
			WHERE	Entity = 'Attendee'
			AND		EntityKey = @UserKey)
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99				   	
	  end
	  
	DELETE FROM tCalendarAttendee Where Entity = 'Attendee' and EntityKey = @UserKey
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99				   	
	  end
	DELETE FROM tReport Where Private = 1 and UserKey = @UserKey
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99				   	
	  end
	DELETE FROM tDAFileRight WHERE EntityKey = @UserKey AND Entity = 'User'
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99					   	
	  end
	DELETE FROM tDAFolderRight WHERE EntityKey = @UserKey AND Entity = 'User'
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99					   	
	  end
	DELETE FROM tFormSubscription WHERE UserKey = @UserKey
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99					   	
	  end
	DELETE FROM tUserSkillSpecialty WHERE UserKey = @UserKey
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99					   	
	  end
	DELETE FROM tUserSkill WHERE UserKey = @UserKey
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99					   	
	  end
	DELETE FROM tUserPreference WHERE UserKey = @UserKey
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99					   	
	  end
	DELETE FROM tUserNotification WHERE UserKey = @UserKey
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99					   	
	  end
	DELETE FROM tAddress WHERE Entity = 'tUser' AND EntityKey = @UserKey
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99					   	
	  end
	DELETE FROM tMarketingListList WHERE Entity = 'tUser' AND EntityKey = @UserKey
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99					   	
	  end
	DELETE FROM tTeamUser WHERE UserKey = @UserKey 
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99					   	
	  end
	  
	DELETE FROM tLevelHistory WHERE Entity = 'tUser' and EntityKey = @UserKey 
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99					   	
	  end
	  
	UPDATE tLead SET ContactKey = NULL WHERE ContactKey = @UserKey
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99					   	
	  end
	  
	DELETE FROM tTaskUser Where UserKey = @UserKey
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99				   	
	  end
	  
	 DELETE FROM tAssignment WHERE UserKey = @UserKey 
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -99					   	
	  end
	  	
	DELETE FROM tUser WHERE UserKey = @UserKey 
if @@ERROR <> 0 
	  begin
		rollback tran M1
		return -1					   	
	  end
	  	
commit tran M1

	RETURN 1
GO
