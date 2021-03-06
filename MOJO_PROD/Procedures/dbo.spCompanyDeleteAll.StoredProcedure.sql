USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCompanyDeleteAll]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCompanyDeleteAll]

	(
		@CompanyKey int
		,@DeleteSetupTables int = 1 
		,@DeleteTemplateProjects int = 1
		,@LeaveCoreCompany int = 1
	)

AS --Encrypt

/*
	Who		When		What
	GHL		09/19/05	Updated for version 800
	GHL		10/31/05	Updated for version 81
	GHL		01/26/05	Updated for version 82
	GHL		03/27/06	Updated for Version 83
	GHL		06/30/06	Updated for Version 835
						Added parameter @DeleteSetupTables for Harding
						If @DeleteSetupTables = 0 we delete transactions only
						If @DeleteSetupTables = 1 we delete setup + transactions table
    GHL     11/29/06    8.4 Changed order of some tables to prevent FK errors
    CRG		01/16/07    Updated to:
                          Delete tDashboardModuleUser where the UserKey is not in tUser
                          Delete tCalendarAttendeeGroup where CalendarKey is not in tCalendar
                          Delete tUser where CompanyKey is in tCompany where OwnerCompanyKey = @CompanyKey
    GHL     03/16/07    8.407 Added tProjectRollup, tSystemMessageUser                
    GHL		06/20/07	8.43 Added tInvoiceAdvanceBillTax
    QMD     07/16/07    8.4.3.2	Added the insert statement into tCalendarDelete  
    GHL     06/09/09    10.026 Added cash basis and wmj10.0 tables 
    GHL     06/09/09    10.5 Added wmj10.5 tables 
    GHL     09/29/09    10.5 Added deletion of tVoucherTax and tVoucherDetailTax
    GHL     09/29/09    10.5 Added deletion of tInvoiceTax 
    GHL     05/10/10    10.523 (80353) Added param @DeleteTemplateProjects so that we can keep template projects  
                        If you want to keep template projects, execute spCompanyDeleteAll 1, 0, 0   
    CRG     05/18/10    10.5.3.0 Modified because tTaskUser allows NULL UserKey now. Now the tTaskUser key is deleting based on tProject.CompanyKey rather than joining to tUser.
	GHL     06/20/11    (111045) Added missing tables
	GHL     08/16/11    Removed Catalog tables
	CRG     08/22/11    Added tWebDavSecurity
	GHL     09/29/11    Added tVoucherCC and tGLAccountUser for credit card charges
	CRG     11/13/12    Now deleting tAttachment based on CompanyKey
	KMC     05/06/13    (213678) Added @LeaveCoreCompany parameter to wipe everything but the main company,
						and the employees, tPreference record, tTimeOption. 
	GWG     4/22/15		If leave core company, it was still trying to delete tCompany and tWebdavsecurity.
*/

Declare @OFSKey int
Declare @CurKey int
Declare @CurKey2 int

--begin tran

--Delete Entity Relationships first

Select 'tActionLog'

Select 'tActionLog: FileVersion'

--tActionLog: FileVersion
Delete tActionLog 
from	tDAFileVersion fv, tDAFile f, tDAFolder fol, tProject p 
where	tActionLog.Entity = 'FileVersion'
and		tActionLog.EntityKey = fv.FileVersionKey
and		fv.FileKey = f.FileKey 
and		f.FolderKey = fol.FolderKey 
and		fol.ProjectKey = p.ProjectKey 
and		p.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tActionLog: New Entities'

--tActionLog: New Entitys
Delete tActionLog 
WHERE  tActionLog.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tActivityLink'

Delete tActivityLink
FROM   tActivity a 
where  tActivityLink.ActivityKey = a.ActivityKey 
and    a.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tActivityHistory'

Delete tActivityHistory
FROM   tActivity a 
where  tActivityHistory.ActivityKey = a.ActivityKey 
and    a.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tActivityEmail'

Delete tActivityEmail
FROM   tActivity a 
where  tActivityEmail.ActivityKey = a.ActivityKey 
and    a.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tActivity'

Delete tActivity 
WHERE  tActivity.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tActivityType'
If @DeleteSetupTables = 1
Delete tActivityType 
WHERE  tActivityType.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDBLog'

