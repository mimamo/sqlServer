USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spOwnerCompanDelete]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spOwnerCompanDelete]

	(
		@CompanyKey int
	)

AS --Encrypt

Declare @OFSKey int
Declare @CurKey int
Declare @CurKey2 int
-- Stopped at 
-- Still to do
-- tLink
-- Custom Fields
-- tFieldDef, tFieldSet
-- tSubscription
-- tDistributionGroup, tDistributionGroupUser
-- tCompanyType (not used), tComment, tAccessLog (not used)
-- tAttachment

-- Not Done
-- tItem, tItemRates, Media Plan Tables

Delete tTime from tUser Where tTime.UserKey = tUser.UserKey and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey)
Delete from tTimeSheet Where CompanyKey = @CompanyKey

Delete tExpenseReceipt from tExpenseEnvelope Where tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey and 
	tExpenseEnvelope.CompanyKey = @CompanyKey
Delete from tExpenseEnvelope Where tExpenseEnvelope.CompanyKey = @CompanyKey

Delete tMiscCost from tProject Where tMiscCost.ProjectKey = tProject.ProjectKey and tProject.CompanyKey = @CompanyKey

-- Did not do tFormFileLink, tFormDefSubscription, tFormDefSecurityGroup, tFormAttachment
Select @CurKey = 0
While 1 = 1
Begin
	Select @CurKey = Min(FormKey) from tForm Where FormKey > @CurKey and CompanyKey = @CompanyKey
	if @CurKey IS NULL
		Break
Select @OFSKey = CustomFieldKey from tForm Where FormKey = @CurKey
	exec spCF_tObjectFieldSetDelete @OFSKey

End

Delete tApprovalItemReply from tApprovalItem, tApproval, tProject Where tApprovalItemReply.ApprovalItemKey = tApprovalItem.ApprovalItemKey and
	tApprovalItem.ApprovalKey = tApproval.ApprovalKey and tApproval.ProjectKey = tProject.ProjectKey and tProject.CompanyKey = @CompanyKey
Delete tApprovalItem from tApproval, tProject Where tApprovalItem.ApprovalKey = tApproval.ApprovalKey and tApproval.ProjectKey = tProject.ProjectKey and tProject.CompanyKey = @CompanyKey
Delete tApprovalList from tApproval, tProject Where tApprovalList.ApprovalKey = tApproval.ApprovalKey and tApproval.ProjectKey = tProject.ProjectKey and
	tProject.CompanyKey = @CompanyKey
Delete tApproval from tProject Where tApproval.ProjectKey = tProject.ProjectKey and tProject.CompanyKey = @CompanyKey

Delete tFileRight from tFile, tFolder, tProject Where tFileRight.FileKey = tFile.FileKey and tFile.FolderKey = tFolder.FolderKey and
	tFolder.RootFolderKey = tProject.RootFolderKey and tProject.CompanyKey = @CompanyKey
Delete tFileRevision from tFile, tFolder, tProject Where tFileRevision.FileKey = tFile.FileKey and tFile.FolderKey = tFolder.FolderKey and
	tFolder.RootFolderKey = tProject.RootFolderKey and tProject.CompanyKey = @CompanyKey
Delete tFile from tFolder, tProject Where tFile.FolderKey = tFolder.FolderKey and
	tFolder.RootFolderKey = tProject.RootFolderKey and tProject.CompanyKey = @CompanyKey
Delete tFolderRight from tFolder, tProject Where tFolderRight.FolderKey = tFolder.FolderKey and tFolder.RootFolderKey = tProject.RootFolderKey and
	tProject.CompanyKey = @CompanyKey
Delete tFolder from tProject Where tFolder.RootFolderKey = tProject.RootFolderKey and tProject.CompanyKey = @CompanyKey


Delete from tForm Where CompanyKey = @CompanyKey
Delete tFormLayoutDetail from tFormLayout Where tFormLayoutDetail.FormLayoutKey = tFormLayout.FormLayoutKey and tFormLayout.CompanyKey = @CompanyKey
Delete from tFormLayout Where CompanyKey = @CompanyKey
Delete from tFormDef Where CompanyKey = @CompanyKey

-- Still need to loop to take care of custom fields ? do in ASP
Delete tPurchaseOrderDetail from tPurchaseOrder Where tPurchaseOrderDetail.PurchaseOrderKey = tPurchaseOrder.PurchaseOrderKey and
	tPurchaseOrder.CompanyKey = @CompanyKey
Delete from tPurchaseOrder Where CompanyKey = @CompanyKey

Delete tQuoteReplyDetail from tQuoteReply, tQuote Where tQuoteReplyDetail.QuoteReplyKey = tQuoteReply.QuoteReplyKey and
	tQuoteReply.QuoteKey = tQuote.QuoteKey and tQuote.CompanyKey = @CompanyKey
Delete tQuoteReply from tQuote Where tQuoteReply.QuoteKey = tQuote.QuoteKey and tQuote.CompanyKey = @CompanyKey
Delete tQuoteDetail from tQuote Where tQuoteDetail.QuoteKey = tQuote.QuoteKey and tQuote.CompanyKey = @CompanyKey
Delete from tQuote Where CompanyKey = @CompanyKey

Delete tCheckAppl from tInvoice Where tCheckAppl.InvoiceKey = tInvoice.InvoiceKey and tInvoice.CompanyKey = @CompanyKey
Delete tCheck from tCompany Where tCheck.ClientKey = tCompany.CompanyKey and tCompany.OwnerCompanyKey = @CompanyKey
Delete tInvoiceLine from tInvoice Where tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey and tInvoice.CompanyKey = @CompanyKey
Delete from tInvoice Where CompanyKey = @CompanyKey

