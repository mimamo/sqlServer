USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserDeleteContact]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserDeleteContact]
 @UserKey int
 ,@BypassChecks int = 0
 ,@ModifiedByKey int = 0
 ,@Application varchar(50) = 'UI'
AS --Encrypt

/*
|| When     Who Rel      What
|| 05/12/09 GHL 10.5     Added @BypassChecks for use by contact merging
|| 05/14/09 GHL 10.5     Added deletion of custom field
|| 06/11/09 QMD 10.5     Added Logging for sync process
|| 8/7/09   CRG 10.5.0.7 (59577) Added check for tAssignment to avoid foreign key error.
|| 03/19/10 QMD 10.5.2.0 Added sptMarketingListListDeleteLogInsert call and added delete tmarketinglistlist
|| 03/17/11 RLB 10.5.4.2 If Contact is a primary contact on a company set Primarycontact to null before Contact is deleted
|| 03/18/13 KMC 10.5.6.6 (171874) Update to delete from tTaskUser and tAssignment instead of returning error message
|| 07/29/14 MFT 10.5.8.2 Added tAppHistory
|| 09/02/14 RLB 10.5.8.4 Changed tAppHistory to delete all since contact will be deleted for everyone and not one user and added delete for tAppFavorite
*/	

DECLARE @Parms varchar(500)

if @BypassChecks = 0
begin
	if exists(select 1 from tApprovalList tbl (nolock) where tbl.UserKey = @UserKey)
		Return -2
	if exists(select 1 from tCalendar tbl (nolock) 
		inner join tCalendarAttendee ca (NOLOCK) on tbl.CalendarKey = ca.CalendarKey 
		where ca.Entity = 'Organizer' and ca.EntityKey = @UserKey)
		Return -5
	if exists(select 1 from tExpenseEnvelope tbl (nolock) where tbl.UserKey = @UserKey)
		Return -9
	if exists(select 1 from tDAFile tbl (nolock) where tbl.CheckedOutByKey = @UserKey OR tbl.AddedByKey = @UserKey)
		Return -10
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
end


	DELETE	tCalendarAttendeeGroup
	WHERE	CalendarAttendeeKey IN
			(SELECT	CalendarAttendeeKey
			FROM	tCalendarAttendee (nolock)
			WHERE	Entity = 'Attendee'
			AND		EntityKey = @UserKey)

	  
	DELETE FROM tCalendarAttendee Where Entity = 'Attendee' and EntityKey = @UserKey

	DELETE FROM tCalendarUser Where UserKey = @UserKey

	DELETE FROM tReport Where Private = 1 and UserKey = @UserKey

	DELETE FROM tDAFileRight WHERE EntityKey = @UserKey AND Entity = 'User'

	DELETE FROM tDAFolderRight WHERE EntityKey = @UserKey AND Entity = 'User'

	DELETE FROM tFormSubscription WHERE UserKey = @UserKey

	DELETE FROM tUserSkillSpecialty WHERE UserKey = @UserKey

	DELETE FROM tUserSkill WHERE UserKey = @UserKey

	DELETE FROM tUserPreference WHERE UserKey = @UserKey

	DELETE FROM tUserNotification WHERE UserKey = @UserKey

	DELETE FROM tAddress WHERE Entity = 'tUser' AND EntityKey = @UserKey

	DELETE FROM tTeamUser WHERE UserKey = @UserKey 
	
	DELETE FROM tContactDatabaseUser WHERE UserKey = @UserKey
	
	DELETE FROM tDashboardModuleUser WHERE UserKey = @UserKey
	  	
	DELETE FROM tProjectUserServices WHERE UserKey = @UserKey
	
	DELETE FROM tSystemMessageUser WHERE UserKey = @UserKey
	
	DELETE FROM tLeadUser WHERE UserKey = @UserKey

	DELETE FROM tTaskUser WHERE UserKey = @UserKey
	
	DELETE FROM tAssignment WHERE UserKey = @UserKey

	update tCompany set PrimaryContact = null where PrimaryContact = @UserKey
	
	DELETE FROM tLevelHistory where Entity='tUser' and EntityKey = @UserKey -- effect on company?

	DELETE FROM tAppFavorite WHERE ActionID = 'cm.contacts' AND ActionKey = @UserKey

	DELETE FROM tAppHistory WHERE ActionID = 'cm.contacts' AND ActionKey = @UserKey
	
	
	Update tActivationLog
	Set DateDeactivated = GETDATE()
	Where UserKey = @UserKey and DateDeactivated IS NULL
	
	DECLARE @CustomFieldKey int
	
	SELECT @CustomFieldKey = CustomFieldKey FROM tUser (NOLOCK) where UserKey = @UserKey
	
	IF ISNULL(@CustomFieldKey, 0) > 0
		exec spCF_tObjectFieldSetDelete @CustomFieldKey

	SELECT @Parms = '@UserKey=' + Convert(varchar(7), @UserKey)
	EXEC sptUserUpdateLogInsert @ModifiedByKey, @UserKey, 'D', 'sptUserDeleteContact', @Parms, @Application
	
	-- Log Marketing List List Deletes
	IF EXISTS(SELECT * FROM tMarketingListList (NOLOCK) WHERE Entity = 'tUser' AND EntityKey = @UserKey)
		BEGIN				
			DECLARE @parmList VARCHAR(50)
			SELECT @parmList = '@UserKey = ' + CONVERT(VARCHAR(10),@UserKey)
			EXEC sptMarketingListListDeleteLogInsert @ModifiedByKey, @UserKey, 'tUser', 'sptUserDeleteContact', @parmList, 'UI'

			--delete tmarketinglistlist for the entityKey
			DELETE tMarketingListList WHERE Entity = 'tUser' AND EntityKey = @UserKey
		END
		
	
	DELETE FROM tUser WHERE UserKey = @UserKey 


	RETURN 1
GO