--tDBLog
Delete tDBLog
from   tUser u (nolock)   
where  tDBLog.UserKey = u.UserKey
and    isnull(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSecurityAccess'
If @DeleteSetupTables = 1
Delete tSecurityAccess Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSystemMessageUser'
If @DeleteSetupTables = 1
Delete tSystemMessageUser 
from   tUser
Where isnull(tUser.OwnerCompanyKey, tUser.CompanyKey) = @CompanyKey
and   tSystemMessageUser.UserKey = tUser.UserKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tAttachment'
Delete tAttachment
where	CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tAttributeEntityValue'

--tAttributeEntityValue: File
Delete tAttributeEntityValue
from	tDAFile f, tDAFolder fol, tProject p
where	tAttributeEntityValue.Entity = 'File'
and		tAttributeEntityValue.EntityKey = f.FileKey
and		f.FolderKey = fol.FolderKey
and		fol.ProjectKey = p.ProjectKey
and		p.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tAttributeValue'

--tAttributeValue
Delete tAttributeValue
from	tAttribute a, tDAFile f, tDAFolder fol, tProject p
where	tAttributeValue.AttributeKey = a.AttributeKey
and		a.Entity = 'File'
and		a.EntityKey = f.FileKey
and		f.FolderKey = fol.FolderKey
and		fol.ProjectKey = p.ProjectKey
and		p.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tAttribute'

--tAttribute: File
Delete tAttribute
from	tDAFile f, tDAFolder fol, tProject p
where	tAttribute.Entity = 'File'
and		tAttribute.EntityKey = f.FileKey
and		f.FolderKey = fol.FolderKey
and		fol.ProjectKey = p.ProjectKey
and		p.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLink: ApprovalItem'

--tLink: ApprovalItem
Delete tLink
from	tApprovalItem ai, tApproval a, tProject p
where	tLink.AssociatedEntity = 'ApprovalItem'
and		tLink.EntityKey = ai.ApprovalItemKey
and		ai.ApprovalKey = a.ApprovalKey
and		a.ProjectKey = p.ProjectKey
and		p.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLink: Note'

--tLink: Note
If @DeleteSetupTables = 1
Delete tLink
from	tNote n, tNoteGroup ng
where	tLink.AssociatedEntity = 'Note'
and		tLink.EntityKey = n.NoteKey
and		n.NoteGroupKey = ng.NoteGroupKey
and		ng.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLink: Forms'

--tLink: Forms
If @DeleteSetupTables = 1
Delete tLink
from	tForm f
where	tLink.AssociatedEntity = 'Forms'
and		tLink.EntityKey = f.FormKey
and		f.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLink: Lead'

--tLink: Lead
Delete tLink
from	tLead l
where	tLink.AssociatedEntity = 'Lead'
and		tLink.EntityKey = l.LeadKey
and		l.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSession'

--tSession: User
If @DeleteSetupTables = 1
Delete tSession
from	tUser u
where	tSession.Entity = 'user'
and		tSession.EntityKey = u.UserKey
and		ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSession'

--tSession: Report and Style
If @DeleteSetupTables = 1
Delete tSession
where	tSession.Entity in( 'report', 'style')
and		tSession.EntityKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSpecSheetLink'
Delete tSpecSheetLink where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSpecSheet'

--tSpecSheet: Project
Delete tSpecSheet
from	tProject p
where	tSpecSheet.Entity = 'Project'
and		tSpecSheet.EntityKey = p.ProjectKey
and		p.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSpecSheet'

--tSpecSheet: ProjectRequest
Delete tSpecSheet
from	tRequest r
where	tSpecSheet.Entity = 'Project'
and		tSpecSheet.EntityKey = r.RequestKey
and		r.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSpecSheet'

--tSpecSheet: Lead
Delete tSpecSheet
from	tLead l (NOLOCK)
where	tSpecSheet.Entity = 'Lead'
and		tSpecSheet.EntityKey = l.LeadKey
and		l.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tFieldValue'

--tFieldValue
If @DeleteSetupTables = 1
Delete tFieldValue
from	tFieldDef fd
where	tFieldValue.FieldDefKey = fd.FieldDefKey
and	fd.OwnerEntityKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tObjectFieldSet'

--tObjectFieldSet
If @DeleteSetupTables = 1
Delete tObjectFieldSet
from	tFieldSetField fsf, tFieldDef fd
where	tObjectFieldSet.FieldSetKey = fsf.FieldSetKey
and		fsf.FieldDefKey = fd.FieldDefKey
and		fd.OwnerEntityKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

If @DeleteSetupTables = 1
Delete tObjectFieldSet
where	FieldSetKey in (
	Select FieldSetKey from tFieldSet Where
	OwnerEntityKey = @CompanyKey
	and AssociatedEntity not in ('Forms', 'TaskAssignmentTypes')
)

if	@@error != 0
begin
	--rollback tran
	return -1
end

If @DeleteSetupTables = 1
Delete tObjectFieldSet
where	tObjectFieldSet.FieldSetKey in (
	Select FieldSetKey 
	from tFieldSet, tFormDef fd 
	Where
		tFieldSet.AssociatedEntity = 'Forms'
	and	tFieldSet.OwnerEntityKey = fd.FormDefKey
	and	fd.CompanyKey = @CompanyKey
)

if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tFieldSetField'

--tFieldSetField
If @DeleteSetupTables = 1
Delete tFieldSetField
from	tFieldDef fd
where	tFieldSetField.FieldDefKey = fd.FieldDefKey
and	fd.OwnerEntityKey = @CompanyKey


if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tFieldDef'

--tFieldDef
If @DeleteSetupTables = 1
Delete tFieldDef
where	OwnerEntityKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tFieldSet'

--tFieldSet
If @DeleteSetupTables = 1
Delete tFieldSet
where	OwnerEntityKey = @CompanyKey
and		AssociatedEntity not in ('Forms', 'TaskAssignmentTypes')

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tFieldSet'
If @DeleteSetupTables = 1
Delete tFieldSet
from	tFormDef fd
where	tFieldSet.AssociatedEntity = 'Forms'
and	tFieldSet.OwnerEntityKey = fd.FormDefKey
and	fd.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end


If @DeleteSetupTables = 1
Delete tDBLog
from   tUser 
where tDBLog.UserKey = tUser.UserKey
and   isnull(tUser.OwnerCompanyKey, tUser.CompanyKey) = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tFormDefSecurityGroup'

--tFormDefSecurityGroup
If @DeleteSetupTables = 1
Delete tFormDefSecurityGroup
from	tFormDef fd
where	tFormDefSecurityGroup.FormDefKey = fd.FormDefKey
and		fd.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

--tViewSecurityGroup
-- Added for 835

If @DeleteSetupTables = 1
Delete tViewSecurityGroup
From   tSecurityGroup sg
Where  tViewSecurityGroup.SecurityGroupKey = sg.SecurityGroupKey
and	   sg.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tWidgetSecurity'
If @DeleteSetupTables = 1
Delete tWidgetSecurity
FROM tSecurityGroup (nolock)
WHERE tWidgetSecurity.SecurityGroupKey = tSecurityGroup.SecurityGroupKey
and tSecurityGroup.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tTeamUser'

-- Added for 800
If @DeleteSetupTables = 1
Delete tTeamUser 
From tTeam t
Where t.CompanyKey = @CompanyKey
And t.TeamKey = tTeamUser.TeamKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tTeam'

-- Added for 800
If @DeleteSetupTables = 1
Delete tTeam Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tTaskUser'

-- Added for 800
Delete tTaskUser
From   tTask t
      ,tProject p
Where  tTaskUser.TaskKey = t.TaskKey
And    t.ProjectKey =  p.ProjectKey
And    p.CompanyKey = @CompanyKey
And    isnull(p.Template, 0) = 0
if	@@error != 0
begin
	--rollback tran
	return -1
end

if @DeleteTemplateProjects = 1
begin
	Delete tTaskUser
	From   tTask t
		  ,tProject p
	Where  tTaskUser.TaskKey = t.TaskKey
	And    t.ProjectKey =  p.ProjectKey
	And    p.CompanyKey = @CompanyKey
	And    isnull(p.Template, 0) = 1
	if	@@error != 0
	begin
		--rollback tran
		return -1
	end
end

Select 'tPreferenceDARights'

-- Added for 800
If @DeleteSetupTables = 1
Delete tPreferenceDARights Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSpecSheetLink'

-- Added for 800
Delete tSpecSheetLink Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tProjectTypeMasterTask'

-- Added for 800
If @DeleteSetupTables = 1
Delete tProjectTypeMasterTask
From   tProjectType pt 
Where pt.CompanyKey = @CompanyKey
And tProjectTypeMasterTask.ProjectTypeKey = pt.ProjectTypeKey 
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tProjectTypeService'

-- Added for 800
If @DeleteSetupTables = 1
Delete tProjectTypeService
From   tProjectType pt 
Where pt.CompanyKey = @CompanyKey
And tProjectTypeService.ProjectTypeKey = pt.ProjectTypeKey 
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tMasterTaskAssignment'

-- Added for 800
If @DeleteSetupTables = 1
Delete tMasterTaskAssignment
From   tMasterTask mt 
Where mt.CompanyKey = @CompanyKey
And tMasterTaskAssignment.MasterTaskKey = mt.MasterTaskKey 
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tProjectUserServices'

-- Added for 800
Delete tProjectUserServices
From   tProject p 
Where p.CompanyKey = @CompanyKey
And tProjectUserServices.ProjectKey = p.ProjectKey 
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tProjectEstByItem'

-- Added for 800
Delete tProjectEstByItem from tProject Where tProjectEstByItem.ProjectKey = tProject.ProjectKey and tProject.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tProjectNoteLink'

-- Added for 800
Delete tProjectNoteLink
From tProjectNote pn 
Where tProjectNoteLink.ProjectNoteKey = pn.ProjectNoteKey
And pn.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tProjectNoteUser'

-- Added for 800
Delete tProjectNoteUser
From tProjectNote pn 
Where tProjectNoteUser.ProjectNoteKey = pn.ProjectNoteKey
And pn.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tProjectNote'

-- Added for 800
Delete tProjectNote Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tTime_DELETED'

Delete tTime_DELETED from tUser Where tTime_DELETED.UserKey = tUser.UserKey and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey)
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tTime_DELETED'

Delete tTimeSheet_DELETED from tUser Where tTimeSheet_DELETED.UserKey = tUser.UserKey and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey)
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tTime'

Delete tTime from tUser Where tTime.UserKey = tUser.UserKey and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey)
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tTimeSheet'

Delete tTimeSheet Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tTimelineSegment'

Delete tTimelineSegment Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tExpenseReceipt'

Delete tExpenseReceipt from tExpenseEnvelope Where tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey and 
	tExpenseEnvelope.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tExpenseEnvelope'

Delete tExpenseEnvelope Where tExpenseEnvelope.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tMiscCost'

Delete tMiscCost from tProject Where tMiscCost.ProjectKey = tProject.ProjectKey and tProject.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'spCF_tObjectFieldSetDelete'
If @DeleteSetupTables = 1
BEGIN