Delete tTimeRateSheetDetail from tTimeRateSheet Where tTimeRateSheetDetail.TimeRateSheetKey = tTimeRateSheet.TimeRateSheetKey and tTimeRateSheet.CompanyKey = @CompanyKey
Delete from tTimeRateSheet Where CompanyKey = @CompanyKey
Delete from tVoucherDetail Where VoucherKey in (Select VoucherKey from tVoucher Where CompanyKey = @CompanyKey)
Delete from tVoucher Where CompanyKey = @CompanyKey
Delete from tWorkType Where CompanyKey = @CompanyKey

Delete tMessageForum from tMessage Where tMessageForum.MessageKey = tMessage.MessageKey and tMessage.CompanyKey = @CompanyKey
Delete tMessageAskedTo from tMessage Where tMessageAskedTo.MessageKey = tMessage.MessageKey and tMessage.CompanyKey = @CompanyKey
Delete from tMessage Where CompanyKey = @CompanyKey
Delete tFormSubscription from tUser Where tFormSubscription.UserKey = tUser.UserKey and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey)
Delete tForum from tProject Where tForum.AssociatedEntity = 'Project' and tForum.EntityKey = tProject.ProjectKey and tProject.CompanyKey = @CompanyKey
Delete from tForum Where tForum.AssociatedEntity = 'Company' and tForum.EntityKey = @CompanyKey

Delete tEstimateTask from tEstimate, tProject Where tEstimateTask.EstimateKey = tEstimate.EstimateKey and tEstimate.ProjectKey = tProject.ProjectKey and
	tProject.CompanyKey = @CompanyKey
Delete tEstimate from tProjectKey Where tEstimate.ProjectKey = tProject.ProjectKey and tProject.CompanyKey = @CompanyKey
Delete tTaskPredecessor from tTask, tProject Where tTaskPredecessor.TaskKey = tTask.TaskKey and tTask.ProjectKey = tProject.ProjectKey and tProject.CompanyKey = @CompanyKey
Delete tTask from tProject Where tTask.ProjectKey = tProject.ProjectKey and tProject.CompanyKey = @CompanyKey

Delete tAssignment from tProject Where tAssignment.ProjectKey = tProject.ProjectKey and tProject.CompanyKey = @CompanyKey
Delete tSecurityAssignment from tSecurityGroup Where tSecurityAssignment.SecurityGroupKey = tSecurityGroup.SecurityGroupKey and
	tSecurityGroup.CompanyKey = @CompanyKey
Delete tRptSecurityGroup from tSecurityGroup Where tRptSecurityGroup.SecurityGroupKey = tSecurityGroup.SecurityGroupKey and
	tSecurityGroup.CompanyKey = @CompanyKey
Delete tRightAssigned from tSecurityGroup Where tRightAssigned.EntityKey = tSecurityGroup.SecurityGroupKey and
	tSecurityGroup.CompanyKey = @CompanyKey and tRightAssigned.EntityType = 'Security Group'
Delete from tSecurityGroup Where CompanyKey = @CompanyKey

Delete tCalendarAttendee from tCalendar Where tCalendarAttendee.CalendarKey = tCalendar.CalendarKey and tCalendar.CompanyKey = @CompanyKey
Delete from tCalendar Where tCalendar.CompanyKey = @CompanyKey

Delete tUserSkill from tUser Where tUserSkill.UserKey = tUser.UserKey and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey)
Delete tUserSkillSpecialty from tUser Where tUserSkillSpecialty.UserKey = tUser.UserKey and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey)
Delete tSkillSpecialty from tSkill Where tSkillSpecialty.SkillKey = tSkill.SkillKey and tSkill.CompanyKey = @CompanyKey
Delete from tSkill Where CompanyKey = @CompanyKey

Delete from tDepartment Where CompanyKey = @CompanyKey
Delete from tGLAccount Where CompanyKey = @CompanyKey
Delete from tContactActivity Where CompanyKey = @CompanyKey
Delete from tLead Where CompanyKey = @CompanyKey
Delete from tLeadOutcome Where CompanyKey = @CompanyKey
Delete from tLeadStage Where CompanyKey = @CompanyKey
Delete from tLeadStatus Where CompanyKey = @CompanyKey
Delete from tExpenseType Where CompanyKey = @CompanyKey

Delete from tNews Where CompanyKey = @CompanyKey
Delete from tProjectType Where CompanyKey = @CompanyKey
Delete from tProjectStatus Where CompanyKey = @CompanyKey
Delete from tProjectBillingStatus Where CompanyKey = @CompanyKey
Delete from tPaymentTerms Where CompanyKey = @CompanyKey

Delete from tPurchaseOrderType Where CompanyKey = @CompanyKey  -- Need to loop and take care of field sets and custom fields on POs
Delete from tReport Where CompanyKey = @CompanyKey
Delete from tReportGroup Where CompanyKey = @CompanyKey
Delete from tStringCompany Where CompanyKey = @CompanyKey
Delete from tService Where CompanyKey = @CompanyKey
Delete from tSalesTax Where CompanyKey = @CompanyKey

Delete from tProject Where CompanyKey = @CompanyKey
Delete from tUser Where CompanyKey = @CompanyKey or OwnerCompanyKey = @CompanyKey
Delete from tCompany Where OwnerCompanyKey = @CompanyKey
Delete from tPreference Where CompanyKey = @CompanyKey
Delete from tTimeOption Where CompanyKey = @CompanyKey
Delete from tCompany Where CompanyKey = @CompanyKey
GO