Select @CurKey = 0
While 1 = 1
Begin
	Select @CurKey = Min(FormKey) from tForm Where FormKey > @CurKey and CompanyKey = @CompanyKey
	if @CurKey IS NULL
		Break
	Select @OFSKey = CustomFieldKey from tForm Where FormKey = @CurKey
	exec spCF_tObjectFieldSetDelete @OFSKey

	if	@@error != 0
	begin
		--rollback tran
		return -1
	end

End
END

Select 'tApprovalItemReply'

Delete tApprovalItemReply from tApprovalItem, tApproval, tProject Where tApprovalItemReply.ApprovalItemKey = tApprovalItem.ApprovalItemKey and
	tApprovalItem.ApprovalKey = tApproval.ApprovalKey and tApproval.ProjectKey = tProject.ProjectKey and tProject.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tApprovalItem'

Delete tApprovalItem from tApproval, tProject Where tApprovalItem.ApprovalKey = tApproval.ApprovalKey and tApproval.ProjectKey = tProject.ProjectKey and tProject.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tApprovalList'

Delete tApprovalList from tApproval, tProject Where tApprovalList.ApprovalKey = tApproval.ApprovalKey and tApproval.ProjectKey = tProject.ProjectKey and
	tProject.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tApprovalUpdateList'

-- Added for 800
Delete tApprovalUpdateList from tApproval, tProject Where tApprovalUpdateList.ApprovalKey = tApproval.ApprovalKey and tApproval.ProjectKey = tProject.ProjectKey and
	tProject.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tReviewComment'
Delete tReviewCommentMarkup
FROM tReviewComment, tReviewRound, tReviewDeliverable, tProject
WHERE tReviewDeliverable.ProjectKey = tProject.ProjectKey 
And tProject.CompanyKey = @CompanyKey
and tReviewRound.ReviewDeliverableKey = tReviewDeliverable.ReviewDeliverableKey
and tReviewRound.ReviewRoundKey = tReviewComment.ReviewRoundKey
and tReviewComment.ReviewCommentKey = tReviewCommentMarkup.ReviewCommentKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tReviewComment'
Delete tReviewComment
FROM tReviewRound, tReviewDeliverable, tProject
WHERE tReviewDeliverable.ProjectKey = tProject.ProjectKey 
And tProject.CompanyKey = @CompanyKey
and tReviewRound.ReviewDeliverableKey = tReviewDeliverable.ReviewDeliverableKey
and tReviewRound.ReviewRoundKey = tReviewComment.ReviewRoundKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tReviewRoundFile'
Delete tReviewRoundFile
FROM tReviewRound, tReviewDeliverable, tProject
WHERE tReviewDeliverable.ProjectKey = tProject.ProjectKey 
And tProject.CompanyKey = @CompanyKey
and tReviewRound.ReviewDeliverableKey = tReviewDeliverable.ReviewDeliverableKey
and tReviewRound.ReviewRoundKey = tReviewRoundFile.ReviewRoundKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tReviewRound'
Delete tReviewRound
FROM tReviewDeliverable, tProject
WHERE tReviewDeliverable.ProjectKey = tProject.ProjectKey 
And tProject.CompanyKey = @CompanyKey
and tReviewRound.ReviewDeliverableKey = tReviewDeliverable.ReviewDeliverableKey
if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tReviewLog'
Delete tReviewLog
FROM tReviewDeliverable, tProject
WHERE tReviewDeliverable.ProjectKey = tProject.ProjectKey 
And tProject.CompanyKey = @CompanyKey
and tReviewLog.ReviewDeliverableKey = tReviewDeliverable.ReviewDeliverableKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tReviewDeliverable'
Delete tReviewDeliverable
FROM tProject
WHERE tReviewDeliverable.ProjectKey = tProject.ProjectKey 
And tProject.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end



Select 'tApproval'

Delete tApproval from tProject Where tApproval.ProjectKey = tProject.ProjectKey and tProject.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tApprovalStepUserDef'
If @DeleteSetupTables = 1
delete tApprovalStepUserDef from tApprovalStepDef asd where tApprovalStepUserDef.ApprovalStepDefKey = asd.ApprovalStepDefKey and asd.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tApprovalStepUser'
If @DeleteSetupTables = 1
delete tApprovalStepUser from tApprovalStep aps where tApprovalStepUser.ApprovalStepKey = aps.ApprovalStepKey and aps.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tApprovalStepDefNotify'
If @DeleteSetupTables = 1
delete tApprovalStepDefNotify 
from tApprovalStepDef 
where tApprovalStepDef.CompanyKey = @CompanyKey
and tApprovalStepDefNotify.ApprovalStepDefKey = tApprovalStepDef.ApprovalStepDefKey 
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tApprovalStepDef'
If @DeleteSetupTables = 1
delete tApprovalStepDef where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tApprovalStepNotify'
If @DeleteSetupTables = 1
delete tApprovalStepNotify 
from tApprovalStep 
where tApprovalStep.CompanyKey = @CompanyKey
and tApprovalStepNotify.ApprovalStepKey = tApprovalStep.ApprovalStepKey 
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tApprovalStep'
If @DeleteSetupTables = 1

delete tReviewComment Where ApprovalStepKey in (select ApprovalStepKey from tApprovalStep (nolock) where CompanyKey = @CompanyKey)


delete tApprovalStep where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tApprovalType'
If @DeleteSetupTables = 1
delete tApprovalType where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tActivationLog'
If @DeleteSetupTables = 1
delete tActivationLog from tUser u where tActivationLog.UserKey = u.UserKey and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCalendarType'
If @DeleteSetupTables = 1
delete tCalendarType where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCalendarUser'
delete tCalendarUser from tUser u where tCalendarUser.UserKey = u.UserKey and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCalendarLink'

delete tCalendarLink
FROM   tCalendar c 
where  tCalendarLink.CalendarKey = c.CalendarKey 
and    c.CompanyKey = @CompanyKey 

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCalendarReminder'

delete tCalendarReminder
FROM   tUser u 
where  tCalendarReminder.UserKey = u.UserKey 
and    isnull(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey 

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCalendarUpdateLog'

delete tCalendarUpdateLog
FROM   tCalendar c 
where  tCalendarUpdateLog.CalendarKey = c.CalendarKey 
and    c.CompanyKey = @CompanyKey 

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCMFolderIncludeInSync'
	
delete tCMFolderIncludeInSync
FROM  tCMFolder f
WHERE tCMFolderIncludeInSync.CMFolderKey = f.CMFolderKey
and   f.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCMFolderSecurity'
	
delete tCMFolderSecurity
FROM  tCMFolder f
WHERE tCMFolderSecurity.CMFolderKey = f.CMFolderKey
and   f.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end
		
Select 'tCampaignBudgetItem'

-- Added for 800
If @DeleteSetupTables = 1
delete tCampaignBudgetItem
from tCampaign c (NOLOCK)
where tCampaignBudgetItem.CampaignKey = c.CampaignKey
and c.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCampaignBudget'

-- Added for 800
If @DeleteSetupTables = 1
delete tCampaignBudget
from tCampaign c (NOLOCK)
where tCampaignBudget.CampaignKey = c.CampaignKey
and c.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCheckFormat'
If @DeleteSetupTables = 1
delete tCheckFormat where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCheckMethod'
If @DeleteSetupTables = 1
delete tCheckMethod where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tClass'
If @DeleteSetupTables = 1
delete tClass where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tContactDatabaseAssignment'
If @DeleteSetupTables = 1
delete tContactDatabaseAssignment from tContactDatabase cd where tContactDatabaseAssignment.ContactDatabaseKey = cd.ContactDatabaseKey and cd.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tContactDatabaseUser'
If @DeleteSetupTables = 1
delete tContactDatabaseUser from tContactDatabase cd where tContactDatabaseUser.ContactDatabaseKey = cd.ContactDatabaseKey and cd.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tContactDatabase'
If @DeleteSetupTables = 1
delete tContactDatabase where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDAFileRight'

delete tDAFileRight from tDAFile f, tDAFolder fol, tProject p where tDAFileRight.FileKey = f.FileKey and f.FolderKey = fol.FolderKey and fol.ProjectKey = p.ProjectKey and p.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDAFileVersion'

delete tDAFileVersion from tDAFile f, tDAFolder fol, tProject p where tDAFileVersion.FileKey = f.FileKey and f.FolderKey = fol.FolderKey and fol.ProjectKey = p.ProjectKey and p.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDAFolderRight'

delete tDAFolderRight from tDAFolder fol, tProject p where tDAFolderRight.FolderKey = fol.FolderKey and fol.ProjectKey = p.ProjectKey and p.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDAFile'

delete tDAFile from tDAFolder fol, tProject p where tDAFile.FolderKey = fol.FolderKey and fol.ProjectKey = p.ProjectKey and p.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDAFolder'

delete tDAFolder from tProject p where tDAFolder.ProjectKey = p.ProjectKey and p.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDAClientFolder'

delete tDAClientFolder from tProject p where tDAClientFolder.ProjectKey = p.ProjectKey and p.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDashboardGroup'
If @DeleteSetupTables = 1
delete tDashboardGroup from tDashboard d where tDashboardGroup.DashboardKey = d.DashboardKey and d.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDashboardModuleUser'

-- Moved for 800 (FK violation)
If @DeleteSetupTables = 1
delete tDashboardModuleUser from tUser u where tDashboardModuleUser.UserKey = u.UserKey and u.OwnerCompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

If @DeleteSetupTables = 1
delete tDashboardModuleUser from tUser u where tDashboardModuleUser.UserKey = u.UserKey and u.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

If @DeleteSetupTables = 1
delete tDashboardModuleUser 
where tDashboardModuleUser.UserKey NOT IN (SELECT UserKey FROM tUser)
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDashboardModule'
If @DeleteSetupTables = 1
delete tDashboardModule from tDashboard d where tDashboardModule.DashboardKey = d.DashboardKey and d.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDashboard'
If @DeleteSetupTables = 1
delete tDashboard where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDeposit'
If @DeleteSetupTables = 1
delete tDeposit where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tItemRateSheetDetail'

-- Added for 800 
If @DeleteSetupTables = 1
Delete tItemRateSheetDetail 
from tItemRateSheet 
Where tItemRateSheetDetail.ItemRateSheetKey = tItemRateSheet.ItemRateSheetKey 
and tItemRateSheet.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

-- Added for 800 
Select 'tItemRateSheet'
If @DeleteSetupTables = 1
Delete tItemRateSheet where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tItem'
If @DeleteSetupTables = 1
Delete tItem where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tJournalEntryDetail'

Delete tJournalEntryDetail from tJournalEntry je where tJournalEntryDetail.JournalEntryKey = je.JournalEntryKey and je.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tJournalEntry'

Delete tJournalEntry where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLaborBudgetDetail'
If @DeleteSetupTables = 1
Delete tLaborBudgetDetail from tLaborBudget lb where tLaborBudgetDetail.LaborBudgetKey = lb.LaborBudgetKey and lb.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLaborBudget'
If @DeleteSetupTables = 1
Delete tLaborBudget where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tNote'
If @DeleteSetupTables = 1
Delete tNote from tNoteGroup ng where tNote.NoteGroupKey = ng.NoteGroupKey and ng.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tNoteGroup'
If @DeleteSetupTables = 1
Delete tNoteGroup where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tOffice'
If @DeleteSetupTables = 1
Delete tOffice where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tPaymentDetail'

Delete tPaymentDetail from tPayment p where tPaymentDetail.PaymentKey = p.PaymentKey and p.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tPayment'

Delete tPayment where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tProjectCreativeBrief'

Delete tProjectCreativeBrief from tProject p where tProjectCreativeBrief.ProjectKey = p.ProjectKey and p.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tRequestDefSpec'

Delete tRequestDefSpec from tRequestDef rd where tRequestDefSpec.RequestDefKey = rd.RequestDefKey and rd.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tRequest'

Delete tRequest where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tRequestDef'

Delete tRequestDef where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tStandardText'
If @DeleteSetupTables = 1
Delete tStandardText where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tStandardText'
If @DeleteSetupTables = 1
Delete tStandardActivity where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSyncActivity'
Delete tSyncActivity
FROM   tCompany c
where  tSyncActivity.CompanyKey = c.CompanyKey
and    isnull(c.OwnerCompanyKey, c.CompanyKey) = @CompanyKey	
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSyncFolder'
Delete tSyncFolder
FROM   tCompany c
where  tSyncFolder.CompanyKey = c.CompanyKey
and    isnull(c.OwnerCompanyKey, c.CompanyKey) = @CompanyKey	
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSyncItem'
Delete tSyncItem
FROM   tCompany c
where  tSyncItem.CompanyKey = c.CompanyKey
and    isnull(c.OwnerCompanyKey, c.CompanyKey) = @CompanyKey	
if	@@error != 0
begin
	--rollback tran
	return -1
end
	
Select 'tTransaction'

Delete tTransaction where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tTransactionUnpostLog'

Delete tTransactionUnpostLog where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tTransactionUnpost'

Delete tTransactionUnpost where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tTransactionOrderAccrual'

Delete tTransactionOrderAccrual where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCashTransaction'

Delete tCashTransaction where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCashTransactionLine'

Delete tCashTransactionLine where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tUserGroup'
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tUserGroup where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tUserPassword'

-- Added for 800
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tUserPassword from tUser u where tUserPassword.UserKey = u.UserKey and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tUserNotification'
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tUserNotification from tUser u where tUserNotification.UserKey = u.UserKey and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tUserPreference'
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tUserPreference from tUser u where tUserPreference.UserKey = u.UserKey and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tUserService'
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tUserService from tUser u where tUserService.UserKey = u.UserKey and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tWIPPostingDetail'

-- Added for 800
Delete tWIPPostingDetail 
From tWIPPosting w
where w.CompanyKey = @CompanyKey
And tWIPPostingDetail.WIPPostingKey = w.WIPPostingKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tWIPPosting'

Delete tWIPPosting where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tBillingDetail'

-- Added for 82
Delete tBillingDetail 
From tBilling b
where b.CompanyKey = @CompanyKey
And tBillingDetail.BillingKey = b.BillingKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tBillingFixedFee'

-- Added for 82
Delete tBillingFixedFee 
From tBilling b
where b.CompanyKey = @CompanyKey
And tBillingFixedFee.BillingKey = b.BillingKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tBillingPayment'

-- Added for 82
Delete tBillingPayment 
From tBilling b
where b.CompanyKey = @CompanyKey
And tBillingPayment.BillingKey = b.BillingKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tBilling'

Delete tBilling where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tBillingSchedule'

-- Added for 82
Delete tBillingSchedule 
From tProject p
where p.CompanyKey = @CompanyKey
And tBillingSchedule.ProjectKey = p.ProjectKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tWriteOffReason'
If @DeleteSetupTables = 1
Delete tWriteOffReason where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tFormSubscription'

-- Moved for 800 (FK violation)
If @DeleteSetupTables = 1
Delete tFormSubscription from tUser Where tFormSubscription.UserKey = tUser.UserKey and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey)
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tForm'
If @DeleteSetupTables = 1
Delete tForm Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tFormDef'
If @DeleteSetupTables = 1
Delete tFormDef Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCompanyMediaContact'

-- Added for 800
If @DeleteSetupTables = 1
Delete tCompanyMediaContact 
From tCompanyMedia cm (nolock)
Where cm.CompanyKey = @CompanyKey
And tCompanyMediaContact.CompanyMediaKey = cm.CompanyMediaKey 
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCompanyMedia'

-- Added for 800
If @DeleteSetupTables = 1
Delete tCompanyMedia Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tMediaEstimate'

-- Added for 800
If @DeleteSetupTables = 1
Delete tMediaEstimate Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tPurchaseOrderUser'

-- Added for 800
Delete tPurchaseOrderUser from tPurchaseOrder Where tPurchaseOrderUser.PurchaseOrderKey = tPurchaseOrder.PurchaseOrderKey and
	tPurchaseOrder.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tPurchaseOrderTraffic'

-- Added for 800
Delete tPurchaseOrderTraffic from tPurchaseOrder Where tPurchaseOrderTraffic.PurchaseOrderKey = tPurchaseOrder.PurchaseOrderKey and
	tPurchaseOrder.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tPurchaseOrderDetail'

-- Still need to loop to take care of custom fields ? do in ASP
Delete tPurchaseOrderDetail from tPurchaseOrder Where tPurchaseOrderDetail.PurchaseOrderKey = tPurchaseOrder.PurchaseOrderKey and
	tPurchaseOrder.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tPurchaseOrder'

Delete tPurchaseOrder Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tQuoteReplyDetail'

Delete tQuoteReplyDetail from tQuoteReply, tQuote Where tQuoteReplyDetail.QuoteReplyKey = tQuoteReply.QuoteReplyKey and
	tQuoteReply.QuoteKey = tQuote.QuoteKey and tQuote.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tQuoteReply'

Delete tQuoteReply from tQuote Where tQuoteReply.QuoteKey = tQuote.QuoteKey and tQuote.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tQuoteDetail'

Delete tQuoteDetail from tQuote Where tQuoteDetail.QuoteKey = tQuote.QuoteKey and tQuote.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tQuote'

Delete tQuote Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tInvoiceAdvanceBill'

Delete tInvoiceAdvanceBill from tInvoice i where tInvoiceAdvanceBill.InvoiceKey = i.InvoiceKey and i.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tInvoiceAdvanceBillTax'

Delete tInvoiceAdvanceBillTax from tInvoice i where tInvoiceAdvanceBillTax.InvoiceKey = i.InvoiceKey and i.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tInvoiceAdvanceBillSale'

Delete tInvoiceAdvanceBillSale from tInvoice i where tInvoiceAdvanceBillSale.InvoiceKey = i.InvoiceKey and i.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tInvoiceTemplate'
If @DeleteSetupTables = 1
Delete tInvoiceTemplate where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCheckAppl'

Delete tCheckAppl from tInvoice Where tCheckAppl.InvoiceKey = tInvoice.InvoiceKey and tInvoice.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCheckAppl'

Delete tCheckAppl from tCheck c, tCompany com where tCheckAppl.CheckKey = c.CheckKey and  c.ClientKey = com.CompanyKey and com.OwnerCompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tCheck'

Delete tCheck from tCompany Where tCheck.ClientKey = tCompany.CompanyKey and tCompany.OwnerCompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tInvoiceLineTax'

-- Added for 800
Delete tInvoiceLineTax 
from tInvoice (nolock)
	,tInvoiceLine (nolock)
Where tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey and tInvoice.CompanyKey = @CompanyKey
and tInvoiceLineTax.InvoiceLineKey = tInvoiceLine.InvoiceLineKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tInvoiceLine'

Delete tInvoiceLine from tInvoice Where tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey and tInvoice.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tInvoiceLine'

Delete tInvoiceTax from tInvoice Where tInvoiceTax.InvoiceKey = tInvoice.InvoiceKey and tInvoice.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end
Select 'tInvoice'

Delete tInvoice Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tTimeRateSheetDetail'
If @DeleteSetupTables = 1
Delete tTimeRateSheetDetail 
from tTimeRateSheet 
Where tTimeRateSheetDetail.TimeRateSheetKey = tTimeRateSheet.TimeRateSheetKey 
and tTimeRateSheet.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tTimeRateSheet'
If @DeleteSetupTables = 1
Delete tTimeRateSheet Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tVoucherDetailTax'

Delete tVoucherDetailTax Where VoucherDetailKey in (Select tVoucherDetail.VoucherDetailKey 
from tVoucherDetail, tVoucher
Where tVoucher.CompanyKey = @CompanyKey
And tVoucher.VoucherKey = tVoucherDetail.VoucherKey)
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tVoucherDetail'

Delete tVoucherDetail Where VoucherKey in (Select VoucherKey from tVoucher Where CompanyKey = @CompanyKey)
if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tVoucherTax'

Delete tVoucherTax Where VoucherKey in (Select VoucherKey from tVoucher Where CompanyKey = @CompanyKey)
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tVoucherCC'

Delete tVoucherCC
from   tVoucher
Where  tVoucher.CompanyKey = @CompanyKey
and    tVoucher.VoucherKey = tVoucherCC.VoucherKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tVoucherCredit'

Delete tVoucherCredit
from   tVoucher
Where  tVoucher.CompanyKey = @CompanyKey
and    tVoucher.VoucherKey = tVoucherCredit.VoucherKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tVoucher'

Delete tVoucher Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tWorkType'
If @DeleteSetupTables = 1
Delete tWorkType Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tEstimateTemplate'
If @DeleteSetupTables = 1
Delete tEstimateTemplate where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tEstimateProject'
Delete tEstimateProject 
from tEstimate e
where tEstimateProject.EstimateKey = e.EstimateKey 
and e.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tEstimateTaskTemp'
Delete tEstimateTaskTemp
from tProject p
where tEstimateTaskTemp.ProjectKey = p.ProjectKey 
and p.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tEstimateTaskTempPredecessor'
Delete tEstimateTaskTempPredecessor
from tProject p, tTask t
where tEstimateTaskTempPredecessor.TaskKey = t.TaskKey
and t.ProjectKey = p.ProjectKey 
and p.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tEstimateTaskTempUser'
Delete tEstimateTaskTempUser
from tProject p, tTask t
where tEstimateTaskTempUser.TaskKey = t.TaskKey
and t.ProjectKey = p.ProjectKey 
and p.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tEstimateTaskExpense'
Delete tEstimateTaskExpense 
from tEstimate e
where tEstimateTaskExpense.EstimateKey = e.EstimateKey 
and e.CompanyKey = @CompanyKey
and e.ProjectKey is null
if	@@error != 0
begin
	--rollback tran
	return -1
end

Delete tEstimateTaskExpense 
from tEstimate e
, tProject p 
where tEstimateTaskExpense.EstimateKey = e.EstimateKey 
and e.ProjectKey = p.ProjectKey 
and e.CompanyKey = @CompanyKey
and isnull(p.Template, 0) = 0
if	@@error != 0
begin
	--rollback tran
	return -1
end

if @DeleteTemplateProjects = 1
begin
	Delete tEstimateTaskExpense 
	from tEstimate e
	, tProject p 
	where tEstimateTaskExpense.EstimateKey = e.EstimateKey 
	and e.ProjectKey = p.ProjectKey 
	and e.CompanyKey = @CompanyKey
	and isnull(p.Template, 0) = 1
	if	@@error != 0
	begin
		--rollback tran
		return -1
	end
end

Select 'tEstimateTaskLabor'

Delete tEstimateTaskLabor 
from tEstimate e
where tEstimateTaskLabor.EstimateKey = e.EstimateKey 
and e.CompanyKey = @CompanyKey
and e.ProjectKey is null 
if	@@error != 0
begin
	--rollback tran
	return -1
end

Delete tEstimateTaskLabor 
from tEstimate e
, tProject p 
where tEstimateTaskLabor.EstimateKey = e.EstimateKey 
and e.ProjectKey = p.ProjectKey 
and e.CompanyKey = @CompanyKey
and isnull(p.Template, 0) = 0
if	@@error != 0
begin
	--rollback tran
	return -1
end

If @DeleteTemplateProjects = 1
begin
	Delete tEstimateTaskLabor 
	from tEstimate e
	, tProject p 
	where tEstimateTaskLabor.EstimateKey = e.EstimateKey 
	and e.ProjectKey = p.ProjectKey 
	and e.CompanyKey = @CompanyKey
	and isnull(p.Template, 0) = 1
	if	@@error != 0
	begin
		--rollback tran
		return -1
	end
end

Select 'tEstimateUser'

Delete tEstimateUser 
from tEstimate e
where tEstimateUser.EstimateKey = e.EstimateKey 
and e.CompanyKey = @CompanyKey
and e.ProjectKey is null 
if	@@error != 0
begin
	--rollback tran
	return -1
end

Delete tEstimateUser 
from tEstimate e
, tProject p 
where tEstimateUser.EstimateKey = e.EstimateKey 
and e.CompanyKey = @CompanyKey
and e.ProjectKey = p.ProjectKey 
and isnull(p.Template, 0) = 0
if	@@error != 0
begin
	--rollback tran
	return -1
end

if @DeleteTemplateProjects = 1
begin
	Delete tEstimateUser 
	from tEstimate e
	, tProject p 
	where tEstimateUser.EstimateKey = e.EstimateKey 
	and e.CompanyKey = @CompanyKey
	and e.ProjectKey = p.ProjectKey 
	and isnull(p.Template, 0) = 1
	if	@@error != 0
	begin
		--rollback tran
		return -1
	end
end 

Select 'tEstimateTask'

Delete tEstimateTask 
from tEstimate
Where tEstimateTask.EstimateKey = tEstimate.EstimateKey 
and tEstimate.ProjectKey IS NULL 
and tEstimate.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Delete tEstimateTask 
from tEstimate
, tProject 
Where tEstimateTask.EstimateKey = tEstimate.EstimateKey 
and tEstimate.ProjectKey = tProject.ProjectKey 
and tEstimate.CompanyKey = @CompanyKey
and isnull(tProject.Template, 0) = 0
if	@@error != 0
begin
	--rollback tran
	return -1
end

if @DeleteTemplateProjects = 1
begin
	Delete tEstimateTask 
	from tEstimate
	, tProject 
	Where tEstimateTask.EstimateKey = tEstimate.EstimateKey 
	and tEstimate.ProjectKey = tProject.ProjectKey 
	and tEstimate.CompanyKey = @CompanyKey
	and isnull(tProject.Template, 0) = 1
	if	@@error != 0
	begin
		--rollback tran
		return -1
	end
end

Select 'tEstimateNotify'

-- Added for 800
Delete tEstimateNotify 
from tEstimate
Where tEstimateNotify.EstimateKey = tEstimate.EstimateKey 
and tEstimate.ProjectKey is null 
and tEstimate.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Delete tEstimateNotify 
from tEstimate
, tProject 
Where tEstimateNotify.EstimateKey = tEstimate.EstimateKey 
and tEstimate.ProjectKey = tProject.ProjectKey 
and tEstimate.CompanyKey = @CompanyKey
and isnull(tProject.Template, 0) = 0
if	@@error != 0
begin
	--rollback tran
	return -1
end

if @DeleteTemplateProjects = 1
begin
	Delete tEstimateNotify 
	from tEstimate
	, tProject 
	Where tEstimateNotify.EstimateKey = tEstimate.EstimateKey 
	and tEstimate.ProjectKey = tProject.ProjectKey 
	and tEstimate.CompanyKey = @CompanyKey
	and isnull(tProject.Template, 0) = 1
	if	@@error != 0
	begin
		--rollback tran
		return -1
	end
end

Select 'tEstimateService'

-- Added for 800
Delete tEstimateService 
from tEstimate
Where tEstimateService.EstimateKey = tEstimate.EstimateKey 
and tEstimate.ProjectKey is null 
and tEstimate.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end


Delete tEstimateService 
from tEstimate, tProject 
Where tEstimateService.EstimateKey = tEstimate.EstimateKey 
and tEstimate.ProjectKey = tProject.ProjectKey 
and tEstimate.CompanyKey = @CompanyKey
and isnull(tProject.Template, 0) = 0
if	@@error != 0
begin
	--rollback tran
	return -1
end

if @DeleteTemplateProjects = 1
begin
	Delete tEstimateService 
	from tEstimate, tProject 
	Where tEstimateService.EstimateKey = tEstimate.EstimateKey 
	and tEstimate.ProjectKey = tProject.ProjectKey 
	and tEstimate.CompanyKey = @CompanyKey
	and isnull(tProject.Template, 0) = 1
	if	@@error != 0
	begin
		--rollback tran
		return -1
	end
end

Select 'tEstimateTaskAssignmentLabor'

-- Added for 800
Delete tEstimateTaskAssignmentLabor 
from tEstimate
Where tEstimateTaskAssignmentLabor.EstimateKey = tEstimate.EstimateKey 
and tEstimate.ProjectKey is null 
and tEstimate.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Delete tEstimateTaskAssignmentLabor 
from tEstimate
, tProject 
Where tEstimateTaskAssignmentLabor.EstimateKey = tEstimate.EstimateKey 
and tEstimate.ProjectKey = tProject.ProjectKey 
and tEstimate.CompanyKey = @CompanyKey
and isnull(tProject.Template, 0) = 0
if	@@error != 0
begin
	--rollback tran
	return -1
end

if @DeleteTemplateProjects = 1
begin
	Delete tEstimateTaskAssignmentLabor 
	from tEstimate
	, tProject 
	Where tEstimateTaskAssignmentLabor.EstimateKey = tEstimate.EstimateKey 
	and tEstimate.ProjectKey = tProject.ProjectKey 
	and tEstimate.CompanyKey = @CompanyKey
	and isnull(tProject.Template, 0) = 1
	if	@@error != 0
	begin
		--rollback tran
		return -1
	end
end

Select 'tEstimate'

Delete tEstimate 
Where tEstimate.ProjectKey is null 
and tEstimate.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Delete tEstimate 
from tProject 
Where tEstimate.ProjectKey = tProject.ProjectKey 
and tEstimate.CompanyKey = @CompanyKey
and isnull(tProject.Template, 0) = 0
if	@@error != 0
begin
	--rollback tran
	return -1
end

if @DeleteTemplateProjects = 1
begin
	Delete tEstimate 
	from tProject 
	Where tEstimate.ProjectKey = tProject.ProjectKey 
	and tEstimate.CompanyKey = @CompanyKey
	and isnull(tProject.Template, 0) = 1
	if	@@error != 0
	begin
		--rollback tran
		return -1
	end
end

Select 'tFormTemplate'

if @DeleteSetupTables = 1
delete tFormTemplate where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLabBeta'

if @DeleteSetupTables = 1
delete tLabBeta where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLabBeta'

if @DeleteSetupTables = 1
delete tLabCompany where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tMobileSearchCondition'
If @DeleteSetupTables = 1
delete tMobileSearchCondition
from  tMobileSearch
where tMobileSearchCondition.MobileSearchKey = tMobileSearch.MobileSearchKey
and   tMobileSearch.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tMobileSearch'
If @DeleteSetupTables = 1
delete tMobileSearch where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tTaskPredecessor'

Delete tTaskPredecessor 
from tTask
, tProject 
Where tTaskPredecessor.TaskKey = tTask.TaskKey 
and tTask.ProjectKey = tProject.ProjectKey 
and tProject.CompanyKey = @CompanyKey
and isnull(tProject.Template, 0) = 0
if	@@error != 0
begin
	--rollback tran
	return -1
end

If @DeleteTemplateProjects = 1
begin
	Delete tTaskPredecessor 
	from tTask
	, tProject 
	Where tTaskPredecessor.TaskKey = tTask.TaskKey 
	and tTask.ProjectKey = tProject.ProjectKey 
	and tProject.CompanyKey = @CompanyKey
	and isnull(tProject.Template, 0) = 1
	if	@@error != 0
	begin
		--rollback tran
		return -1
	end
end

Select 'tTask'

Delete tTask 
from tProject 
Where tTask.ProjectKey = tProject.ProjectKey 
and tProject.CompanyKey = @CompanyKey
and isnull(tProject.Template, 0) = 0
if	@@error != 0
begin
	--rollback tran
	return -1
end

If @DeleteTemplateProjects = 1
begin
	Delete tTask 
	from tProject 
	Where tTask.ProjectKey = tProject.ProjectKey 
	and tProject.CompanyKey = @CompanyKey
	and isnull(tProject.Template, 0) = 1
	if	@@error != 0
	begin
		--rollback tran
		return -1
	end
end

Select 'tTaskAssignmentTypeService'

-- Added for 800
If @DeleteSetupTables = 1
Delete tTaskAssignmentTypeService
From tTaskAssignmentType  
Where tTaskAssignmentType.CompanyKey = @CompanyKey
And tTaskAssignmentTypeService.TaskAssignmentTypeKey = tTaskAssignmentType.TaskAssignmentTypeKey 
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tTaskAssignmentType'

-- Added for 800
If @DeleteSetupTables = 1
Delete tTaskAssignmentType  Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tMasterTask'

-- Added for 800
If @DeleteSetupTables = 1
Delete tMasterTask  Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tAssignment'

Delete tAssignment 
from tProject Where tAssignment.ProjectKey = tProject.ProjectKey 
and tProject.CompanyKey = @CompanyKey
and isnull(tProject.Template, 0) = 0
if	@@error != 0
begin
	--rollback tran
	return -1
end

If @DeleteTemplateProjects = 1
begin
	Delete tAssignment 
	from tProject Where tAssignment.ProjectKey = tProject.ProjectKey 
	and tProject.CompanyKey = @CompanyKey
	and isnull(tProject.Template, 0) = 1
	if	@@error != 0
	begin
		--rollback tran
		return -1
	end
end

Select 'tRptSecurityGroup'
If @DeleteSetupTables = 1
Delete tRptSecurityGroup from tSecurityGroup Where tRptSecurityGroup.SecurityGroupKey = tSecurityGroup.SecurityGroupKey and
	tSecurityGroup.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tRightAssigned'
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tRightAssigned from tSecurityGroup Where tRightAssigned.EntityKey = tSecurityGroup.SecurityGroupKey and
	tSecurityGroup.CompanyKey = @CompanyKey and tRightAssigned.EntityType = 'Security Group'
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tUser'
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Update	tUser 
set		SecurityGroupKey = NULL
from	tSecurityGroup sg
where	tUser.SecurityGroupKey = sg.SecurityGroupKey
and		sg.CompanyKey = @CompanyKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSecurityGroup'
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tSecurityGroup Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCalendarAttendeeGroup'

-- Added for 800
Delete tCalendarAttendeeGroup from tCalendar Where tCalendarAttendeeGroup.CalendarKey = tCalendar.CalendarKey and tCalendar.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Delete tCalendarAttendeeGroup
Where CalendarKey NOT IN (SELECT CalendarKey FROM tCalendar)
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDistributionGroupUser'

-- Added for 800
If @DeleteSetupTables = 1
Delete tDistributionGroupUser
From   tDistributionGroup dg 
Where dg.CompanyKey = @CompanyKey
And dg.DistributionGroupKey = tDistributionGroupUser.DistributionGroupKey

if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDistributionGroup'

-- Added for 800
If @DeleteSetupTables = 1
Delete tDistributionGroup Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCalendarAttendee'

Delete tCalendarAttendee from tCalendar Where tCalendarAttendee.CalendarKey = tCalendar.CalendarKey and tCalendar.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCalendarAttendeeUpdateLog'

Delete tCalendarAttendeeUpdateLog from tCalendar 
Where tCalendarAttendeeUpdateLog.CalendarKey = tCalendar.CalendarKey and tCalendar.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCalendar'

Delete tCalendar Where tCalendar.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCBPosting'

-- Added for 800
Delete tCBPosting
From   tProject p (NOLOCK)
Where  tCBPosting.ProjectKey = p.ProjectKey
And    p.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCBBatchAdjustment'

-- Added for 800
Delete  tCBBatchAdjustment
From    tCBBatch b (NOLOCK)
Where   tCBBatchAdjustment.BatchKey = b.CBBatchKey
And     b.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCBBatch'

-- Added for 800
Delete  tCBBatch 
Where   CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCBCodePercent'

-- Added for 800
Delete tCBCodePercent
From   tCBCode b (NOLOCK)
Where  tCBCodePercent.CBCodeKey = b.CBCodeKey
And    b.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCBCode'

-- Added for 800
If @DeleteSetupTables = 1
Delete  tCBCode 
Where   CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tMediaMarket'

-- Added for 800
If @DeleteSetupTables = 1
Delete tMediaMarket
Where   CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tUserSkill'
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tUserSkill from tUser Where tUserSkill.UserKey = tUser.UserKey and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey)
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tUserSkillSpecialty'
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tUserSkillSpecialty from tUser Where tUserSkillSpecialty.UserKey = tUser.UserKey and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey)
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSkillSpecialty'
If @DeleteSetupTables = 1
Delete tSkillSpecialty from tSkill Where tSkillSpecialty.SkillKey = tSkill.SkillKey and tSkill.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSkill'
If @DeleteSetupTables = 1
Delete tSkill Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tGLBudgetDetail'
If @DeleteSetupTables = 1
Delete tGLBudgetDetail from tGLAccount gla where tGLBudgetDetail.GLAccountKey = gla.GLAccountKey and gla.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tGLBudget'
If @DeleteSetupTables = 1
Delete tGLBudget where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tGLAccountRecDetail'

Delete tGLAccountRecDetail from tGLAccountRec glar where tGLAccountRecDetail.GLAccountRecKey = glar.GLAccountRecKey and glar.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tGLAccountUser'

Delete tGLAccountUser from tGLAccount gla where tGLAccountUser.GLAccountKey = gla.GLAccountKey and gla.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tGLAccountRec'

Delete tGLAccountRec where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tDepartment'
If @DeleteSetupTables = 1
Delete tDepartment Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tGLAccount'
If @DeleteSetupTables = 1
Delete tGLAccount Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLayoutItems'
If @DeleteSetupTables = 1
Delete tLayoutItems 
From tLayoutReport
,tLayout
Where tLayout.CompanyKey = @CompanyKey
and   tLayout.LayoutKey = tLayoutReport.LayoutKey
and   tLayoutReport.LayoutReportKey = tLayoutItems.LayoutReportKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLayoutSection'
If @DeleteSetupTables = 1
Delete tLayoutSection 
From tLayoutReport
,tLayout
Where tLayout.CompanyKey = @CompanyKey
and   tLayout.LayoutKey = tLayoutReport.LayoutKey
and   tLayoutReport.LayoutReportKey = tLayoutSection.LayoutReportKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLayoutReport'
If @DeleteSetupTables = 1
Delete tLayoutReport
from tLayout
Where tLayout.CompanyKey = @CompanyKey
and   tLayout.LayoutKey = tLayoutReport.LayoutKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLayoutBilling'
If @DeleteSetupTables = 1
Delete tLayoutBilling
from tLayout
Where tLayout.CompanyKey = @CompanyKey
and   tLayout.LayoutKey = tLayoutBilling.LayoutKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLayout'
If @DeleteSetupTables = 1
Delete tLayout
Where tLayout.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tContactActivity'
If @DeleteSetupTables = 1
Delete tContactActivity Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLeadUser'

Delete tLeadUser 
FROM tLead l 
where tLeadUser.LeadKey = l.LeadKey 
and l.CompanyKey = @CompanyKey
	
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLead'

Delete tLead Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLeadOutcome'
If @DeleteSetupTables = 1
Delete tLeadOutcome Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLeadStageHistory'
Delete tLeadStageHistory 
From   tLeadStage ls
Where  tLeadStageHistory.LeadStageKey = ls.LeadStageKey
and    ls.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLeadStage'
If @DeleteSetupTables = 1
Delete tLeadStage Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLeadStatus'
If @DeleteSetupTables = 1
Delete tLeadStatus Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tLevelHistory : tCompany'
Delete tLevelHistory
FROM tCompany c 
where tLevelHistory.Entity = 'tCompany'
and   tLevelHistory.EntityKey = c.CompanyKey 
and isnull(c.OwnerCompanyKey, c.CompanyKey) = @CompanyKey
	
Select 'tLevelHistory : tLead'
Delete tLevelHistory
FROM tLead l 
where tLevelHistory.Entity = 'tLead'
and   tLevelHistory.EntityKey = l.LeadKey 
and l.CompanyKey = @CompanyKey
	
Select 'tLevelHistory : tUser'
Delete tLevelHistory
FROM tUser u 
where tLevelHistory.Entity = 'tUser'
and   tLevelHistory.EntityKey = u.UserKey 
and isnull(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey
	
Select 'tMailing'
Delete tMailing Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end
	
Select 'tMailingSetup'
If @DeleteSetupTables = 1
Delete tMailingSetup Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tMarketingListListDeleteLog'
Delete tMarketingListListDeleteLog where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tMarketingListList'
Delete tMarketingListList
FROM   tMarketingList b (NOLOCK) 
WHERE  b.CompanyKey = @CompanyKey
AND    tMarketingListList.MarketingListKey = b.MarketingListKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tMarketingList'
If @DeleteSetupTables = 1
Delete tMarketingList Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tMergeContactLog'
Delete tMergeContactLog Where OwnerCompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tExpenseType'
If @DeleteSetupTables = 1
Delete tExpenseType Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end


Select 'tProjectType'
If @DeleteSetupTables = 1
Delete tProjectType Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tProjectStatus'
If @DeleteSetupTables = 1
Delete tProjectStatus Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tProjectBillingStatus'
If @DeleteSetupTables = 1
Delete tProjectBillingStatus Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tPaymentTerms'
If @DeleteSetupTables = 1
Delete tPaymentTerms Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tPurchaseOrderType'
If @DeleteSetupTables = 1
Delete tPurchaseOrderType Where CompanyKey = @CompanyKey  -- Need to loop and take care of field sets and custom fields on POs
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tReport'
If @DeleteSetupTables = 1
Delete tReport Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tReportGroup'
If @DeleteSetupTables = 1
Delete tReportGroup Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tStringCompany'
If @DeleteSetupTables = 1
Delete tStringCompany Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tService'
If @DeleteSetupTables = 1
Delete tService Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSalesTax'
If @DeleteSetupTables = 1
Delete tSalesTax Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

-- Added for 82
Select 'tRetainerItems'
If @DeleteSetupTables = 1
Delete tRetainerItems
From tRetainer 
Where tRetainer.CompanyKey = @CompanyKey
And   tRetainerItems.RetainerKey = tRetainer.RetainerKey
if	@@error != 0
begin
	--rollback tran
	return -1
end


-- Added for 81
Select 'tRetainer'
If @DeleteSetupTables = 1
Delete tRetainer Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

-- Added for 81
Select 'tISCI'

Delete tISCI
From   tProject (NOLOCK)  
Where tISCI.ProjectKey = tProject.ProjectKey
And   tProject.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end


-- Added for 8407
Select 'tProjectRollup'

Delete tProjectRollup
From   tProject (NOLOCK)  
Where tProjectRollup.ProjectKey = tProject.ProjectKey
And   tProject.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tProjectItemRollup'

Delete tProjectItemRollup
From   tProject (NOLOCK)  
Where tProjectItemRollup.ProjectKey = tProject.ProjectKey
And   tProject.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tProject'

Delete tProject Where CompanyKey = @CompanyKey and isnull(Template, 0) = 0
if	@@error != 0
begin
	--rollback tran
	return -1
end

If @DeleteTemplateProjects = 1
begin
	Delete tProject Where CompanyKey = @CompanyKey and isnull(Template, 0) = 1
	if	@@error != 0
	begin
		--rollback tran
		return -1
	end
end

Select 'tRecurTranUser'
Delete tRecurTranUser
From   tRecurTran
Where  tRecurTran.CompanyKey = @CompanyKey
and    tRecurTran.RecurTranKey = tRecurTranUser.RecurTranKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tRecurTran'
Delete tRecurTran Where  tRecurTran.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tClientProduct'

-- Added for 800
If @DeleteSetupTables = 1
Delete tClientProduct
Where  CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tClientDivision'

-- Added for 800
If @DeleteSetupTables = 1
Delete tClientDivision
Where  CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCampaignEstByItem'

If @DeleteSetupTables = 1
delete tCampaignEstByItem
from tCampaign 
where tCampaign.CompanyKey = @CompanyKey
and tCampaign.CampaignKey = tCampaignEstByItem.CampaignKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCampaignRollup'

If @DeleteSetupTables = 1
delete tCampaignRollup
from tCampaign 
where tCampaign.CompanyKey = @CompanyKey
and tCampaign.CampaignKey = tCampaignRollup.CampaignKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

If @DeleteSetupTables = 1
delete tCampaignSegment
from tCampaign 
where tCampaign.CompanyKey = @CompanyKey
and tCampaign.CampaignKey = tCampaignSegment.CampaignKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCampaign'

-- Moved here for 800
If @DeleteSetupTables = 1
delete tCampaign where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tSource'

If @DeleteSetupTables = 1
Delete tSource
Where  CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tAddress'
If @DeleteSetupTables = 1
Delete tAddress Where OwnerCompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tUserLeadUpdateLog'
Delete tUserLeadUpdateLog Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tUserLead'
Delete tUserLead Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tUserRole'
Delete tUserRole Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tUser'
/*
Delete tUser Where OwnerCompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end
*/
-- Added for 8407
Select 'tSystemMessageUser'

Delete tSystemMessageUser
From   tUser (NOLOCK)  
Where tSystemMessageUser.UserKey = tUser.UserKey
And   tUser.CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Delete tSystemMessageUser
From   tUser (NOLOCK)  
Where tSystemMessageUser.UserKey = tUser.UserKey
And   tUser.OwnerCompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tUser Where OwnerCompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tUser Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tUser 
Where CompanyKey in (select CompanyKey from tCompany where OwnerCompanyKey = @CompanyKey)
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCompany'
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tCompany Where OwnerCompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tPreference'
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tPreference Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tTimeOption'
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tTimeOption Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tWidgetCompany'	 
If @DeleteSetupTables = 1
Delete tWidgetCompany WHERE CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tWidget'
If @DeleteSetupTables = 1
Delete tWidget WHERE CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tCMFolder'
Delete tCMFolder WHERE CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

Select 'tWebDavSecurity'
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tWebDavSecurity WHERE CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end
	
Select 'tCompany'
If @DeleteSetupTables = 1 and @LeaveCoreCompany = 0
Delete tCompany Where CompanyKey = @CompanyKey
if	@@error != 0
begin
	--rollback tran
	return -1
end

--commit tran

return 1
GO
