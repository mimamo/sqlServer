USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCompanyBackup]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCompanyBackup]
	@CompanyKey int,
	@BackupPath varchar(1000) = 'c:\backup\',
	@WithPassword int = 1
AS

/*
	Who		When		What
	GHL		09/19/05	Updated for version 800
	GHL		10/31/05	Updated for version 81
	GHL		01/26/06	Updated for version 82
	GHL		03/27/06	Updated for Vesrion 83
	GHL		06/30/06	Updated for Version 835
	CRG		08/10/06	Updated for Version 84
	GHL     03/16/07    Updated for Version 8407
	GHL		06/21/07	Updated for Version 843
	GWG		03/15/08	Added tMediaRevisionReason
	GHL     11/04/08    Updated for 85 and WMJ10
	GHL     06/09/09    Added cash basis tables
	GHL     06/09/09    Updated for WMJ105
	GHL     09/29/09    Added tVoucherTax, tVoucherDetailTax
	GHL     09/29/09    Added tInvoiceTax
	CRG		05/18/10    Modified because tTaskUser allows NULL UserKey now	
	RLB     01/31/11    added tAttachment Activity
	GWG		04/25/11	Added a comment at the bottom to show how to do an encrypted backup
	GHL     06/20/11    (111045) Added Password to backup + missing tables
	                    Fixed tReviewComment backup
	GHL     08/16/11    Removed Catalog tables
	CRG     08/22/11    Added tWebDavServer
	GHL     09/08/11    Added WithPassword parameter so that we can backup with or without password
						3 ways to backup:
						1) exec spCompanyBackup 100....................will backup to PABackup
						2) exec spCompanyBackup 100, 'c:\backup\'......will backup to drive without pwd
						3) exec spCompanyBackup 100, 'c:\backup\', 1...will backup to drive with pwd
	GHL     09/29/11    Added tVoucherCC and tGLAccountUser for credit card charges
	GHL     04/19/12    (112800) Added explicit creation of tAttachment to prevent problems with FileID
	GHL     05/03/12    Added new attachments (ER and VI). Added tGLCompanyMap, tUserGLCompanyAccess
	CRG     11/13/12    Now backing up tAttachment based on CompanyKey
	GWG     01/16/13    Added a delete of Action Log
	GWG     07/16/13    Modified the password to include the month and day (0 padded)
	GHL     08/14/13    Changed final message
	GHL     09/19/14    Adding (nolock) when querying tTime + large tables because of timeouts 
	GWG     09/23/14    Modified how the file name is generated and got rid of the delete section. Gens name as key_yearmonthday.bak
	GHL     10/30/14    Added around 100 missing tables 
	GHL     11/03/14    Added other session entities for a user or company
	CRG     11/03/14    Added tVPaymentLog
	GWG		11/5/14		Added default path in the parms
	RLB		12/15/14    Fix how data was pulled for tNote and tLink since we no longer use notegroup also default @WithPassword to 1
	GHL     01/09/14    (240587) Added missing NOLOCKs, added calls to spTime, removed tEmailSendLog, reviewed tTaskUser and Time queries
*/


	declare @t datetime
	select @t = getdate()

	DECLARE	@DataBackup varchar(1000)
	
	if exists (select * from PABackup.dbo.sysobjects where name='cnvCustTermsMap')
		drop table PABackup.dbo.cnvCustTermsMap

	Print 'cnvCustTermsMap'	 

	Select cnvCustTermsMap.* 
	Into PABackup.dbo.cnvCustTermsMap 
	From cnvCustTermsMap (nolock) 
	Where  CompanyKey = @CompanyKey
	
	exec spTime 'cnvCustTermsMap', @t output

	if exists (select * from PABackup.dbo.sysobjects where name='tActionLog')
		drop table PABackup.dbo.tActionLog
		
	Print 'tActionLog: FileVersion'	 
	Select tActionLog.* 
	Into PABackup.dbo.tActionLog 
	From tActionLog (nolock) 
	Where  CompanyKey = @CompanyKey
	
	exec spTime 'tActionLog: FileVersion', @t output
 
	Print 'tActivationLog'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tActivationLog')
	drop table PABackup.dbo.tActivationLog
	 
	Select tActivationLog.* Into PABackup.dbo.tActivationLog 
	FROM tActivationLog  (nolock), tUser u  (nolock)
	where tActivationLog.UserKey = u.UserKey 
	and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey

	exec spTime '', @t output
 
	Print 'tActivity'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tActivity')
	drop table PABackup.dbo.tActivity
	 
	Select tActivity.* Into PABackup.dbo.tActivity 
	FROM tActivity (nolock) 
	where tActivity.CompanyKey = @CompanyKey

	exec spTime 'tActivity', @t output
 
	Print 'tActivityEmail'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tActivityEmail')
	drop table PABackup.dbo.tActivityEmail
	 
	Select tActivityEmail.* Into PABackup.dbo.tActivityEmail 
	FROM   tActivityEmail (nolock) , tActivity a (nolock) 
	where  tActivityEmail.ActivityKey = a.ActivityKey 
	and    a.CompanyKey = @CompanyKey

	exec spTime 'tActivityEmail', @t output
 
	Print 'tActivityHistory'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tActivityHistory')
	drop table PABackup.dbo.tActivityHistory
	 
	Select tActivityHistory.* Into PABackup.dbo.tActivityHistory 
	FROM   tActivityHistory (nolock) , tActivity a (nolock) 
	where  tActivityHistory.ActivityKey = a.ActivityKey 
	and    a.CompanyKey = @CompanyKey

	exec spTime 'tActivityHistory', @t output

	Print 'tActivityLink : tCompany'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tActivityLink')
	drop table PABackup.dbo.tActivityLink
	 
	Select tActivityLink.* Into PABackup.dbo.tActivityLink 
	FROM   tActivityLink (nolock) , tActivity a (nolock) 
	where  tActivityLink.ActivityKey = a.ActivityKey 
	and    a.CompanyKey = @CompanyKey

	exec spTime 'tActivityLink : tCompany', @t output

	Print 'tActivityType'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tActivityType')
	drop table PABackup.dbo.tActivityType
	 
	Select tActivityType.* Into PABackup.dbo.tActivityType 
	FROM tActivityType (nolock)
	where tActivityType.CompanyKey = @CompanyKey

	exec spTime 'tActivityType', @t output

	Print 'tAddress'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tAddress')
	drop table PABackup.dbo.tAddress
	 
	Select tAddress.* Into PABackup.dbo.tAddress 
	FROM tAddress (nolock) 
	where tAddress.OwnerCompanyKey = @CompanyKey
	
	exec spTime 'tAddress', @t output

	if exists (select * from PABackup.dbo.sysobjects where name='tAppFavorite')
		drop table PABackup.dbo.tAppFavorite

	Print 'tAppFavorite'	 

	Select tAppFavorite.* 
	Into PABackup.dbo.tAppFavorite 
	From tAppFavorite (nolock) 
	Where  CompanyKey = @CompanyKey

	exec spTime 'tAppFavorite', @t output

	if exists (select * from PABackup.dbo.sysobjects where name='tAppHistory')
		drop table PABackup.dbo.tAppHistory

	Print 'tAppHistory'	 

	Select tAppHistory.* 
	Into PABackup.dbo.tAppHistory 
	From tAppHistory (nolock) 
	Where  CompanyKey = @CompanyKey

	exec spTime 'tAppHistory', @t output

	if exists (select * from PABackup.dbo.sysobjects where name='tAppMenu')
		drop table PABackup.dbo.tAppMenu

	Print 'tAppMenu'	 

	Select tAppMenu.* 
	Into PABackup.dbo.tAppMenu 
	From tAppMenu (nolock) 
	Where  CompanyKey = @CompanyKey

	exec spTime 'tAppMenu', @t output

	if exists (select * from PABackup.dbo.sysobjects where name='tAppRead')
		drop table PABackup.dbo.tAppRead

	Print 'tAppRead'	 

	Select tAppRead.* 
	Into PABackup.dbo.tAppRead 
	From tAppRead (nolock)
		inner join tUser u (nolock) on tAppRead.UserKey = u.UserKey 
	Where  isnull(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey

	exec spTime 'tAppRead', @t output

	Print 'tApproval'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tApproval')
	drop table PABackup.dbo.tApproval
	 
	Select tApproval.* Into PABackup.dbo.tApproval 
	FROM tApproval (nolock), tProject (nolock) 
	Where tApproval.ProjectKey = tProject.ProjectKey 
	and tProject.CompanyKey = @CompanyKey

	exec spTime 'tApproval', @t output

	Print 'tApprovalItem'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tApprovalItem')
	drop table PABackup.dbo.tApprovalItem
	 
	Select tApprovalItem.* Into PABackup.dbo.tApprovalItem 
	FROM tApprovalItem (nolock) , tApproval (nolock) , tProject (nolock)  
	Where tApprovalItem.ApprovalKey = tApproval.ApprovalKey 
	and tApproval.ProjectKey = tProject.ProjectKey 
	and tProject.CompanyKey = @CompanyKey

	exec spTime 'tApprovalItem', @t output
	
	Print 'tApprovalItemReply'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tApprovalItemReply')
	drop table PABackup.dbo.tApprovalItemReply
	 
	Select tApprovalItemReply.* Into PABackup.dbo.tApprovalItemReply 
	FROM tApprovalItemReply (nolock) , tApprovalItem (nolock) , tApproval (nolock) , tProject (nolock) 
	Where tApprovalItemReply.ApprovalItemKey = tApprovalItem.ApprovalItemKey 
	and	tApprovalItem.ApprovalKey = tApproval.ApprovalKey 
	and tApproval.ProjectKey = tProject.ProjectKey 
	and tProject.CompanyKey = @CompanyKey

	exec spTime 'tApprovalItemReply', @t output
	
	Print 'tApprovalList'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tApprovalList')
	drop table PABackup.dbo.tApprovalList
	 
	Select tApprovalList.* Into PABackup.dbo.tApprovalList 
	FROM tApprovalList (nolock) , tApproval (nolock) , tProject (nolock) 
	Where tApprovalList.ApprovalKey = tApproval.ApprovalKey 
	and tApproval.ProjectKey = tProject.ProjectKey 
	and	tProject.CompanyKey = @CompanyKey

	exec spTime 'tApprovalList', @t output

	Print 'tApprovalUpdateList'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tApprovalUpdateList')
	drop table PABackup.dbo.tApprovalUpdateList
	 
	Select tApprovalUpdateList.* Into PABackup.dbo.tApprovalUpdateList 
	FROM tApprovalUpdateList (nolock), tApproval (nolock), tProject (nolock) 
	Where tApprovalUpdateList.ApprovalKey = tApproval.ApprovalKey 
	and tApproval.ProjectKey = tProject.ProjectKey 
	and	tProject.CompanyKey = @CompanyKey

	exec spTime 'tApprovalUpdateList', @t output
	
	Print 'tApprovalStep'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tApprovalStep')
	drop table PABackup.dbo.tApprovalStep
	 
	Select * Into PABackup.dbo.tApprovalStep FROM tApprovalStep WHERE CompanyKey = @CompanyKey

	exec spTime 'tApprovalStep', @t output
	
	Print 'tApprovalStepDef'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tApprovalStepDef')
	drop table PABackup.dbo.tApprovalStepDef
	 
	Select * Into PABackup.dbo.tApprovalStepDef FROM tApprovalStepDef (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tApprovalStepDef', @t output

	Print 'tApprovalStepDefNotify'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tApprovalStepDefNotify')
	drop table PABackup.dbo.tApprovalStepDefNotify
	 
	Select tApprovalStepDefNotify.* Into PABackup.dbo.tApprovalStepDefNotify 
	FROM tApprovalStepDefNotify (nolock), tApprovalStepDef  (nolock)
	WHERE tApprovalStepDef.CompanyKey = @CompanyKey
	and   tApprovalStepDefNotify.ApprovalStepDefKey = tApprovalStepDef.ApprovalStepDefKey 

	exec spTime 'tApprovalStepDefNotify', @t output

	Print 'tApprovalStepNotify'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tApprovalStepNotify')
	drop table PABackup.dbo.tApprovalStepNotify
	 
	Select tApprovalStepNotify.* Into PABackup.dbo.tApprovalStepNotify 
	FROM tApprovalStepNotify (nolock), tApprovalStep  (nolock)
	WHERE tApprovalStep.CompanyKey = @CompanyKey
	and   tApprovalStepNotify.ApprovalStepKey = tApprovalStep.ApprovalStepKey 

	exec spTime 'tApprovalStepNotify', @t output

	Print 'tApprovalStepUser'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tApprovalStepUser')
	drop table PABackup.dbo.tApprovalStepUser
	 
	Select tApprovalStepUser.* Into PABackup.dbo.tApprovalStepUser 
	FROM tApprovalStepUser (nolock), tApprovalStep aps (nolock) 
	where tApprovalStepUser.ApprovalStepKey = aps.ApprovalStepKey 
	and aps.CompanyKey = @CompanyKey

	exec spTime 'tApprovalStepUser', @t output
	
	Print 'tApprovalStepUserDef'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tApprovalStepUserDef')
	drop table PABackup.dbo.tApprovalStepUserDef
	 
	Select tApprovalStepUserDef.* Into PABackup.dbo.tApprovalStepUserDef 
	FROM tApprovalStepUserDef (nolock), tApprovalStepDef asd (nolock) 
	where tApprovalStepUserDef.ApprovalStepDefKey = asd.ApprovalStepDefKey 
	and asd.CompanyKey = @CompanyKey
	
	exec spTime 'tApprovalStepUserDef', @t output

	Print 'tApprovalType'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tApprovalType')
	drop table PABackup.dbo.tApprovalType
	 
	Select * Into PABackup.dbo.tApprovalType FROM tApprovalType (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tApprovalType', @t output
	
	Print 'tAppSession:company'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tAppSession')
	drop table PABackup.dbo.tAppSession
	 
	Select tAppSession.* Into PABackup.dbo.tAppSession 
	FROM tAppSession (nolock), tCompany c (nolock) 
	where tAppSession.EntityKey = c.CompanyKey 
	and tAppSession.Entity = 'company'
	and isnull(c.OwnerCompanyKey, c.CompanyKey) = @CompanyKey

	exec spTime 'tAppSession:company', @t output
	
	Print 'tAppSession:user'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tAppSession')
	 
		Insert PABackup.dbo.tAppSession 
		Select tAppSession.*  
		FROM tAppSession (nolock), tUser u (nolock) 
		where tAppSession.EntityKey = u.UserKey 
		and tAppSession.Entity = 'user'
		and isnull(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey

	else
	 
		Select tAppSession.* Into PABackup.dbo.tAppSession 
		FROM tAppSession (nolock), tUser u (nolock) 
		where tAppSession.EntityKey = u.UserKey 
		and tAppSession.Entity = 'user'
		and isnull(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey

	exec spTime 'tAppSession:user', @t output

	Print 'tAppSetting:company'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tAppSetting')
	drop table PABackup.dbo.tAppSetting
	 
	Select tAppSetting.* Into PABackup.dbo.tAppSetting 
	FROM tAppSetting (nolock), tAppSession (nolock), tCompany c (nolock) 
	where tAppSession.EntityKey = c.CompanyKey 
	and tAppSession.Entity = 'company'
	and isnull(c.OwnerCompanyKey, c.CompanyKey) = @CompanyKey
	and tAppSetting.SessionID = tAppSession.SessionID

	exec spTime 'tAppSetting:company', @t output

	Print 'tAppSetting:user'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tAppSetting')
	 
		Insert PABackup.dbo.tAppSetting 
		Select tAppSetting.*  
		FROM tAppSetting (nolock), tAppSession (nolock), tUser u (nolock) 
		where tAppSession.EntityKey = u.UserKey 
		and tAppSession.Entity = 'user'
		and isnull(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey
		and tAppSetting.SessionID = tAppSession.SessionID

	else
	 
		Select tAppSession.* Into PABackup.dbo.tAppSession 
		FROM tAppSetting (nolock), tAppSession (nolock), tUser u (nolock) 
		where tAppSession.EntityKey = u.UserKey 
		and tAppSession.Entity = 'user'
		and isnull(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey
		and tAppSetting.SessionID = tAppSession.SessionID

	exec spTime 'tAppSetting:user', @t output

	Print 'tAppSettingGroup'	 

	if exists (select * from PABackup.dbo.sysobjects where name='tAppSettingGroup')
		drop table PABackup.dbo.tAppSettingGroup
	
	Select tAppSettingGroup.* 
	Into PABackup.dbo.tAppSettingGroup 
	From tAppSettingGroup (nolock) 

	exec spTime 'tAppSettingGroup', @t output
	
	Print 'tAssignment'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tAssignment')
	drop table PABackup.dbo.tAssignment
	 
	Select tAssignment.* Into PABackup.dbo.tAssignment 
	FROM tAssignment (nolock) , tProject  (nolock) 
	Where tAssignment.ProjectKey = tProject.ProjectKey 
	and tProject.CompanyKey = @CompanyKey
	
	exec spTime 'tAssignment', @t output

	Print 'tAttachment'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tAttachment')
	drop table PABackup.dbo.tAttachment
	 
	-- The first Select	tAttachment.* Into PABackup.dbo.tAttachment  seems to miss FileID
	-- so do a real table creation
	CREATE TABLE PABackup.dbo.tAttachment (
	[AttachmentKey] [int] NOT NULL,
	[CompanyKey] int NULL,
	[AssociatedEntity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[AddedBy] [int] NOT NULL,
	[FileName] [varchar](300) NOT NULL,
	[Comments] [varchar](1000) NULL,
	[Path] [varchar](2000) NULL,
	[FileID] [varchar](2000) NULL
	)

	Insert	PABackup.dbo.tAttachment (AttachmentKey,
			CompanyKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Comments,
			Path,
			FileID )
	Select  AttachmentKey,
			CompanyKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Comments,
			Path,
			FileID
	FROM	tAttachment (NOLOCK)
	where	CompanyKey = @CompanyKey

	exec spTime 'tAttachment', @t output

	Print 'tAttribute'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tAttribute')
	drop table PABackup.dbo.tAttribute

	exec spTime 'tAttribute', @t output
	 
	Print 'tAttribute: File'
	Select	tAttribute.* Into PABackup.dbo.tAttribute 
	FROM	tAttribute (nolock), tDAFile f (nolock), tDAFolder fol (nolock), tProject p (nolock)
	where	tAttribute.Entity = 'File'
	and		tAttribute.EntityKey = f.FileKey
	and		f.FolderKey = fol.FolderKey
	and		fol.ProjectKey = p.ProjectKey
	and		p.CompanyKey = @CompanyKey

	exec spTime 'tAttribute: File', @t output
	
	Print 'tAttributeEntityValue'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tAttributeEntityValue')
	drop table PABackup.dbo.tAttributeEntityValue
	 	 
	Print 'tAttributeEntityValue: File'
	Select	tAttributeEntityValue.* Into PABackup.dbo.tAttributeEntityValue 
	FROM	tAttributeEntityValue (nolock), tDAFile f (nolock), tDAFolder fol (nolock), tProject p (nolock)
	where	tAttributeEntityValue.Entity = 'File'
	and		tAttributeEntityValue.EntityKey = f.FileKey
	and		f.FolderKey = fol.FolderKey
	and		fol.ProjectKey = p.ProjectKey
	and		p.CompanyKey = @CompanyKey

	exec spTime 'tAttributeEntityValue', @t output
	
	Print 'tAttributeValue'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tAttributeValue')
	drop table PABackup.dbo.tAttributeValue
	 
	Select	tAttributeValue.* Into PABackup.dbo.tAttributeValue 
	FROM	tAttributeValue (nolock), tAttribute a (nolock), tDAFile f (nolock), tDAFolder fol (nolock), tProject p (nolock)
	where	tAttributeValue.AttributeKey = a.AttributeKey
	and		a.Entity = 'File'
	and		a.EntityKey = f.FileKey
	and		f.FolderKey = fol.FolderKey
	and		fol.ProjectKey = p.ProjectKey
	and		p.CompanyKey = @CompanyKey
	
	exec spTime 'tAttributeValue', @t output

	Print 'tBilling'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tBilling')
	drop table PABackup.dbo.tBilling
	 
	Select * Into PABackup.dbo.tBilling FROM tBilling (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tBilling', @t output

	Print 'tBillingDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tBillingDetail')
	drop table PABackup.dbo.tBillingDetail
	 
	Select tBillingDetail.* Into PABackup.dbo.tBillingDetail 
	FROM tBillingDetail (nolock), tBilling (nolock)
	WHERE tBillingDetail.BillingKey = tBilling.BillingKey
	and tBilling.CompanyKey = @CompanyKey

	exec spTime 'tBillingDetail', @t output

	Print 'tBillingFixedFee'
	if exists (select * from PABackup.dbo.sysobjects where name='tBillingFixedFee')
	drop table PABackup.dbo.tBillingFixedFee
	 
	Select tBillingFixedFee.* Into PABackup.dbo.tBillingFixedFee 
	FROM tBillingFixedFee (nolock), tBilling (nolock)
	WHERE tBillingFixedFee.BillingKey = tBilling.BillingKey
	and tBilling.CompanyKey = @CompanyKey

	exec spTime 'tBillingFixedFee', @t output

	Print 'tBillingGroup'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tBillingGroup')
	drop table PABackup.dbo.tBillingGroup
	 
	Select * Into PABackup.dbo.tBillingGroup FROM tBillingGroup (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tBillingGroup', @t output

	Print 'tBillingPayment'
	if exists (select * from PABackup.dbo.sysobjects where name='tBillingPayment')
	drop table PABackup.dbo.tBillingPayment
	 
	Select tBillingPayment.* Into PABackup.dbo.tBillingPayment 
	FROM tBillingPayment (nolock), tBilling (nolock)
	WHERE tBillingPayment.BillingKey = tBilling.BillingKey
	and tBilling.CompanyKey = @CompanyKey

	exec spTime 'tBillingPayment', @t output

	Print 'tBillingSchedule'
	if exists (select * from PABackup.dbo.sysobjects where name='tBillingSchedule')
	drop table PABackup.dbo.tBillingSchedule
	 
	Select tBillingSchedule.* Into PABackup.dbo.tBillingSchedule 
	FROM tBillingSchedule (nolock), tProject (nolock)
	WHERE tBillingSchedule.ProjectKey = tProject.ProjectKey
	and tProject.CompanyKey = @CompanyKey

	exec spTime 'tBillingSchedule', @t output

	Print 'tBuyUpdateLog'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tBuyUpdateLog')
	drop table PABackup.dbo.tBuyUpdateLog
	 
	Select * Into PABackup.dbo.tBuyUpdateLog FROM tBuyUpdateLog (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tBuyUpdateLog', @t output

	Print 'tBuyUpdateLogDetail'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tBuyUpdateLogDetail')
	drop table PABackup.dbo.tBuyUpdateLogDetail
	 
	Select tBuyUpdateLogDetail.* Into PABackup.dbo.tBuyUpdateLogDetail 
	FROM tBuyUpdateLogDetail (nolock) , tBuyUpdateLog (nolock)
	Where tBuyUpdateLogDetail.BuyUpdateLogKey = tBuyUpdateLog.BuyUpdateLogKey 
	and tBuyUpdateLog.CompanyKey = @CompanyKey

	exec spTime 'tBuyUpdateLogDetail', @t output

	Print 'tCalendar'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCalendar')
	drop table PABackup.dbo.tCalendar
	 
	Select * Into PABackup.dbo.tCalendar FROM tCalendar (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tCalendar', @t output
	 
	Print 'tCalendarAttendee'

	
	if exists (select * from PABackup.dbo.sysobjects where name='tCalendarAttendee')
	drop table PABackup.dbo.tCalendarAttendee
	 
	Select tCalendarAttendee.* Into PABackup.dbo.tCalendarAttendee 
	FROM tCalendarAttendee (nolock) , tCalendar (nolock)
	Where tCalendarAttendee.CalendarKey = tCalendar.CalendarKey 
	and tCalendar.CompanyKey = @CompanyKey

	exec spTime 'tCalendarAttendee', @t output

	Print 'tCalendarAttendeeGroup'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCalendarAttendeeGroup')
	drop table PABackup.dbo.tCalendarAttendeeGroup
	 
	Select tCalendarAttendeeGroup.* Into PABackup.dbo.tCalendarAttendeeGroup 
	FROM tCalendarAttendeeGroup (nolock), tCalendar (nolock)  
	Where tCalendarAttendeeGroup.CalendarKey = tCalendar.CalendarKey 
	and tCalendar.CompanyKey = @CompanyKey
	
	exec spTime 'tCalendarAttendeeGroup', @t output

	Print 'tCalendarAttendeeUpdateLog'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCalendarAttendeeUpdateLog')
	drop table PABackup.dbo.tCalendarAttendeeUpdateLog
	 
	Select tCalendarAttendeeUpdateLog.* Into PABackup.dbo.tCalendarAttendeeUpdateLog 
	FROM tCalendarAttendeeUpdateLog (nolock), tCalendar (nolock) 
	Where tCalendarAttendeeUpdateLog.CalendarKey = tCalendar.CalendarKey 
	and tCalendar.CompanyKey = @CompanyKey
	
	exec spTime 'tCalendarAttendeeUpdateLog', @t output

	Print 'tCalendarResource'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCalendarResource')
	drop table PABackup.dbo.tCalendarResource
	 
	Select tCalendarResource.* Into PABackup.dbo.tCalendarResource 
	FROM tCalendarResource (nolock)
	Where tCalendarResource.CompanyKey = @CompanyKey
	
	exec spTime 'tCalendarResource', @t output

	Print 'tCalendarType'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCalendarType')
	drop table PABackup.dbo.tCalendarType
	 
	Select * Into PABackup.dbo.tCalendarType FROM tCalendarType (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tCalendarType', @t output

	Print 'tCalendarUser'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCalendarUser')
	drop table PABackup.dbo.tCalendarUser
	 
	Select tCalendarUser.* Into PABackup.dbo.tCalendarUser 
	FROM tCalendarUser (nolock), tUser u (nolock) 
	where tCalendarUser.UserKey = u.UserKey 
	and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
	
	exec spTime 'tCalendarUser', @t output

	Print 'tCalendarLink'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCalendarLink')
	drop table PABackup.dbo.tCalendarLink
	 
	Select tCalendarLink.* Into PABackup.dbo.tCalendarLink 
	FROM   tCalendarLink (nolock), tCalendar c (nolock)
	where  tCalendarLink.CalendarKey = c.CalendarKey 
	and    c.CompanyKey = @CompanyKey 

	exec spTime 'tCalendarLink', @t output

	Print 'tCalendarReminder'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCalendarReminder')
	drop table PABackup.dbo.tCalendarReminder
	 
	Select tCalendarReminder.* Into PABackup.dbo.tCalendarReminder 
	FROM   tCalendarReminder (nolock), tUser u (nolock) 
	where  tCalendarReminder.UserKey = u.UserKey 
	and    isnull(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey 
	
	exec spTime 'tCalendarReminder', @t output

	Print 'tCalendarUpdateLog'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCalendarUpdateLog')
	drop table PABackup.dbo.tCalendarUpdateLog
	 
	Select tCalendarUpdateLog.* Into PABackup.dbo.tCalendarUpdateLog 
	FROM   tCalendarUpdateLog (nolock), tCalendar c (nolock)
	where  tCalendarUpdateLog.CalendarKey = c.CalendarKey 
	and    c.CompanyKey = @CompanyKey 
	
	exec spTime 'tCalendarUpdateLog', @t output

	Print 'tCampaign'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCampaign')
	drop table PABackup.dbo.tCampaign
	 
	Select * Into PABackup.dbo.tCampaign FROM tCampaign (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tCampaign', @t output

	Print 'tCampaignBudget'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCampaignBudget')
	drop table PABackup.dbo.tCampaignBudget
	 
	Select tCampaignBudget.* Into PABackup.dbo.tCampaignBudget 
	FROM tCampaignBudget (nolock)
		,tCampaign c  (nolock)
	WHERE c.CompanyKey = @CompanyKey
	AND   tCampaignBudget.CampaignKey = c.CampaignKey

	exec spTime 'tCampaignBudget', @t output

	Print 'tCampaignBudgetItem'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCampaignBudgetItem')
	drop table PABackup.dbo.tCampaignBudgetItem
	 
	Select tCampaignBudgetItem.* Into PABackup.dbo.tCampaignBudgetItem 
	FROM tCampaignBudgetItem (nolock)
		,tCampaign c  (nolock)
	WHERE c.CompanyKey = @CompanyKey
	AND   tCampaignBudgetItem.CampaignKey = c.CampaignKey

	exec spTime 'tCampaignBudgetItem', @t output

	Print 'tCampaignEstByItem'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCampaignEstByItem')
	drop table PABackup.dbo.tCampaignEstByItem
	 
	Select tCampaignEstByItem.* Into PABackup.dbo.tCampaignEstByItem 
	FROM tCampaignEstByItem (nolock)
		,tCampaign c  (nolock)
	WHERE c.CompanyKey = @CompanyKey
	AND   tCampaignEstByItem.CampaignKey = c.CampaignKey

	exec spTime 'tCampaignEstByItem', @t output

	Print 'tCampaignRollup'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCampaignRollup')
	drop table PABackup.dbo.tCampaignRollup
	 
	Select tCampaignRollup.* Into PABackup.dbo.tCampaignRollup 
	FROM tCampaignRollup (nolock)
		,tCampaign c  (nolock)
	WHERE c.CompanyKey = @CompanyKey
	AND   tCampaignRollup.CampaignKey = c.CampaignKey

	exec spTime 'tCampaignRollup', @t output

	Print 'tCampaignSegment'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCampaignSegment')
	drop table PABackup.dbo.tCampaignSegment
	 
	Select tCampaignSegment.* Into PABackup.dbo.tCampaignSegment 
	FROM tCampaignSegment (nolock)
		,tCampaign c  (nolock)
	WHERE c.CompanyKey = @CompanyKey
	AND   tCampaignSegment.CampaignKey = c.CampaignKey

	exec spTime 'tCampaignSegment', @t output

	Print 'tCardDavLog'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCardDavLog')
	drop table PABackup.dbo.tCardDavLog
	 
	Select tCardDavLog.* Into PABackup.dbo.tCardDavLog 
	FROM tCardDavLog (nolock)
		,tUser u (nolock)
	WHERE isnull(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey
	AND   tCardDavLog.UserKey = u.UserKey

	exec spTime 'tCardDavLog', @t output

	Print 'tCashTransaction'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCashTransaction')
	drop table PABackup.dbo.tCashTransaction
	 
	Select * Into PABackup.dbo.tCashTransaction 
	FROM tCashTransaction (NOLOCK)
	WHERE CompanyKey = @CompanyKey

	exec spTime 'tCashTransaction', @t output

	Print 'tCashTransactionLine'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCashTransactionLine')
	drop table PABackup.dbo.tCashTransactionLine
	 
	Select * Into PABackup.dbo.tCashTransactionLine 
	FROM tCashTransactionLine (NOLOCK)
	WHERE CompanyKey = @CompanyKey

	exec spTime 'tCashTransactionLine', @t output

	Print 'tCBBatch'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCBBatch')
	drop table PABackup.dbo.tCBBatch
	 
	Select * Into PABackup.dbo.tCBBatch 
	FROM tCBBatch (NOLOCK)
	WHERE CompanyKey = @CompanyKey

	exec spTime 'tCBBatch', @t output

	Print 'tCBBatchAdjustment'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCBBatchAdjustment')
	drop table PABackup.dbo.tCBBatchAdjustment
	 
	Select tCBBatchAdjustment.* Into PABackup.dbo.tCBBatchAdjustment 
	FROM tCBBatchAdjustment (NOLOCK)
		,tCBBatch b (NOLOCK)
	WHERE b.CompanyKey = @CompanyKey
	AND   tCBBatchAdjustment.BatchKey = b.CBBatchKey

	exec spTime 'tCBBatchAdjustment', @t output

	Print 'tCBCode'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCBCode')
	drop table PABackup.dbo.tCBCode
	 
	Select * Into PABackup.dbo.tCBCode 
	FROM tCBCode (NOLOCK)
	WHERE CompanyKey = @CompanyKey

	exec spTime 'tCBCode', @t output

	Print 'tCBCodePercent'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCBCodePercent')
	drop table PABackup.dbo.tCBCodePercent
	 
	Select tCBCodePercent.* Into PABackup.dbo.tCBCodePercent 
	FROM tCBCodePercent (NOLOCK)
		,tCBCode b (NOLOCK)
	WHERE b.CompanyKey = @CompanyKey
	AND   tCBCodePercent.CBCodeKey = b.CBCodeKey

	exec spTime 'tCBCodePercent', @t output

	Print 'tCBPosting'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCBPosting')
	drop table PABackup.dbo.tCBPosting
	 
	Select tCBPosting.* Into PABackup.dbo.tCBPosting 
	FROM tCBPosting (NOLOCK)
		,tProject b (NOLOCK)
	WHERE b.CompanyKey = @CompanyKey
	AND   tCBPosting.ProjectKey = b.ProjectKey

	exec spTime 'tCBPosting', @t output

	Print 'tCCEntry'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCCEntry')
	drop table PABackup.dbo.tCCEntry
	 
	Select * Into PABackup.dbo.tCCEntry 
	FROM tCCEntry (NOLOCK)
	WHERE CompanyKey = @CompanyKey

	exec spTime 'tCCEntry', @t output

	Print 'tCCEntrySplit'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCCEntrySplit')
	drop table PABackup.dbo.tCCEntrySplit
	 
	Select tCCEntrySplit.* Into PABackup.dbo.tCCEntrySplit 
	FROM tCCEntrySplit (NOLOCK)
		,tCCEntry b (NOLOCK)
	WHERE b.CompanyKey = @CompanyKey
	AND   tCCEntrySplit.CCEntryKey = b.CCEntryKey

	exec spTime 'tCCEntrySplit', @t output

	Print 'tCheck'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCheck')
	drop table PABackup.dbo.tCheck
	 
	Select tCheck.* Into PABackup.dbo.tCheck 
	FROM tCheck (nolock), tCompany (nolock) 
	Where tCheck.ClientKey = tCompany.CompanyKey 
	and tCompany.OwnerCompanyKey = @CompanyKey
	
	exec spTime 'tCheck', @t output

	Print 'tCheckAppl'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCheckAppl')
	drop table PABackup.dbo.tCheckAppl
	 
	Select tCheckAppl.* Into PABackup.dbo.tCheckAppl 
	FROM tCheckAppl (nolock), tCheck (nolock), tCompany (nolock)
	Where tCheckAppl.CheckKey = tCheck.CheckKey 
	and tCheck.ClientKey = tCompany.CompanyKey 
	and tCompany.OwnerCompanyKey = @CompanyKey
	
	exec spTime 'tCheckAppl', @t output

	Print 'tCheckFormat'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCheckFormat')
	drop table PABackup.dbo.tCheckFormat
	 
	Select * Into PABackup.dbo.tCheckFormat FROM tCheckFormat (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tCheckFormat', @t output

	Print 'tCheckMethod'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCheckMethod')
	drop table PABackup.dbo.tCheckMethod
	 
	Select * Into PABackup.dbo.tCheckMethod FROM tCheckMethod (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tCheckMethod', @t output

	Print 'tClass'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tClass')
	drop table PABackup.dbo.tClass
	 
	Select * Into PABackup.dbo.tClass FROM tClass (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tClass', @t output

	Print 'tClientProduct'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tClientProduct')
	drop table PABackup.dbo.tClientProduct
	 
	Select * Into PABackup.dbo.tClientProduct FROM tClientProduct (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tClientProduct', @t output

	Print 'tClientDivision'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tClientDivision')
	drop table PABackup.dbo.tClientDivision
	 
	Select * Into PABackup.dbo.tClientDivision FROM tClientDivision (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tClientDivision', @t output

	Print 'tCMFolder'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCMFolder')
	drop table PABackup.dbo.tCMFolder
	 
	Select * Into PABackup.dbo.tCMFolder FROM tCMFolder (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tCMFolder', @t output

	Print 'tCMFolderIncludeInSync'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCMFolderIncludeInSync')
	drop table PABackup.dbo.tCMFolderIncludeInSync
	 
	Select tCMFolderIncludeInSync.* Into PABackup.dbo.tCMFolderIncludeInSync 
	FROM tCMFolderIncludeInSync (nolock), tCMFolder f (nolock)
	WHERE tCMFolderIncludeInSync.CMFolderKey = f.CMFolderKey
	and   f.CompanyKey = @CompanyKey

	exec spTime 'tCMFolderIncludeInSync', @t output

	Print 'tCMFolderSecurity'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCMFolderSecurity')
	drop table PABackup.dbo.tCMFolderSecurity
	 
	Select tCMFolderSecurity.* Into PABackup.dbo.tCMFolderSecurity 
	FROM  tCMFolderSecurity (nolock), tCMFolder f (nolock)
	WHERE tCMFolderSecurity.CMFolderKey = f.CMFolderKey
	and   f.CompanyKey = @CompanyKey
	
	exec spTime 'tCMFolderSecurity', @t output

	Print 'tColumnSet'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tColumnSet')
	drop table PABackup.dbo.tColumnSet
	 
	Select * Into PABackup.dbo.tColumnSet 
	FROM tColumnSet (NOLOCK)
	WHERE CompanyKey = @CompanyKey

	exec spTime 'tColumnSet', @t output

	Print 'tColumnSetDetail'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tColumnSetDetail')
	drop table PABackup.dbo.tColumnSetDetail
	 
	Select tColumnSetDetail.* Into PABackup.dbo.tColumnSetDetail 
	FROM tColumnSetDetail (NOLOCK)
		,tColumnSet b (NOLOCK)
	WHERE b.CompanyKey = @CompanyKey
	AND   tColumnSetDetail.ColumnSetKey = b.ColumnSetKey

	exec spTime 'tColumnSetDetail', @t output

	Print 'tCompany'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCompany')
	drop table PABackup.dbo.tCompany
	 
	Select * Into PABackup.dbo.tCompany FROM tCompany WHERE CompanyKey = @CompanyKey or OwnerCompanyKey = @CompanyKey
	
	exec spTime 'tCompany', @t output

	Print 'tCompanyMedia'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCompanyMedia')
	drop table PABackup.dbo.tCompanyMedia
	 
	Select * Into PABackup.dbo.tCompanyMedia FROM tCompanyMedia (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tCompanyMedia', @t output

	Print 'tCompanyMediaContact'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCompanyMediaContact')
	drop table PABackup.dbo.tCompanyMediaContact
	 
	Select tCompanyMediaContact.* Into PABackup.dbo.tCompanyMediaContact 
	FROM tCompanyMediaContact (NOLOCK)
		,tCompanyMedia b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tCompanyMediaContact.CompanyMediaKey = b.CompanyMediaKey
	
	exec spTime 'tCompanyMediaContact', @t output
	 
    Print 'tCompanyMediaAttributeValue'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCompanyMediaAttributeValue')
	drop table PABackup.dbo.tCompanyMediaAttributeValue
	 
	Select tCompanyMediaAttributeValue.* Into PABackup.dbo.tCompanyMediaAttributeValue 
	FROM tCompanyMediaAttributeValue (NOLOCK)
		,tCompanyMedia b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tCompanyMediaAttributeValue.CompanyMediaKey = b.CompanyMediaKey
	
	exec spTime 'tCompanyMediaAttributeValue', @t output
	 
	 Print 'tCompanyMediaContract'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCompanyMediaContract')
	drop table PABackup.dbo.tCompanyMediaContract
	 
	Select tCompanyMediaContract.* Into PABackup.dbo.tCompanyMediaContract 
	FROM tCompanyMediaContract (NOLOCK)
		,tCompanyMedia b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tCompanyMediaContract.CompanyMediaKey = b.CompanyMediaKey

	exec spTime 'tCompanyMediaContract', @t output

	Print 'tCompanyMediaContractClient'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCompanyMediaContractClient')
	drop table PABackup.dbo.tCompanyMediaContractClient
	 
	Select tCompanyMediaContractClient.* Into PABackup.dbo.tCompanyMediaContractClient 
	FROM tCompanyMediaContractClient (NOLOCK)
		,tCompanyMedia b (NOLOCK) 
		,tCompanyMediaContract c (nolock)
	WHERE b.CompanyKey = @CompanyKey
	AND   c.CompanyMediaKey = b.CompanyMediaKey
	AND   tCompanyMediaContractClient.CompanyMediaContractKey = c.CompanyMediaContractKey
 
	exec spTime 'tCompanyMediaContractClient', @t output

	Print 'tCompanyMediaContractDetail'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCompanyMediaContractDetail')
	drop table PABackup.dbo.tCompanyMediaContractDetail
	 
	Select tCompanyMediaContractDetail.* Into PABackup.dbo.tCompanyMediaContractDetail 
	FROM tCompanyMediaContractDetail (NOLOCK)
		,tCompanyMedia b (NOLOCK) 
		,tCompanyMediaContract c (nolock)
	WHERE b.CompanyKey = @CompanyKey
	AND   c.CompanyMediaKey = b.CompanyMediaKey
	AND   tCompanyMediaContractDetail.CompanyMediaContractKey = c.CompanyMediaContractKey
 
	exec spTime 'tCompanyMediaContractDetail', @t output

	Print 'tCompanyMediaPosition'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCompanyMediaPosition')
	drop table PABackup.dbo.tCompanyMediaPosition
	 
	Select tCompanyMediaPosition.* Into PABackup.dbo.tCompanyMediaPosition 
	FROM tCompanyMediaPosition (NOLOCK)
		,tCompanyMedia b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tCompanyMediaPosition.CompanyMediaKey = b.CompanyMediaKey

	exec spTime 'tCompanyMediaPosition', @t output

	Print 'tCompanyMediaPremium'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCompanyMediaPremium')
	drop table PABackup.dbo.tCompanyMediaPremium
	 
	Select tCompanyMediaPremium.* Into PABackup.dbo.tCompanyMediaPremium 
	FROM tCompanyMediaPremium (NOLOCK)
		,tCompanyMedia b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tCompanyMediaPremium.CompanyMediaKey = b.CompanyMediaKey

	exec spTime 'tCompanyMediaPremium', @t output

	Print 'tCompanyMediaSpace'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCompanyMediaSpace')
	drop table PABackup.dbo.tCompanyMediaSpace
	 
	Select tCompanyMediaSpace.* Into PABackup.dbo.tCompanyMediaSpace 
	FROM tCompanyMediaSpace (NOLOCK)
		,tCompanyMedia b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tCompanyMediaSpace.CompanyMediaKey = b.CompanyMediaKey

	exec spTime 'tCompanyMediaSpace', @t output

	Print 'tCompanyMediaSpillMarket'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCompanyMediaSpillMarket')
	drop table PABackup.dbo.tCompanyMediaSpillMarket
	 
	Select tCompanyMediaSpillMarket.* Into PABackup.dbo.tCompanyMediaSpillMarket 
	FROM tCompanyMediaSpillMarket (NOLOCK)
		,tCompanyMedia b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tCompanyMediaSpillMarket.CompanyMediaKey = b.CompanyMediaKey

	exec spTime 'tCompanyMediaSpillMarket', @t output

	Print 'tCompanyMediaVendor'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCompanyMediaVendor')
	drop table PABackup.dbo.tCompanyMediaVendor
	 
	Select tCompanyMediaVendor.* Into PABackup.dbo.tCompanyMediaVendor 
	FROM tCompanyMediaVendor (NOLOCK)
		,tCompanyMedia b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tCompanyMediaVendor.CompanyMediaKey = b.CompanyMediaKey

	exec spTime 'tCompanyMediaVendor', @t output

	Print 'tCurrency'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCurrency')
	drop table PABackup.dbo.tCurrency
	 
	Select * Into PABackup.dbo.tCurrency FROM tCurrency (nolock)

	Print 'tCurrencyRate'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCurrencyRate')
	drop table PABackup.dbo.tCurrencyRate
	 
	Select * Into PABackup.dbo.tCurrencyRate FROM tCurrencyRate (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tCurrencyRate', @t output

	Print 'tCompanyType'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tCompanyType')
	drop table PABackup.dbo.tCompanyType
	 
	Select * Into PABackup.dbo.tCompanyType FROM tCompanyType (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tCompanyType', @t output

	Print 'tContactActivity'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tContactActivity')
	drop table PABackup.dbo.tContactActivity
	 
	Select * Into PABackup.dbo.tContactActivity FROM tContactActivity (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tContactActivity', @t output

	Print 'tContactDatabase'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tContactDatabase')
	drop table PABackup.dbo.tContactDatabase
	 
	Select * Into PABackup.dbo.tContactDatabase FROM tContactDatabase (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tContactDatabase', @t output

	Print 'tContactDatabaseAssignment'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tContactDatabaseAssignment')
	drop table PABackup.dbo.tContactDatabaseAssignment
	 
	Select tContactDatabaseAssignment.* Into PABackup.dbo.tContactDatabaseAssignment 
	FROM tContactDatabaseAssignment (nolock), tContactDatabase cd (nolock)
	where tContactDatabaseAssignment.ContactDatabaseKey = cd.ContactDatabaseKey 
	and cd.CompanyKey = @CompanyKey 
	
	exec spTime 'tContactDatabaseAssignment', @t output
		 
	Print 'tContactDatabaseUser'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tContactDatabaseUser')
	drop table PABackup.dbo.tContactDatabaseUser
	 
	Select	tContactDatabaseUser.* Into PABackup.dbo.tContactDatabaseUser 
	FROM	tContactDatabaseUser (nolock), tContactDatabase cd (nolock)
	where	tContactDatabaseUser.ContactDatabaseKey = cd.ContactDatabaseKey 
	and		cd.CompanyKey = @CompanyKey
	
	exec spTime 'tContactDatabaseUser', @t output

	Print 'tDAClientFolder'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDAClientFolder')
	drop table PABackup.dbo.tDAClientFolder
	 
	Select tDAClientFolder.* Into PABackup.dbo.tDAClientFolder 
	FROM tDAClientFolder (nolock), tProject p (nolock)
	where tDAClientFolder.ProjectKey = p.ProjectKey 
	and p.CompanyKey = @CompanyKey
	
	exec spTime 'tDAClientFolder', @t output

	Print 'tDAFile'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDAFile')
	drop table PABackup.dbo.tDAFile
	 
	Select	tDAFile.* Into PABackup.dbo.tDAFile 
	FROM	tDAFile (nolock), tDAFolder fol (nolock), tProject p (nolock)
	where	tDAFile.FolderKey = fol.FolderKey 
	and		fol.ProjectKey = p.ProjectKey 
	and		p.CompanyKey = @CompanyKey
	
	exec spTime 'tDAFile', @t output

	Print 'tDAFileRight'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDAFileRight')
	drop table PABackup.dbo.tDAFileRight
	 
	Select tDAFileRight.* Into PABackup.dbo.tDAFileRight 
	FROM tDAFileRight (nolock), tDAFile f (nolock), tDAFolder fol (nolock), tProject p (nolock)
	where tDAFileRight.FileKey = f.FileKey 
	and f.FolderKey = fol.FolderKey 
	and fol.ProjectKey = p.ProjectKey 
	and p.CompanyKey = @CompanyKey
	
	exec spTime 'tDAFileRight', @t output

	Print 'tDAFileVersion'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDAFileVersion')
	drop table PABackup.dbo.tDAFileVersion
	 
	Select tDAFileVersion.* Into PABackup.dbo.tDAFileVersion 
	FROM tDAFileVersion (nolock), tDAFile f (nolock), tDAFolder fol (nolock), tProject p (nolock)
	where tDAFileVersion.FileKey = f.FileKey 
	and f.FolderKey = fol.FolderKey 
	and fol.ProjectKey = p.ProjectKey 
	and p.CompanyKey = @CompanyKey
	
	exec spTime 'tDAFileVersion', @t output

	Print 'tDAFolder'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDAFolder')
	drop table PABackup.dbo.tDAFolder
	 
	Select	tDAFolder.* Into PABackup.dbo.tDAFolder 
	from	tDAFolder (nolock), tProject p (nolock)
	where	tDAFolder.ProjectKey = p.ProjectKey 
	and		p.CompanyKey = @CompanyKey
	
	exec spTime 'tDAFolder', @t output

	Print 'tDAFolderRight'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDAFolderRight')
	drop table PABackup.dbo.tDAFolderRight
	 
	Select tDAFolderRight.* Into PABackup.dbo.tDAFolderRight 
	FROM tDAFolderRight (nolock), tDAFolder fol (nolock), tProject p (nolock) 
	where tDAFolderRight.FolderKey = fol.FolderKey 
	and fol.ProjectKey = p.ProjectKey 
	and p.CompanyKey = @CompanyKey
	
	exec spTime 'tDAFolderRight', @t output

	Print 'tDashboard'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDashboard')
	drop table PABackup.dbo.tDashboard
	 
	Select * Into PABackup.dbo.tDashboard FROM tDashboard (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tDashboard', @t output

	Print 'tDashboardGroup'
	if exists (select * from PABackup.dbo.sysobjects where name='tDashboardGroup')
	drop table PABackup.dbo.tDashboardGroup
	 
	Select	tDashboardGroup.* Into PABackup.dbo.tDashboardGroup 
	FROM	tDashboardGroup (nolock), tDashboard d (nolock)
	where	tDashboardGroup.DashboardKey = d.DashboardKey 
	and		d.CompanyKey = @CompanyKey
	
	exec spTime 'tDashboardGroup', @t output

	Print 'tDashboardModule'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDashboardModule')
	drop table PABackup.dbo.tDashboardModule
	 
	Select tDashboardModule.* Into PABackup.dbo.tDashboardModule 
	FROM tDashboardModule (nolock), tDashboard d (nolock)
	where tDashboardModule.DashboardKey = d.DashboardKey 
	and d.CompanyKey = @CompanyKey
	
	exec spTime 'tDashboardModule', @t output

	Print 'tDashboardModuleDef'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDashboardModuleDef')
	drop table PABackup.dbo.tDashboardModuleDef
	 
	Select * Into PABackup.dbo.tDashboardModuleDef FROM tDashboardModuleDef (nolock)

	exec spTime 'tDashboardModuleDef', @t output

	Print 'tDashboardModuleGroup'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDashboardModuleGroup')
	drop table PABackup.dbo.tDashboardModuleGroup
	 
	Select * Into PABackup.dbo.tDashboardModuleGroup FROM tDashboardModuleGroup (nolock)
	
	exec spTime 'tDashboardModuleGroup', @t output

	Print 'tDashboardModuleUser'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDashboardModuleUser')
	drop table PABackup.dbo.tDashboardModuleUser
	 
	Select tDashboardModuleUser.* Into PABackup.dbo.tDashboardModuleUser 
	FROM tDashboardModuleUser (nolock), tUser u (nolock)
	where tDashboardModuleUser.UserKey = u.UserKey 
	and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
	
	exec spTime 'tDashboardModuleUser', @t output

	Print 'tDBLog'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDBLog')
	drop table PABackup.dbo.tDBLog
	 
	Select tDBLog.* Into PABackup.dbo.tDBLog 
	FROM tDBLog (nolock), tUser u  (nolock)
	where tDBLog.UserKey = u.UserKey 
	and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
	
	exec spTime 'tDBLog', @t output

	Print 'tDepartment'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDepartment')
	drop table PABackup.dbo.tDepartment
	 
	Select * Into PABackup.dbo.tDepartment FROM tDepartment (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tDepartment', @t output

	Print 'tDistributionGroup'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDistributionGroup')
	drop table PABackup.dbo.tDistributionGroup
	 
	Select * Into PABackup.dbo.tDistributionGroup FROM tDistributionGroup (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tDistributionGroup', @t output

	Print 'tDistributionGroupUser'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDistributionGroupUser')
	drop table PABackup.dbo.tDistributionGroupUser
	 
	Select tDistributionGroupUser.* Into PABackup.dbo.tDistributionGroupUser
	FROM tDistributionGroupUser (NOLOCK)
	     ,tDistributionGroup b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tDistributionGroupUser.DistributionGroupKey = b.DistributionGroupKey
	
	exec spTime 'tDistributionGroupUser', @t output
	 
	Print 'tDeposit'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tDeposit')
	drop table PABackup.dbo.tDeposit
	 
	Select * Into PABackup.dbo.tDeposit FROM tDeposit (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tDeposit', @t output

	Print 'tEmailSendLog'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEmailSendLog')
	drop table PABackup.dbo.tEmailSendLog
	 
	--Select * Into PABackup.dbo.tEmailSendLog FROM tEmailSendLog (nolock) WHERE CompanyKey = @CompanyKey

	--exec spTime 'tEmailSendLog', @t output

	Print 'tEstimate'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimate')
	drop table PABackup.dbo.tEstimate
	 
	Select tEstimate.* Into PABackup.dbo.tEstimate 
	FROM	tEstimate  (nolock)
	Where	tEstimate.CompanyKey = @CompanyKey 

	exec spTime 'tEstimate', @t output

	Print 'tEstimateNotify'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateNotify')
	drop table PABackup.dbo.tEstimateNotify
	 
	Select tEstimateNotify.* Into PABackup.dbo.tEstimateNotify 
	FROM tEstimateNotify (NOLOCK), tEstimate (NOLOCK) 
	Where tEstimateNotify.EstimateKey = tEstimate.EstimateKey 
	and	tEstimate.CompanyKey = @CompanyKey
	
	exec spTime 'tEstimateNotify', @t output
	
	Print 'tEstimateProject'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateProject')
	drop table PABackup.dbo.tEstimateProject
	 
	Select tEstimateProject.* Into PABackup.dbo.tEstimateProject 
	FROM tEstimateProject (NOLOCK), tEstimate (NOLOCK) 
	Where tEstimateProject.EstimateKey = tEstimate.EstimateKey 
	and	tEstimate.CompanyKey = @CompanyKey
	
	exec spTime 'tEstimateProject', @t output
	
	Print 'tEstimateService'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateService')
	drop table PABackup.dbo.tEstimateService
	 
	Select tEstimateService.* Into PABackup.dbo.tEstimateService 
	FROM tEstimateService (NOLOCK), tEstimate (NOLOCK) 
	Where tEstimateService.EstimateKey = tEstimate.EstimateKey 
	and tEstimate.CompanyKey = @CompanyKey
	
	exec spTime 'tEstimateService', @t output
	
	Print 'tEstimateTask'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateTask')
	drop table PABackup.dbo.tEstimateTask
	 
	Select tEstimateTask.* Into PABackup.dbo.tEstimateTask 
	FROM tEstimateTask  (nolock), tEstimate  (nolock)
	Where tEstimateTask.EstimateKey = tEstimate.EstimateKey 
	and tEstimate.CompanyKey = @CompanyKey
	 
	exec spTime 'tEstimateTask', @t output
	
	Print 'tEstimateTaskExpense'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateTaskExpense')
	drop table PABackup.dbo.tEstimateTaskExpense
	 
	Select tEstimateTaskExpense.* Into PABackup.dbo.tEstimateTaskExpense 
	FROM tEstimateTaskExpense (nolock), tEstimate e  (nolock)
	where tEstimateTaskExpense.EstimateKey = e.EstimateKey 
	and e.CompanyKey = @CompanyKey
	 
	exec spTime 'tEstimateTaskExpense', @t output
	
	Print 'tEstimateTaskExpenseOrder'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateTaskExpenseOrder')
	drop table PABackup.dbo.tEstimateTaskExpenseOrder
	 
	Select tEstimateTaskExpenseOrder.* Into PABackup.dbo.tEstimateTaskExpenseOrder 
	FROM tEstimateTaskExpenseOrder (nolock), tEstimateTaskExpense ete (nolock), tEstimate e  (nolock)
	where ete.EstimateKey = e.EstimateKey 
	and e.CompanyKey = @CompanyKey
	and tEstimateTaskExpenseOrder.EstimateTaskExpenseKey = ete.EstimateTaskExpenseKey
	 
	exec spTime 'tEstimateTaskExpenseOrder', @t output
	
	Print 'tEstimateTaskLabor'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateTaskLabor')
	drop table PABackup.dbo.tEstimateTaskLabor
	 
	Select tEstimateTaskLabor.* Into PABackup.dbo.tEstimateTaskLabor 
	FROM tEstimateTaskLabor (nolock), tEstimate e  (nolock)
	where tEstimateTaskLabor.EstimateKey = e.EstimateKey 
	and e.CompanyKey = @CompanyKey

	exec spTime 'tEstimateTaskLabor', @t output
	
	Print 'tEstimateTaskLaborLevel'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateTaskLaborLevel')
	drop table PABackup.dbo.tEstimateTaskLaborLevel
	 
	Select tEstimateTaskLaborLevel.* Into PABackup.dbo.tEstimateTaskLaborLevel 
	FROM tEstimateTaskLaborLevel  (nolock), tEstimate e  (nolock)
	where tEstimateTaskLaborLevel.EstimateKey = e.EstimateKey 
	and e.CompanyKey = @CompanyKey

	exec spTime 'tEstimateTaskLaborLevel', @t output
	
	Print 'tEstimateTaskLaborTitle'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateTaskLaborTitle')
	drop table PABackup.dbo.tEstimateTaskLaborTitle
	 
	Select tEstimateTaskLaborTitle.* Into PABackup.dbo.tEstimateTaskLaborTitle 
	FROM tEstimateTaskLaborTitle (nolock), tEstimate e  (nolock)
	where tEstimateTaskLaborTitle.EstimateKey = e.EstimateKey 
	and e.CompanyKey = @CompanyKey

	exec spTime 'tEstimateTaskLaborTitle', @t output
	
	Print 'tEstimateTaskAssignmentLabor'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateTaskAssignmentLabor')
	drop table PABackup.dbo.tEstimateTaskAssignmentLabor
	 
	Select tEstimateTaskAssignmentLabor.* Into PABackup.dbo.tEstimateTaskAssignmentLabor 
	FROM tEstimateTaskAssignmentLabor (nolock), tEstimate e  (nolock)
	where tEstimateTaskAssignmentLabor.EstimateKey = e.EstimateKey 
	and e.CompanyKey = @CompanyKey
	
	exec spTime 'tEstimateTaskAssignmentLabor', @t output
	
	Print 'tEstimateTaskTemp'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateTaskTemp')
	drop table PABackup.dbo.tEstimateTaskTemp
	 
	Select tEstimateTaskTemp.* Into PABackup.dbo.tEstimateTaskTemp 
	FROM tEstimateTaskTemp (nolock) , tProject p (nolock) 
	where tEstimateTaskTemp.ProjectKey = p.ProjectKey 
	and p.CompanyKey = @CompanyKey

	exec spTime 'tEstimateTaskTemp', @t output
	
	Print 'tEstimateTaskTempPredecessor'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateTaskTempPredecessor')
	drop table PABackup.dbo.tEstimateTaskTempPredecessor
	 
	Select tEstimateTaskTempPredecessor.* Into PABackup.dbo.tEstimateTaskTempPredecessor 
	FROM tEstimateTaskTempPredecessor (nolock) , tTask t (nolock) , tProject p (nolock) 
	where tEstimateTaskTempPredecessor.TaskKey = t.TaskKey 
	and   t.ProjectKey = p.ProjectKey 
	and   p.CompanyKey = @CompanyKey
 
    exec spTime 'tEstimateTaskTempPredecessor', @t output
	
	Print 'tEstimateTaskTempUser'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateTaskTempUser')
	drop table PABackup.dbo.tEstimateTaskTempUser
	 
	Select tEstimateTaskTempUser.* Into PABackup.dbo.tEstimateTaskTempUser 
	FROM tEstimateTaskTempUser, tTask t (nolock) , tProject p (nolock)  
	where tEstimateTaskTempUser.TaskKey = t.TaskKey 
	and   t.ProjectKey = p.ProjectKey 
	and   p.CompanyKey = @CompanyKey

	exec spTime 'tEstimateTaskTempUser', @t output
	
	Print 'tEstimateTemplate'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateTemplate')
	drop table PABackup.dbo.tEstimateTemplate
	 
	Select * Into PABackup.dbo.tEstimateTemplate FROM tEstimateTemplate (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tEstimateTemplate', @t output
	
	Print 'tEstimateUser'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tEstimateUser')
	drop table PABackup.dbo.tEstimateUser
	 
	Select tEstimateUser.* Into PABackup.dbo.tEstimateUser 
	FROM tEstimateUser (nolock), tEstimate e (nolock)
	where tEstimateUser.EstimateKey = e.EstimateKey 
	and e.CompanyKey = @CompanyKey
	
	exec spTime 'tEstimateUser', @t output
	
	Print 'tExpenseEnvelope'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tExpenseEnvelope')
	drop table PABackup.dbo.tExpenseEnvelope
	 
	Select * Into PABackup.dbo.tExpenseEnvelope FROM tExpenseEnvelope (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tExpenseEnvelope', @t output
	
	Print 'tExpenseReceipt'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tExpenseReceipt')
	drop table PABackup.dbo.tExpenseReceipt
	 
	Select tExpenseReceipt.* Into PABackup.dbo.tExpenseReceipt 
	FROM tExpenseReceipt (nolock), tExpenseEnvelope (nolock) 
	Where tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey 
	and tExpenseEnvelope.CompanyKey = @CompanyKey
	
	exec spTime 'tExpenseReceipt', @t output
	
	Print 'tExpenseType'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tExpenseType')
	drop table PABackup.dbo.tExpenseType
	 
	Select * Into PABackup.dbo.tExpenseType FROM tExpenseType (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tExpenseType', @t output
	
	Print 'tFieldDef'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tFieldDef')
	drop table PABackup.dbo.tFieldDef
	 
	Select	* Into PABackup.dbo.tFieldDef 
	from	tFieldDef (nolock)
	where	OwnerEntityKey = @CompanyKey
	
	exec spTime 'tFieldDef', @t output
	
	Print 'tFieldSet'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tFieldSet')
	drop table PABackup.dbo.tFieldSet
	 
	Select	* Into PABackup.dbo.tFieldSet 
	FROM	tFieldSet (nolock)
	WHERE	OwnerEntityKey = @CompanyKey
	and		AssociatedEntity != 'Forms'
	
	SET IDENTITY_INSERT PABackup.dbo.tFieldSet ON

	Insert	PABackup.dbo.tFieldSet (FieldSetKey, OwnerEntityKey, AssociatedEntity, FieldSetName, Active)
	Select	tFieldSet.FieldSetKey, tFieldSet.OwnerEntityKey, tFieldSet.AssociatedEntity, tFieldSet.FieldSetName, tFieldSet.Active
	FROM	tFieldSet (nolock), tFormDef fd (nolock)
	where	tFieldSet.AssociatedEntity = 'Forms'
	and		tFieldSet.OwnerEntityKey = fd.FormDefKey
	and		fd.CompanyKey = @CompanyKey 
	
	exec spTime 'tFieldSet', @t output
	
	Print 'tFieldSetField'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tFieldSetField')
	drop table PABackup.dbo.tFieldSetField
	 
	Select	tFieldSetField.* Into PABackup.dbo.tFieldSetField
	FROM	tFieldSetField (nolock) , tFieldDef fd (nolock)
	where	tFieldSetField.FieldDefKey = fd.FieldDefKey
	and		fd.OwnerEntityKey = @CompanyKey
	 
	exec spTime 'tFieldSetField', @t output
	
	Print 'tFieldValue'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tFieldValue')
	drop table PABackup.dbo.tFieldValue
	 
	Select	tFieldValue.* Into PABackup.dbo.tFieldValue 
	FROM	tFieldValue (nolock), tFieldDef fd (nolock)
	where	tFieldValue.FieldDefKey = fd.FieldDefKey
	and		fd.OwnerEntityKey = @CompanyKey
	

	exec spTime 'tFieldValue', @t output
	
	Print 'tFlatFile'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tFlatFile')
	drop table PABackup.dbo.tFlatFile
	 
	Select * Into PABackup.dbo.tFlatFile FROM tFlatFile (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tFlatFile', @t output
	
	Print 'tFlatFileDetail'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tFlatFileDetail')
	drop table PABackup.dbo.tFlatFileDetail
	 
	Select tFlatFileDetail.* Into PABackup.dbo.tFlatFileDetail 
	FROM tFlatFileDetail (nolock), tFlatFile (nolock) 
	Where tFlatFileDetail.FlatFileKey = tFlatFile.FlatFileKey 
	and tFlatFile.CompanyKey = @CompanyKey
	
	exec spTime 'tFlatFileDetail', @t output
	
	Print 'tFinancialInstitution'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tFinancialInstitution')
	drop table PABackup.dbo.tFinancialInstitution
	 
	Select * Into PABackup.dbo.tFinancialInstitution FROM tFinancialInstitution (nolock) 
	
	exec spTime 'tFinancialInstitution', @t output
	
	Print 'tForm'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tForm')
	drop table PABackup.dbo.tForm
	 
	Select * Into PABackup.dbo.tForm FROM tForm (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tForm', @t output
	
	Print 'tFormDef'

	if exists (select * from PABackup.dbo.sysobjects where name='tFormDef')
	drop table PABackup.dbo.tFormDef
	 
	Select * Into PABackup.dbo.tFormDef FROM tFormDef WHERE CompanyKey = @CompanyKey
	 
	exec spTime 'tFormDef', @t output
	
	Print 'tFormDefSecurityGroup'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tFormDefSecurityGroup')
	drop table PABackup.dbo.tFormDefSecurityGroup
	 
	Select	tFormDefSecurityGroup.* Into PABackup.dbo.tFormDefSecurityGroup 
	FROM	tFormDefSecurityGroup (nolock), tFormDef fd (nolock)
	where	tFormDefSecurityGroup.FormDefKey = fd.FormDefKey
	and		fd.CompanyKey = @CompanyKey
	
	exec spTime 'tFormDefSecurityGroup', @t output
	
	Print 'tFormSubscription'
	if exists (select * from PABackup.dbo.sysobjects where name='tFormSubscription')
	drop table PABackup.dbo.tFormSubscription
	 
	Select tFormSubscription.* Into PABackup.dbo.tFormSubscription 
	FROM tFormSubscription (nolock), tUser  (nolock)
	Where tFormSubscription.UserKey = tUser.UserKey 
	and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey)	 

	exec spTime 'tFormSubscription', @t output
	
	Print 'tFormTemplate'
	if exists (select * from PABackup.dbo.sysobjects where name='tFormTemplate')
	drop table PABackup.dbo.tFormTemplate
	
	Select * Into PABackup.dbo.tFormTemplate FROM tFormTemplate (nolock) WHERE CompanyKey = @CompanyKey
	

	exec spTime 'tFormTemplate', @t output
	
	Print 'tForecast'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tForecast')
	drop table PABackup.dbo.tForecast
	 
	Select * Into PABackup.dbo.tForecast FROM tForecast (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tForecast', @t output
	
	Print 'tForecastDetail'

	if exists (select * from PABackup.dbo.sysobjects where name='tForecastDetail')
	drop table PABackup.dbo.tForecastDetail
	 
	Select	tForecastDetail.* Into PABackup.dbo.tForecastDetail 
	FROM	tForecastDetail (nolock), tForecast f (nolock)
	where	tForecastDetail.ForecastKey = f.ForecastKey
	and		f.CompanyKey = @CompanyKey

	exec spTime 'tForecastDetail', @t output
	
	Print 'tForecastDetailItem'

	if exists (select * from PABackup.dbo.sysobjects where name='tForecastDetailItem')
	drop table PABackup.dbo.tForecastDetailItem
	 
	Select	tForecastDetailItem.* Into PABackup.dbo.tForecastDetailItem 
	FROM	tForecastDetailItem (nolock), tForecastDetail fd (nolock), tForecast f (nolock)
	where	fd.ForecastKey = f.ForecastKey
	and		f.CompanyKey = @CompanyKey
	and     tForecastDetailItem.ForecastDetailKey = fd.ForecastDetailKey

	exec spTime 'tForecastDetailItem', @t output
	
	Print 'tFormDefSecurityGroup'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tFormDefSecurityGroup')
	drop table PABackup.dbo.tFormDefSecurityGroup
	 
	Select	tFormDefSecurityGroup.* Into PABackup.dbo.tFormDefSecurityGroup 
	FROM	tFormDefSecurityGroup (nolock), tFormDef fd (nolock)
	where	tFormDefSecurityGroup.FormDefKey = fd.FormDefKey
	and		fd.CompanyKey = @CompanyKey


	exec spTime 'tFormDefSecurityGroup', @t output
	
	Print 'tGLAccount'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tGLAccount')
	drop table PABackup.dbo.tGLAccount
	 
	Select * Into PABackup.dbo.tGLAccount FROM tGLAccount (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tGLAccount', @t output
	
	Print 'tGLAccountRec'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tGLAccountRec')
	drop table PABackup.dbo.tGLAccountRec
	 
	Select * Into PABackup.dbo.tGLAccountRec FROM tGLAccountRec (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tGLAccountRec', @t output
	
	Print 'tGLAccountRecDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tGLAccountRecDetail')
	drop table PABackup.dbo.tGLAccountRecDetail
	 
	Select tGLAccountRecDetail.* Into PABackup.dbo.tGLAccountRecDetail 
	FROM tGLAccountRecDetail (nolock), tGLAccountRec glar (nolock) 
	where tGLAccountRecDetail.GLAccountRecKey = glar.GLAccountRecKey 
	and glar.CompanyKey = @CompanyKey
	
	exec spTime 'tGLAccountRecDetail', @t output
	
	Print 'tGLAccountMultiCompanyPayments'
	if exists (select * from PABackup.dbo.sysobjects where name='tGLAccountMultiCompanyPayments')
	drop table PABackup.dbo.tGLAccountMultiCompanyPayments
	 
	Select * Into PABackup.dbo.tGLAccountMultiCompanyPayments FROM tGLAccountMultiCompanyPayments (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tGLAccountMultiCompanyPayments', @t output
	
	Print 'tGLAccountRecUnmatched'
	if exists (select * from PABackup.dbo.sysobjects where name='tGLAccountRecUnmatched')
	drop table PABackup.dbo.tGLAccountRecUnmatched
	 
	Select * Into PABackup.dbo.tGLAccountRecUnmatched FROM tGLAccountRecUnmatched (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tGLAccountRecUnmatched', @t output
	
	Print 'tGLAccountUser'
	if exists (select * from PABackup.dbo.sysobjects where name='tGLAccountUser')
	drop table PABackup.dbo.tGLAccountUser
	 
	Select tGLAccountUser.* Into PABackup.dbo.tGLAccountUser 
	FROM tGLAccountUser (nolock), tGLAccount gla  (nolock)
	where tGLAccountUser.GLAccountKey = gla.GLAccountKey 
	and gla.CompanyKey = @CompanyKey
	
	exec spTime 'tGLAccountUser', @t output
	
	Print 'tGLBudget'
	if exists (select * from PABackup.dbo.sysobjects where name='tGLBudget')
	drop table PABackup.dbo.tGLBudget
	 
	Select * Into PABackup.dbo.tGLBudget FROM tGLBudget (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tGLBudget', @t output
	
	Print 'tGLBudgetDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tGLBudgetDetail')
	drop table PABackup.dbo.tGLBudgetDetail
	 
	Select tGLBudgetDetail.* Into PABackup.dbo.tGLBudgetDetail 
	FROM tGLBudgetDetail (nolock), tGLAccount gla  (nolock)
	where tGLBudgetDetail.GLAccountKey = gla.GLAccountKey 
	and gla.CompanyKey = @CompanyKey
	
	exec spTime 'tGLBudgetDetail', @t output
	
	Print 'tGLCompany'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tGLCompany')
	drop table PABackup.dbo.tGLCompany
	 
	Select tGLCompany.* Into PABackup.dbo.tGLCompany 
	FROM tGLCompany (nolock)
	where tGLCompany.CompanyKey = @CompanyKey
	
	exec spTime 'tGLCompany', @t output
	
	Print 'tGLCompanyAccess'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tGLCompanyAccess')
	drop table PABackup.dbo.tGLCompanyAccess
	 
	Select tGLCompanyAccess.* Into PABackup.dbo.tGLCompanyAccess 
	FROM tGLCompanyAccess (nolock)
	where tGLCompanyAccess.CompanyKey = @CompanyKey

	exec spTime 'tGLCompanyAccess', @t output
	
	Print 'tGLCompanyMap'
	
	if exists (select * from PABackup.dbo.sysobjects where name='tGLCompanyMap')
	drop table PABackup.dbo.tGLCompanyMap
	 
	Select tGLCompanyMap.* Into PABackup.dbo.tGLCompanyMap 
	FROM tGLCompanyMap (nolock), tGLCompany (nolock)
	where tGLCompanyMap.TargetGLCompanyKey = tGLCompany.GLCompanyKey 
	and   tGLCompany.CompanyKey = @CompanyKey
	
	exec spTime 'tGLCompanyMap', @t output
	
	Print 'tImport'
	if exists (select * from PABackup.dbo.sysobjects where name='tImport')
	drop table PABackup.dbo.tImport
	 
	Select * Into PABackup.dbo.tImport FROM tImport (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tImport', @t output
	
	Print 'tInvoice'
	if exists (select * from PABackup.dbo.sysobjects where name='tInvoice')
	drop table PABackup.dbo.tInvoice
	 
	Select * Into PABackup.dbo.tInvoice FROM tInvoice (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tInvoice', @t output
	
	Print 'tInvoiceAdvanceBill'
	if exists (select * from PABackup.dbo.sysobjects where name='tInvoiceAdvanceBill')
	drop table PABackup.dbo.tInvoiceAdvanceBill
	 
	Select tInvoiceAdvanceBill.* Into PABackup.dbo.tInvoiceAdvanceBill 
	FROM tInvoiceAdvanceBill (nolock), tInvoice i  (nolock)
	where tInvoiceAdvanceBill.InvoiceKey = i.InvoiceKey 
	and i.CompanyKey = @CompanyKey

	exec spTime 'tInvoiceAdvanceBill', @t output
	
	Print 'tInvoiceAdvanceBillSale'
	if exists (select * from PABackup.dbo.sysobjects where name='tInvoiceAdvanceBillSale')
	drop table PABackup.dbo.tInvoiceAdvanceBillSale
	 
	Select tInvoiceAdvanceBillSale.* Into PABackup.dbo.tInvoiceAdvanceBillSale 
	FROM tInvoiceAdvanceBillSale (nolock), tInvoice i  (nolock)
	where tInvoiceAdvanceBillSale.InvoiceKey = i.InvoiceKey 
	and i.CompanyKey = @CompanyKey

	exec spTime 'tInvoiceAdvanceBillSale', @t output
	
	Print 'tInvoiceAdvanceBillTax'
	if exists (select * from PABackup.dbo.sysobjects where name='tInvoiceAdvanceBillTax')
	drop table PABackup.dbo.tInvoiceAdvanceBillTax
	 
	Select tInvoiceAdvanceBillTax.* Into PABackup.dbo.tInvoiceAdvanceBillTax 
	FROM tInvoiceAdvanceBillTax (nolock), tInvoice i  (nolock)
	where tInvoiceAdvanceBillTax.InvoiceKey = i.InvoiceKey 
	and i.CompanyKey = @CompanyKey
	
	exec spTime 'tInvoiceAdvanceBillTax', @t output
	
	Print 'tInvoiceCredit'
	if exists (select * from PABackup.dbo.sysobjects where name='tInvoiceCredit')
	drop table PABackup.dbo.tInvoiceCredit
	 
	Select	tInvoiceCredit.* Into PABackup.dbo.tInvoiceCredit 
	FROM	tInvoiceCredit (nolock), tInvoice  (nolock)
	Where	tInvoiceCredit.InvoiceKey = tInvoice.InvoiceKey 
	and		tInvoice.CompanyKey = @CompanyKey
	
	exec spTime 'tInvoiceCredit', @t output
	
	Print 'tInvoiceLine'
	if exists (select * from PABackup.dbo.sysobjects where name='tInvoiceLine')
	drop table PABackup.dbo.tInvoiceLine
	 
	Select	tInvoiceLine.* Into PABackup.dbo.tInvoiceLine 
	FROM	tInvoiceLine (nolock) , tInvoice (NOLOCK)
	Where	tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey 
	and		tInvoice.CompanyKey = @CompanyKey

	exec spTime 'tInvoiceLine', @t output
	
	Print 'tInvoiceLineTax'
	if exists (select * from PABackup.dbo.sysobjects where name='tInvoiceLineTax')
	drop table PABackup.dbo.tInvoiceLineTax
	 
	Select	tInvoiceLineTax.* Into PABackup.dbo.tInvoiceLineTax 
	FROM	tInvoiceLineTax (NOLOCK), tInvoiceLine (NOLOCK), tInvoice (NOLOCK) 
	Where	tInvoiceLineTax.InvoiceLineKey = tInvoiceLine.InvoiceLineKey
	and     tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey 
	and		tInvoice.CompanyKey = @CompanyKey
	
	exec spTime 'tInvoiceLineTax', @t output
	
	Print 'tInvoiceSummary'
	if exists (select * from PABackup.dbo.sysobjects where name='tInvoiceSummary')
	drop table PABackup.dbo.tInvoiceSummary
	 
	Select	tInvoiceSummary.* Into PABackup.dbo.tInvoiceSummary 
	FROM	tInvoiceSummary (nolock) , tInvoice (NOLOCK)
	Where	tInvoiceSummary.InvoiceKey = tInvoice.InvoiceKey 
	and		tInvoice.CompanyKey = @CompanyKey
	
	exec spTime 'tInvoiceSummary', @t output
	
	Print 'tInvoiceSummaryTitle'
	if exists (select * from PABackup.dbo.sysobjects where name='tInvoiceSummaryTitle')
	drop table PABackup.dbo.tInvoiceSummaryTitle
	 
	Select	tInvoiceSummaryTitle.* Into PABackup.dbo.tInvoiceSummaryTitle 
	FROM	tInvoiceSummaryTitle (nolock) , tInvoice (NOLOCK)
	Where	tInvoiceSummaryTitle.InvoiceKey = tInvoice.InvoiceKey 
	and		tInvoice.CompanyKey = @CompanyKey

	exec spTime 'tInvoiceSummaryTitle', @t output
	
	Print 'tInvoiceTax'
	if exists (select * from PABackup.dbo.sysobjects where name='tInvoiceTax')
	drop table PABackup.dbo.tInvoiceTax
	 
	Select	tInvoiceTax.* Into PABackup.dbo.tInvoiceTax 
	FROM	tInvoiceTax (nolock) , tInvoice (nolock) 
	Where	tInvoiceTax.InvoiceKey = tInvoice.InvoiceKey 
	and		tInvoice.CompanyKey = @CompanyKey
	
	exec spTime 'tInvoiceTax', @t output
	
	Print 'tInvoiceTemplate'
	if exists (select * from PABackup.dbo.sysobjects where name='tInvoiceTemplate')
	drop table PABackup.dbo.tInvoiceTemplate
	 
	Select * Into PABackup.dbo.tInvoiceTemplate FROM tInvoiceTemplate (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tInvoiceTemplate', @t output
	
	Print 'tISCI'
	if exists (select * from PABackup.dbo.sysobjects where name='tISCI')
	drop table PABackup.dbo.tISCI
	 
	Select tISCI.* Into PABackup.dbo.tISCI 
	FROM tISCI (nolock), tProject (nolock) 
	Where tISCI.ProjectKey = tProject.ProjectKey 
	and tProject.CompanyKey = @CompanyKey
	
	exec spTime 'tISCI', @t output
	
	Print 'tItem'
	if exists (select * from PABackup.dbo.sysobjects where name='tItem')
	drop table PABackup.dbo.tItem
	 
	Select * Into PABackup.dbo.tItem FROM tItem (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tItem', @t output
	
	Print 'tItemRateSheet'
	if exists (select * from PABackup.dbo.sysobjects where name='tItemRateSheet')
	drop table PABackup.dbo.tItemRateSheet
	 
	Select * Into PABackup.dbo.tItemRateSheet FROM tItemRateSheet (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tItemRateSheet', @t output
	
	Print 'tItemRateSheetDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tItemRateSheetDetail')
	drop table PABackup.dbo.tItemRateSheetDetail
	 
	Select tItemRateSheetDetail.* Into PABackup.dbo.tItemRateSheetDetail 
	FROM tItemRateSheetDetail (nolock), tItemRateSheet ir (nolock)
	where tItemRateSheetDetail.ItemRateSheetKey = ir.ItemRateSheetKey 
	and ir.CompanyKey = @CompanyKey
	
	exec spTime 'tItemRateSheetDetail', @t output
	
	Print 'tJournalEntry'
	if exists (select * from PABackup.dbo.sysobjects where name='tJournalEntry')
	drop table PABackup.dbo.tJournalEntry
	 
	Select * Into PABackup.dbo.tJournalEntry FROM tJournalEntry (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tJournalEntry', @t output
	
	Print 'tJournalEntryDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tJournalEntryDetail')
	drop table PABackup.dbo.tJournalEntryDetail
	 
	Select tJournalEntryDetail.* Into PABackup.dbo.tJournalEntryDetail 
	FROM tJournalEntryDetail (nolock) , tJournalEntry je (nolock) 
	where tJournalEntryDetail.JournalEntryKey = je.JournalEntryKey 
	and je.CompanyKey = @CompanyKey

	exec spTime 'tJournalEntryDetail', @t output
	
	Print 'tLab'
	if exists (select * from PABackup.dbo.sysobjects where name='tLab')
	drop table PABackup.dbo.tLab
	 
	Select * Into PABackup.dbo.tLab FROM tLab (nolock) 

	exec spTime 'tLab', @t output
	
	Print 'tLabBeta'
	if exists (select * from PABackup.dbo.sysobjects where name='tLabBeta')
	drop table PABackup.dbo.tLabBeta
	 
	Select * Into PABackup.dbo.tLabBeta FROM tLabBeta (nolock) where CompanyKey = @CompanyKey 
	
	exec spTime 'tLabBeta', @t output
	
	Print 'tLabCompany'
	if exists (select * from PABackup.dbo.sysobjects where name='tLabCompany')
	drop table PABackup.dbo.tLabCompany
	 
	Select * Into PABackup.dbo.tLabCompany FROM tLabCompany  (nolock) where CompanyKey = @CompanyKey 
	
	exec spTime 'tLabCompany', @t output
	
	Print 'tLaborBudget'
	if exists (select * from PABackup.dbo.sysobjects where name='tLaborBudget')
	drop table PABackup.dbo.tLaborBudget
	 
	Select * Into PABackup.dbo.tLaborBudget FROM tLaborBudget (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tLaborBudget', @t output
	
	Print 'tLaborBudgetDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tLaborBudgetDetail')
	drop table PABackup.dbo.tLaborBudgetDetail
	 
	Select tLaborBudgetDetail.* Into PABackup.dbo.tLaborBudgetDetail 
	FROM tLaborBudgetDetail (nolock), tLaborBudget lb  (nolock)
	where tLaborBudgetDetail.LaborBudgetKey = lb.LaborBudgetKey 
	and lb.CompanyKey = @CompanyKey
	
	exec spTime 'tLaborBudgetDetail', @t output
	
	Print 'tLayout'
	if exists (select * from PABackup.dbo.sysobjects where name='tLayout')
	drop table PABackup.dbo.tLayout
	 
	Select * Into PABackup.dbo.tLayout FROM tLayout (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tLayout', @t output
	
	Print 'tLayoutBilling'
	if exists (select * from PABackup.dbo.sysobjects where name='tLayoutBilling')
	drop table PABackup.dbo.tLayoutBilling
	 
	Select tLayoutBilling.* Into PABackup.dbo.tLayoutBilling 
	FROM tLayoutBilling (nolock) , tLayout l (nolock) 
	where tLayoutBilling.LayoutKey = l.LayoutKey 
	and l.CompanyKey = @CompanyKey

	exec spTime 'tLayoutBilling', @t output
	
	Print 'tLayoutReport'
	if exists (select * from PABackup.dbo.sysobjects where name='tLayoutReport')
	drop table PABackup.dbo.tLayoutReport
	 
	Select tLayoutReport.* Into PABackup.dbo.tLayoutReport 
	FROM tLayoutReport (nolock) , tLayout l (nolock) 
	where tLayoutReport.LayoutKey = l.LayoutKey 
	and l.CompanyKey = @CompanyKey

	exec spTime 'tLayoutReport', @t output
	
	Print 'tLayoutItems'
	if exists (select * from PABackup.dbo.sysobjects where name='tLayoutItems')
	drop table PABackup.dbo.tLayoutItems
	 
	Select tLayoutItems.* Into PABackup.dbo.tLayoutItems 
	FROM tLayoutItems (nolock) , tLayoutReport (nolock) , tLayout l (nolock)  
	where tLayoutItems.LayoutReportKey = tLayoutReport.LayoutReportKey 
	and tLayoutReport.LayoutKey = l.LayoutKey 
	and l.CompanyKey = @CompanyKey

	exec spTime 'tLayoutItems', @t output
	
	Print 'tLayoutSection'
	if exists (select * from PABackup.dbo.sysobjects where name='tLayoutSection')
	drop table PABackup.dbo.tLayoutSection
	 
	Select tLayoutSection.* Into PABackup.dbo.tLayoutSection 
	FROM tLayoutSection (nolock) , tLayoutReport (nolock) , tLayout l (nolock) 
	where tLayoutSection.LayoutReportKey = tLayoutReport.LayoutReportKey 
	and tLayoutReport.LayoutKey = l.LayoutKey 
	and l.CompanyKey = @CompanyKey

	exec spTime 'tLayoutSection', @t output
	
	Print 'tLead'
	if exists (select * from PABackup.dbo.sysobjects where name='tLead')
	drop table PABackup.dbo.tLead
	 
	Select * Into PABackup.dbo.tLead FROM tLead (nolock) WHERE CompanyKey = @CompanyKey
	 
	exec spTime 'tLead', @t output
	
	Print 'tLeadStageHistory'
	if exists (select * from PABackup.dbo.sysobjects where name='tLeadStageHistory')
	drop table PABackup.dbo.tLeadStageHistory
	 
	Select tLeadStageHistory.* Into PABackup.dbo.tLeadStageHistory 
	FROM tLeadStageHistory (nolock), tLead l  (nolock)
	where tLeadStageHistory.LeadKey = l.LeadKey 
	and l.CompanyKey = @CompanyKey
	 
	exec spTime 'tLeadStageHistory', @t output
	
	Print 'tLeadOutcome'
	if exists (select * from PABackup.dbo.sysobjects where name='tLeadOutcome')
	drop table PABackup.dbo.tLeadOutcome
	 
	Select * Into PABackup.dbo.tLeadOutcome FROM tLeadOutcome (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tLeadOutcome', @t output
	
	Print 'tLeadStage'
	if exists (select * from PABackup.dbo.sysobjects where name='tLeadStage')
	drop table PABackup.dbo.tLeadStage
	 
	Select * Into PABackup.dbo.tLeadStage FROM tLeadStage (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime '', @t output
	
	Print 'tLeadStatus'
	if exists (select * from PABackup.dbo.sysobjects where name='tLeadStatus')
	drop table PABackup.dbo.tLeadStatus
	 
	Select * Into PABackup.dbo.tLeadStatus FROM tLeadStatus (nolock) WHERE CompanyKey = @CompanyKey
	 
	exec spTime 'tLeadStatus', @t output
	
	Print 'tLeadUser'
	if exists (select * from PABackup.dbo.sysobjects where name='tLeadUser')
	drop table PABackup.dbo.tLeadUser
	 
	Select tLeadUser.* Into PABackup.dbo.tLeadUser 
	FROM tLeadUser (nolock), tLead l  (nolock)
	where tLeadUser.LeadKey = l.LeadKey 
	and l.CompanyKey = @CompanyKey

	exec spTime 'tLeadUser', @t output
	
	Print 'tLevelHistory : tCompany'
	if exists (select * from PABackup.dbo.sysobjects where name='tLevelHistory')
	drop table PABackup.dbo.tLevelHistory
	 
	Select tLevelHistory.* Into PABackup.dbo.tLevelHistory 
	FROM tLevelHistory (nolock), tCompany c  (nolock)
	where tLevelHistory.Entity = 'tCompany'
	and   tLevelHistory.EntityKey = c.CompanyKey 
	and isnull(c.OwnerCompanyKey, c.CompanyKey) = @CompanyKey
	
	exec spTime 'tLevelHistory : tCompany', @t output
	
	Print 'tLevelHistory : tLead'
	
	Insert PABackup.dbo.tLevelHistory 
	Select tLevelHistory.*  
	FROM tLevelHistory (nolock), tLead l  (nolock)
	where tLevelHistory.Entity = 'tLead'
	and   tLevelHistory.EntityKey = l.LeadKey 
	and l.CompanyKey = @CompanyKey
	
	exec spTime 'tLevelHistory : tLead', @t output
	
	Print 'tLevelHistory : tUser'
	
	Insert PABackup.dbo.tLevelHistory 
	Select tLevelHistory.*  
	FROM tLevelHistory (nolock), tUser u  (nolock)
	where tLevelHistory.Entity = 'tUser'
	and   tLevelHistory.EntityKey = u.UserKey 
	and isnull(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey
	
	exec spTime 'tLevelHistory : tUser', @t output
	
	Print 'tLink'
	if exists (select * from PABackup.dbo.sysobjects where name='tLink')
	drop table PABackup.dbo.tLink
	 
	exec spTime 'tLink', @t output
	
	Print 'tLink: ApprovalItem'
	Select	tLink.* Into PABackup.dbo.tLink 
	FROM	tLink (nolock), tApprovalItem ai (nolock) , tApproval a (nolock) , tProject p (nolock) 
	where	tLink.AssociatedEntity = 'ApprovalItem'
	and		tLink.EntityKey = ai.ApprovalItemKey
	and		ai.ApprovalKey = a.ApprovalKey
	and		a.ProjectKey = p.ProjectKey
	and		p.CompanyKey = @CompanyKey

	exec spTime 'tApprovalItem', @t output
	
	Print 'tLink: Note'
	Insert	PABackup.dbo.tLink
	Select	tLink.* 
	FROM	tLink (nolock), tNote n  (nolock)
	where	tLink.AssociatedEntity = 'Note'
	and		tLink.EntityKey = n.NoteKey
	and     n.Entity = 'Company'
	and		n.EntityKey = @CompanyKey
	

	exec spTime 'tLink: Note', @t output
	
	Print 'tLink: Lead'
	Insert	PABackup.dbo.tLink
	Select	tLink.*
	FROM	tLink (nolock), tLead ld (nolock)
	where	tLink.AssociatedEntity = 'Lead'
	and		tLink.EntityKey = ld.LeadKey
	and		ld.CompanyKey = @CompanyKey

	exec spTime 'tLink: Lead', @t output
	
	Print 'tLink: Forms'
	Insert	PABackup.dbo.tLink
	Select	tLink.*
	FROM	tLink (nolock), tForm f (nolock)
	where	tLink.AssociatedEntity = 'Forms'
	and		tLink.EntityKey = f.FormKey
	and		f.CompanyKey = @CompanyKey

	exec spTime 'tLink: Forms', @t output
	
	Print 'tMailing'
	if exists (select * from PABackup.dbo.sysobjects where name='tMailing')
	drop table PABackup.dbo.tMailing
	 
	Select * Into PABackup.dbo.tMailing FROM tMailing (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tMailing', @t output
	
	Print 'tMailingSetup'
	if exists (select * from PABackup.dbo.sysobjects where name='tMailingSetup')
	drop table PABackup.dbo.tMailingSetup
	 
	Select * Into PABackup.dbo.tMailingSetup FROM tMailingSetup (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tMailingSetup', @t output
	
	Print 'tMarketingList'
	if exists (select * from PABackup.dbo.sysobjects where name='tMarketingList')
	drop table PABackup.dbo.tMarketingList

	Select * Into PABackup.dbo.tMarketingList FROM tMarketingList (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tMarketingList', @t output
	
	Print 'tMarketingListList'
	if exists (select * from PABackup.dbo.sysobjects where name='tMarketingListList')
	drop table PABackup.dbo.tMarketingListList
	 
	Select tMarketingListList.* Into PABackup.dbo.tMarketingListList 
	FROM tMarketingListList (NOLOCK)
	     ,tMarketingList b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tMarketingListList.MarketingListKey = b.MarketingListKey

	exec spTime 'tMarketingListList', @t output
	
	Print 'tMarketingListListDeleteLog'
	if exists (select * from PABackup.dbo.sysobjects where name='tMarketingListListDeleteLog')
	drop table PABackup.dbo.tMarketingListListDeleteLog

	Select * Into PABackup.dbo.tMarketingListListDeleteLog FROM tMarketingListListDeleteLog (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tMarketingListListDeleteLog', @t output
	
	Print 'tMasterTask'
	if exists (select * from PABackup.dbo.sysobjects where name='tMasterTask')
	drop table PABackup.dbo.tMasterTask
	 
	Select * Into PABackup.dbo.tMasterTask FROM tMasterTask (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tMasterTask', @t output
	
	Print 'tMasterTaskAssignment'
	if exists (select * from PABackup.dbo.sysobjects where name='tMasterTaskAssignment')
	drop table PABackup.dbo.tMasterTaskAssignment
	 
	Select tMasterTaskAssignment.* Into PABackup.dbo.tMasterTaskAssignment 
	FROM tMasterTaskAssignment (NOLOCK)
	     ,tMasterTask b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tMasterTaskAssignment.MasterTaskKey = b.MasterTaskKey
	
	exec spTime 'tMasterTaskAssignment', @t output
	
	Print 'tMobileMenu'
	if exists (select * from PABackup.dbo.sysobjects where name='tMobileMenu')
	drop table PABackup.dbo.tMobileMenu
	 
	Select * Into PABackup.dbo.tMobileMenu FROM tMobileMenu  (nolock)
	
	exec spTime 'tMobileMenu', @t output
	
	Print 'tMobilSearch'
	if exists (select * from PABackup.dbo.sysobjects where name='tMobileSearch')
	drop table PABackup.dbo.tMobileSearch 
	 
	Select * Into PABackup.dbo.tMobileSearch 
	FROM tMobileSearch  (nolock)
	where CompanyKey is null or CompanyKey = @CompanyKey

	exec spTime 'tMobileSearch', @t output
	
	Print 'tMobilSearchCondition'
	if exists (select * from PABackup.dbo.sysobjects where name='tMobileSearchCondition')
	drop table PABackup.dbo.tMobileSearchCondition
	 
	Select tMobileSearchCondition.* Into PABackup.dbo.tMobileSearchCondition 
	FROM tMobileSearch (nolock) , tMobileSearchCondition (nolock)  
	where (tMobileSearch.CompanyKey is null or tMobileSearch.CompanyKey = @CompanyKey)
	and   tMobileSearchCondition.MobileSearchKey = tMobileSearch.MobileSearchKey 
	
	exec spTime 'tMobileSearchCondition', @t output
	
	Print 'tMobileSearchDefault'
	if exists (select * from PABackup.dbo.sysobjects where name='tMobileSearchDefault')
	drop table PABackup.dbo.tMobileSearchDefault
	 
	Select * Into PABackup.dbo.tMobileSearchDefault 
	FROM tMobileSearchDefault (nolock) 
	where CompanyKey is null or CompanyKey = @CompanyKey

	exec spTime 'tMobileSearchDefault', @t output
	
	Print 'tMediaAffiliate'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaAffiliate')
	drop table PABackup.dbo.tMediaAffiliate
	 
	Select * Into PABackup.dbo.tMediaAffiliate FROM tMediaAffiliate (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tMediaAffiliate', @t output
	
	Print 'tMediaAttribute'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaAttribute')
	drop table PABackup.dbo.tMediaAttribute
	 
	Select * Into PABackup.dbo.tMediaAttribute FROM tMediaAttribute (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tMediaAttribute', @t output
	
	Print 'tMediaAttributeValue'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaAttributeValue')
	drop table PABackup.dbo.tMediaAttributeValue
	 
	Select tMediaAttributeValue.* Into PABackup.dbo.tMediaAttributeValue 
	FROM tMediaAttributeValue (NOLOCK), tMediaAttribute b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   b.MediaAttributeKey =  tMediaAttributeValue.MediaAttributeKey

	exec spTime 'tMediaAttributeValue', @t output
	
	Print 'tMediaBroadcastLength'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaBroadcastLength')
	drop table PABackup.dbo.tMediaBroadcastLength
	 
	Select * Into PABackup.dbo.tMediaBroadcastLength FROM tMediaBroadcastLength (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tMediaBroadcastLength', @t output
	
	Print 'tMediaBuyRevisionHistory'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaBuyRevisionHistory')
	drop table PABackup.dbo.tMediaBuyRevisionHistory
	 
	Select * Into PABackup.dbo.tMediaBuyRevisionHistory FROM tMediaBuyRevisionHistory (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tMediaBuyRevisionHistory', @t output
	
	Print 'tMediaClientLink'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaClientLink')
	drop table PABackup.dbo.tMediaClientLink
	 
	Select * Into PABackup.dbo.tMediaClientLink 
	FROM tMediaClientLink (NOLOCK), tCompany b (NOLOCK) 
	WHERE isnull(b.OwnerCompanyKey,b.CompanyKey) = @CompanyKey
	AND   b.CompanyKey =  tMediaClientLink.ClientKey

	exec spTime 'tMediaClientLink', @t output
	
	Print 'tMediaCategory'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaCategory')
	drop table PABackup.dbo.tMediaCategory
	 
	Select * Into PABackup.dbo.tMediaCategory FROM tMediaCategory (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tMediaCategory', @t output
	
	Print 'tMediaDayPart'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaDayPart')
	drop table PABackup.dbo.tMediaDayPart
	 
	Select * Into PABackup.dbo.tMediaDayPart FROM tMediaDayPart (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tMediaDayPart', @t output
	
	Print 'tMediaDays'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaDays')
	drop table PABackup.dbo.tMediaDays
	 
	Select * Into PABackup.dbo.tMediaDays FROM tMediaDays (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tMediaDays', @t output
	
	Print 'tMediaDemographic'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaDemographic')
	drop table PABackup.dbo.tMediaDemographic
	 
	Select * Into PABackup.dbo.tMediaDemographic FROM tMediaDemographic (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tMediaDemographic', @t output
	
	Print 'tMediaEstimate'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaEstimate')
	drop table PABackup.dbo.tMediaEstimate
	 
	Select * Into PABackup.dbo.tMediaEstimate FROM tMediaEstimate (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tMediaEstimate', @t output
	
	Print 'tMediaOrder'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaOrder')
	drop table PABackup.dbo.tMediaOrder
	 
	Select tMediaOrder.* Into PABackup.dbo.tMediaOrder 
	FROM tMediaOrder (NOLOCK) , tMediaWorksheet b (nolock)
	WHERE b.CompanyKey = @CompanyKey
	and   tMediaOrder.MediaWorksheetKey = b.MediaWorksheetKey

	exec spTime 'tMediaOrder', @t output
	
	Print 'tMediaPosition'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaPosition')
	drop table PABackup.dbo.tMediaPosition
	 
	Select * Into PABackup.dbo.tMediaPosition FROM tMediaPosition (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tMediaPosition', @t output
	
	Print 'tMediaPremium'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaPremium')
	drop table PABackup.dbo.tMediaPremium
	 
	Select * Into PABackup.dbo.tMediaPremium FROM tMediaPremium (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tMediaPremium', @t output
	
	Print 'tMediaPremiumDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaPremiumDetail')
	drop table PABackup.dbo.tMediaPremiumDetail
	 
	Select tMediaPremiumDetail.* Into PABackup.dbo.tMediaPremiumDetail 
	FROM tMediaPremiumDetail (NOLOCK) , tMediaPremium b (nolock)
	WHERE b.CompanyKey = @CompanyKey
	and   tMediaPremiumDetail.MediaPremiumKey = b.MediaPremiumKey
	
	exec spTime 'tMediaPremiumDetail', @t output
	
	Print 'tMediaSpace'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaSpace')
	drop table PABackup.dbo.tMediaSpace
	 
	Select * Into PABackup.dbo.tMediaSpace FROM tMediaSpace (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tMediaSpace', @t output
	
	Print 'tMediaStdComment'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaStdComment')
	drop table PABackup.dbo.tMediaStdComment
	 
	Select * Into PABackup.dbo.tMediaStdComment FROM tMediaStdComment (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tMediaStdComment', @t output
	
	Print 'tMediaUnitType'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaUnitType')
	drop table PABackup.dbo.tMediaUnitType
	 
	Select * Into PABackup.dbo.tMediaUnitType FROM tMediaUnitType (NOLOCK) 

	exec spTime 'tMediaUnitType', @t output
	
	Print 'tMediaWorksheet'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaWorksheet')
	drop table PABackup.dbo.tMediaWorksheet
	 
	Select * Into PABackup.dbo.tMediaWorksheet FROM tMediaWorksheet (NOLOCK) where CompanyKey = @CompanyKey 

	exec spTime 'tMediaWorksheet', @t output
	
	Print 'tMediaWorksheetBudget'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaWorksheetBudget')
	drop table PABackup.dbo.tMediaWorksheetBudget
	 
	Select tMediaWorksheetBudget.* Into PABackup.dbo.tMediaWorksheetBudget 
	FROM tMediaWorksheetBudget (NOLOCK) , tMediaWorksheet b (nolock)
	WHERE b.CompanyKey = @CompanyKey
	and   tMediaWorksheetBudget.MediaWorksheetKey = b.MediaWorksheetKey

	exec spTime 'tMediaWorksheetBudget', @t output
	
	Print 'tMediaWorksheetMarket'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaWorksheetMarket')
	drop table PABackup.dbo.tMediaWorksheetMarket
	 
	Select tMediaWorksheetMarket.* Into PABackup.dbo.tMediaWorksheetMarket 
	FROM tMediaWorksheetMarket (NOLOCK) , tMediaWorksheet b (nolock)
	WHERE b.CompanyKey = @CompanyKey
	and   tMediaWorksheetMarket.MediaWorksheetKey = b.MediaWorksheetKey

	exec spTime 'tMediaWorksheetMarket', @t output
	
	Print 'tMediaRevisionReason'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaRevisionReason')
	drop table PABackup.dbo.tMediaRevisionReason
	 
	Select * Into PABackup.dbo.tMediaRevisionReason FROM tMediaRevisionReason (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	
	exec spTime 'tMediaRevisionReason', @t output
	
	Print 'tMediaMarket'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaMarket')
	drop table PABackup.dbo.tMediaMarket
	 
	Select * Into PABackup.dbo.tMediaMarket FROM tMediaMarket (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tMediaMarket', @t output
	
	Print 'tMediaGoal'
	if exists (select * from PABackup.dbo.sysobjects where name='tMediaGoal')
	drop table PABackup.dbo.tMediaGoal
	 
	Select tMediaGoal.* Into PABackup.dbo.tMediaGoal 
	FROM tMediaGoal (NOLOCK), tMediaMarket b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   b.MediaMarketKey =  tMediaGoal.MediaMarketKey

	exec spTime 'tMediaGoal', @t output
	
	Print 'tMergeContactLog'
	if exists (select * from PABackup.dbo.sysobjects where name='tMergeContactLog')
	drop table PABackup.dbo.tMergeContactLog

	Select * Into PABackup.dbo.tMergeContactLog FROM tMergeContactLog (NOLOCK) WHERE OwnerCompanyKey = @CompanyKey
	
	exec spTime 'tMergeContactLog', @t output
	
	Print 'tMiscCost'
	if exists (select * from PABackup.dbo.sysobjects where name='tMiscCost')
	drop table PABackup.dbo.tMiscCost
	 
	Select tMiscCost.* Into PABackup.dbo.tMiscCost 
	FROM tMiscCost (nolock) , tProject (nolock) 
	Where tMiscCost.ProjectKey = tProject.ProjectKey 
	and tProject.CompanyKey = @CompanyKey
	
	exec spTime 'tMiscCost', @t output
	
	Print 'tNote'
	if exists (select * from PABackup.dbo.sysobjects where name='tNote')
	drop table PABackup.dbo.tNote
	 
	Select tNote.* Into PABackup.dbo.tNote 
	FROM tNote  (nolock)
	where tNote.Entity = 'Company'
	and tNote.EntityKey = @CompanyKey
	 
	exec spTime 'tNote', @t output
	
	Print 'tNoteGroup'
	if exists (select * from PABackup.dbo.sysobjects where name='tNoteGroup')
	drop table PABackup.dbo.tNoteGroup
	 
	Select * Into PABackup.dbo.tNoteGroup FROM tNoteGroup  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tNoteGroup', @t output
	
	Print 'tNotification'
	if exists (select * from PABackup.dbo.sysobjects where name='tNotification')
	drop table PABackup.dbo.tNotification
	 
	Select * Into PABackup.dbo.tNotification FROM tNotification  (nolock)

	exec spTime 'tNotification', @t output
	
	Print 'tObjectFieldSet'
	if exists (select * from PABackup.dbo.sysobjects where name='tObjectFieldSet')
	drop table PABackup.dbo.tObjectFieldSet
	 
	Select	tObjectFieldSet.* Into PABackup.dbo.tObjectFieldSet 
	FROM	tObjectFieldSet (nolock) , tFieldSet fs (nolock) 
	where	tObjectFieldSet.FieldSetKey = fs.FieldSetKey
	and		fs.OwnerEntityKey = @CompanyKey
	and		fs.AssociatedEntity != 'Forms'
	

	Insert	PABackup.dbo.tObjectFieldSet (ObjectFieldSetKey, FieldSetKey)
	Select	tObjectFieldSet.ObjectFieldSetKey, tObjectFieldSet.FieldSetKey
	FROM	tObjectFieldSet (nolock) , tFieldSet (nolock) , tFormDef fd (nolock) 
	where	tFieldSet.AssociatedEntity = 'Forms'
	and		tObjectFieldSet.FieldSetKey = tFieldSet.FieldSetKey
	and		tFieldSet.OwnerEntityKey = fd.FormDefKey
	and		fd.CompanyKey = @CompanyKey 
	
	exec spTime 'tObjectFieldSet', @t output
	
	Print 'tOffice'
	if exists (select * from PABackup.dbo.sysobjects where name='tOffice')
	drop table PABackup.dbo.tOffice
	 
	Select * Into PABackup.dbo.tOffice FROM tOffice  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tOffice', @t output
	
	Print 'tPayment'
	if exists (select * from PABackup.dbo.sysobjects where name='tPayment')
	drop table PABackup.dbo.tPayment
	 
	Select * Into PABackup.dbo.tPayment FROM tPayment  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tPayment', @t output
	
	Print 'tPaymentDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tPaymentDetail')
	drop table PABackup.dbo.tPaymentDetail
	 
	Select tPaymentDetail.* Into PABackup.dbo.tPaymentDetail 
	FROM tPaymentDetail (nolock) , tPayment p (nolock) 
	where tPaymentDetail.PaymentKey = p.PaymentKey 
	and p.CompanyKey = @CompanyKey
	
	exec spTime 'tPaymentDetail', @t output
	
	Print 'tPaymentTerms'
	if exists (select * from PABackup.dbo.sysobjects where name='tPaymentTerms')
	drop table PABackup.dbo.tPaymentTerms
	 
	Select * Into PABackup.dbo.tPaymentTerms FROM tPaymentTerms  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tPaymentTerms', @t output
	
	Print 'tPreference'
	if exists (select * from PABackup.dbo.sysobjects where name='tPreference')
	drop table PABackup.dbo.tPreference
	 
	Select * Into PABackup.dbo.tPreference FROM tPreference  (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tPreference', @t output
	
	Print 'tPreferenceDARights'
	if exists (select * from PABackup.dbo.sysobjects where name='tPreferenceDARights')
	drop table PABackup.dbo.tPreferenceDARights
	 
	Select * Into PABackup.dbo.tPreferenceDARights FROM tPreferenceDARights (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tPreferenceDARights', @t output
	
	Print 'tProject'
	if exists (select * from PABackup.dbo.sysobjects where name='tProject')
	drop table PABackup.dbo.tProject
	 
	Select * Into PABackup.dbo.tProject FROM tProject (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tProject', @t output
	
	Print 'tProjectItemRollup'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectItemRollup')
	drop table PABackup.dbo.tProjectItemRollup
	 
	Select tProjectItemRollup.* Into PABackup.dbo.tProjectItemRollup 
	FROM tProjectItemRollup (nolock) , tProject p (nolock)  
	WHERE tProjectItemRollup.ProjectKey = p.ProjectKey
	and p.CompanyKey = @CompanyKey

	exec spTime 'tProjectItemRollup', @t output
	
	Print 'tProjectRollup'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectRollup')
	drop table PABackup.dbo.tProjectRollup
	 
	Select tProjectRollup.* Into PABackup.dbo.tProjectRollup 
	FROM tProjectRollup (nolock) , tProject p (nolock) 
	WHERE tProjectRollup.ProjectKey = p.ProjectKey
	and p.CompanyKey = @CompanyKey
	
	exec spTime 'tProjectRollup', @t output
	
	Print 'tProjectTitleRollup'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectTitleRollup')
	drop table PABackup.dbo.tProjectTitleRollup
	 
	Select tProjectTitleRollup.* Into PABackup.dbo.tProjectTitleRollup 
	FROM tProjectTitleRollup (nolock) , tProject p (nolock)  
	WHERE tProjectTitleRollup.ProjectKey = p.ProjectKey
	and p.CompanyKey = @CompanyKey

	exec spTime 'tProjectTitleRollup', @t output
	Print 'tProjectEstByTitle'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectEstByTitle')
	drop table PABackup.dbo.tProjectEstByTitle
	 
	Select tProjectEstByTitle.* Into PABackup.dbo.tProjectEstByTitle 
	FROM tProjectEstByTitle (nolock) , tProject p (nolock)  
	WHERE tProjectEstByTitle.ProjectKey = p.ProjectKey
	and p.CompanyKey = @CompanyKey

	exec spTime 'tProjectEstByTitle', @t output
	
	Print 'tProjectBillingStatus'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectBillingStatus')
	drop table PABackup.dbo.tProjectBillingStatus
	 
	Select * Into PABackup.dbo.tProjectBillingStatus FROM tProjectBillingStatus  (nolock) WHERE CompanyKey = @CompanyKey
	 
	exec spTime 'tProjectBillingStatus', @t output
	
	Print 'tProjectCreativeBrief'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectCreativeBrief')
	drop table PABackup.dbo.tProjectCreativeBrief
	 
	Select tProjectCreativeBrief.* Into PABackup.dbo.tProjectCreativeBrief 
	FROM tProjectCreativeBrief  (nolock), tProject p (nolock)  
	where tProjectCreativeBrief.ProjectKey = p.ProjectKey 
	and p.CompanyKey = @CompanyKey

	exec spTime 'tProjectCreativeBrief', @t output
	
	Print 'tProjectEstByItem'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectEstByItem')
	drop table PABackup.dbo.tProjectEstByItem 
	 
	Select tProjectEstByItem.* Into PABackup.dbo.tProjectEstByItem  
	FROM	tProjectEstByItem (NOLOCK), tProject (NOLOCK) 
	Where	tProjectEstByItem.ProjectKey = tProject.ProjectKey 
	and		tProject.CompanyKey = @CompanyKey 
	
	exec spTime 'tProjectEstByItem', @t output
	
	Print 'tProjectNote'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectNote')
	drop table PABackup.dbo.tProjectNote 
	 
	Select * Into PABackup.dbo.tProjectNote FROM tProjectNote (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tProjectNote', @t output
	
	Print 'tProjectNoteLink'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectNoteLink')
	drop table PABackup.dbo.tProjectNoteLink 
	 
	Select tProjectNoteLink.* Into PABackup.dbo.tProjectNoteLink 
	FROM tProjectNoteLink (NOLOCK)
	     ,tProjectNote b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tProjectNoteLink.ProjectNoteKey = b.ProjectNoteKey

	exec spTime 'tProjectNoteLink', @t output
	
	Print 'tProjectNoteUser'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectNoteUser')
	drop table PABackup.dbo.tProjectNoteUser 
	 
	Select tProjectNoteUser.* Into PABackup.dbo.tProjectNoteUser 
	FROM tProjectNoteUser (NOLOCK)
	     ,tProjectNote b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tProjectNoteUser.ProjectNoteKey = b.ProjectNoteKey
	
	exec spTime 'tProjectNoteUser', @t output
	
	Print 'tProjectStatus'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectStatus')
	drop table PABackup.dbo.tProjectStatus
	 
	Select * Into PABackup.dbo.tProjectStatus FROM tProjectStatus  (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tProjectStatus', @t output
	
	Print 'tProjectSplitBilling'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectSplitBilling')
	drop table PABackup.dbo.tProjectSplitBilling 
	 
	Select tProjectSplitBilling.* Into PABackup.dbo.tProjectSplitBilling 
	FROM tProjectSplitBilling (NOLOCK)
	     ,tProject b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tProjectSplitBilling.ProjectKey = b.ProjectKey

	exec spTime 'tProjectSplitBilling', @t output
	
	Print 'tProjectType'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectType')
	drop table PABackup.dbo.tProjectType
	 
	Select * Into PABackup.dbo.tProjectType FROM tProjectType  (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tProjectType', @t output
	
	Print 'tProjectTypeMasterTask'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectTypeMasterTask')
	drop table PABackup.dbo.tProjectTypeMasterTask 
	 
	Select tProjectTypeMasterTask.* Into PABackup.dbo.tProjectTypeMasterTask  
	FROM	tProjectTypeMasterTask (NOLOCK), tProjectType (NOLOCK) 
	Where	tProjectTypeMasterTask.ProjectTypeKey = tProjectType.ProjectTypeKey 
	and		tProjectType.CompanyKey = @CompanyKey 
	
	exec spTime 'tProjectTypeMasterTask', @t output
	
	Print 'tProjectTypeService'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectTypeService')
	drop table PABackup.dbo.tProjectTypeService 
	 
	Select tProjectTypeService.* Into PABackup.dbo.tProjectTypeService  
	FROM	tProjectTypeService  (nolock), tProjectType  (nolock)
	Where	tProjectTypeService.ProjectTypeKey = tProjectType.ProjectTypeKey 
	and		tProjectType.CompanyKey = @CompanyKey 
	
	exec spTime 'tProjectTypeService', @t output
	
	Print 'tProjectTypeUser'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectTypeUser')
	drop table PABackup.dbo.tProjectTypeUser 
	 
	Select tProjectTypeUser.* Into PABackup.dbo.tProjectTypeUser  
	FROM	tProjectTypeUser (nolock), tProjectType (nolock)
	Where	tProjectTypeUser.ProjectTypeKey = tProjectType.ProjectTypeKey 
	and		tProjectType.CompanyKey = @CompanyKey 

	exec spTime 'tProjectTypeUser', @t output
	
	Print 'tProjectUserServices'
	if exists (select * from PABackup.dbo.sysobjects where name='tProjectUserServices')
	drop table PABackup.dbo.tProjectUserServices 
	 
	Select tProjectUserServices.* Into PABackup.dbo.tProjectUserServices  
	FROM	tProjectUserServices  (nolock), tProject  (nolock)
	Where	tProjectUserServices.ProjectKey = tProject.ProjectKey 
	and		tProject.CompanyKey = @CompanyKey 
	
	exec spTime 'tProjectUserServices', @t output
	
	Print 'tPublishCalendar'
	if exists (select * from PABackup.dbo.sysobjects where name='tPublishCalendar')
	drop table PABackup.dbo.tPublishCalendar
	 
	Select * Into PABackup.dbo.tPublishCalendar FROM tPublishCalendar (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tPublishCalendar', @t output
	
	Print 'tPublishCalendarSecurity'
	if exists (select * from PABackup.dbo.sysobjects where name='tPublishCalendarSecurity')
	drop table PABackup.dbo.tPublishCalendarSecurity
	 
	Select tPublishCalendarSecurity.* Into PABackup.dbo.tPublishCalendarSecurity 
	FROM tPublishCalendarSecurity (nolock) , tPublishCalendar (nolock) 
	Where tPublishCalendarSecurity.PublishCalendarKey = tPublishCalendar.PublishCalendarKey 
	and	tPublishCalendar.CompanyKey = @CompanyKey

	exec spTime 'tPublishCalendarSecurity', @t output
	
	Print 'tPurchaseOrder'
	if exists (select * from PABackup.dbo.sysobjects where name='tPurchaseOrder')
	drop table PABackup.dbo.tPurchaseOrder
	 
	Select * Into PABackup.dbo.tPurchaseOrder FROM tPurchaseOrder  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tPurchaseOrder', @t output
	
	Print 'tPurchaseOrderDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tPurchaseOrderDetail')
	drop table PABackup.dbo.tPurchaseOrderDetail
	 
	Select tPurchaseOrderDetail.* Into PABackup.dbo.tPurchaseOrderDetail 
	FROM tPurchaseOrderDetail (nolock) , tPurchaseOrder (nolock) 
	Where tPurchaseOrderDetail.PurchaseOrderKey = tPurchaseOrder.PurchaseOrderKey 
	and	tPurchaseOrder.CompanyKey = @CompanyKey
	
	exec spTime 'tPurchaseOrderDetail', @t output
	
	Print 'tPurchaseOrderDetailTax'
	if exists (select * from PABackup.dbo.sysobjects where name='tPurchaseOrderDetailTax')
	drop table PABackup.dbo.tPurchaseOrderDetailTax
	 
	Select tPurchaseOrderDetailTax.* Into PABackup.dbo.tPurchaseOrderDetailTax 
	FROM tPurchaseOrderDetailTax (nolock) , tPurchaseOrderDetail (nolock) , tPurchaseOrder (nolock) 
	Where tPurchaseOrderDetail.PurchaseOrderKey = tPurchaseOrder.PurchaseOrderKey 
	and	tPurchaseOrder.CompanyKey = @CompanyKey
	and tPurchaseOrderDetail.PurchaseOrderDetailKey =tPurchaseOrderDetailTax.PurchaseOrderDetailKey

	exec spTime 'tPurchaseOrderDetailTax', @t output
	
	Print 'tPurchaseOrderTraffic'
	if exists (select * from PABackup.dbo.sysobjects where name='tPurchaseOrderTraffic')
	drop table PABackup.dbo.tPurchaseOrderTraffic
	 
	Select tPurchaseOrderTraffic.* Into PABackup.dbo.tPurchaseOrderTraffic 
	FROM tPurchaseOrderTraffic (nolock) , tPurchaseOrder (nolock)  
	Where tPurchaseOrderTraffic.PurchaseOrderKey = tPurchaseOrder.PurchaseOrderKey 
	and	tPurchaseOrder.CompanyKey = @CompanyKey
	
	exec spTime 'tPurchaseOrderTraffic', @t output
	
	Print 'tPurchaseOrderType'
	if exists (select * from PABackup.dbo.sysobjects where name='tPurchaseOrderType')
	drop table PABackup.dbo.tPurchaseOrderType
	 
	Select * Into PABackup.dbo.tPurchaseOrderType FROM tPurchaseOrderType  (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tPurchaseOrderType', @t output
	
	Print 'tPurchaseOrderUser'
	if exists (select * from PABackup.dbo.sysobjects where name='tPurchaseOrderUser')
	drop table PABackup.dbo.tPurchaseOrderUser
	 
	Select tPurchaseOrderUser.* Into PABackup.dbo.tPurchaseOrderUser 
	FROM tPurchaseOrderUser (NOLOCK), tPurchaseOrder (NOLOCK) 
	Where tPurchaseOrderUser.PurchaseOrderKey = tPurchaseOrder.PurchaseOrderKey 
	and	tPurchaseOrder.CompanyKey = @CompanyKey
	
	exec spTime 'tPurchaseOrderUser', @t output
	
	Print 'tQuote'
	if exists (select * from PABackup.dbo.sysobjects where name='tQuote')
	drop table PABackup.dbo.tQuote
	 
	Select * Into PABackup.dbo.tQuote FROM tQuote  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tQuote', @t output
	
	Print 'tQuoteDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tQuoteDetail')
	drop table PABackup.dbo.tQuoteDetail
	 
	Select tQuoteDetail.* Into PABackup.dbo.tQuoteDetail 
	FROM tQuoteDetail  (nolock), tQuote  (nolock)
	Where tQuoteDetail.QuoteKey = tQuote.QuoteKey 
	and tQuote.CompanyKey = @CompanyKey
	
	exec spTime 'tQuoteDetail', @t output
	
	Print 'tQuoteReply'
	if exists (select * from PABackup.dbo.sysobjects where name='tQuoteReply')
	drop table PABackup.dbo.tQuoteReply
	 
	Select tQuoteReply.* Into PABackup.dbo.tQuoteReply 
	FROM tQuoteReply  (nolock), tQuote  (nolock)
	Where tQuoteReply.QuoteKey = tQuote.QuoteKey 
	and tQuote.CompanyKey = @CompanyKey

	exec spTime 'tQuoteReply', @t output
	
	Print 'tQuoteReplyDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tQuoteReplyDetail')
	drop table PABackup.dbo.tQuoteReplyDetail
	 
	Select tQuoteReplyDetail.* Into PABackup.dbo.tQuoteReplyDetail 
	FROM tQuoteReplyDetail  (nolock), tQuoteReply  (nolock), tQuote  (nolock)
	Where tQuoteReplyDetail.QuoteReplyKey = tQuoteReply.QuoteReplyKey 
	and	tQuoteReply.QuoteKey = tQuote.QuoteKey 
	and tQuote.CompanyKey = @CompanyKey
	
	exec spTime 'tQuoteReplyDetail', @t output
	
	Print 'tRecurTran'
	if exists (select * from PABackup.dbo.sysobjects where name='tRecurTran')
	drop table PABackup.dbo.tRecurTran
	 
	Select * Into PABackup.dbo.tRecurTran FROM tRecurTran  (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tRecurTran', @t output
	
	Print 'tRecurTranUser'
	if exists (select * from PABackup.dbo.sysobjects where name='tRecurTranUser')
	drop table PABackup.dbo.tRecurTranUser
	 
	Select tRecurTranUser.* Into PABackup.dbo.tRecurTranUser 
	FROM tRecurTranUser  (nolock), tRecurTran  (nolock)
	WHERE tRecurTran.CompanyKey = @CompanyKey
	and   tRecurTran.RecurTranKey = tRecurTranUser.RecurTranKey  


	exec spTime 'tRecurTranUser', @t output
	
	Print 'tReport'
	if exists (select * from PABackup.dbo.sysobjects where name='tReport')
	drop table PABackup.dbo.tReport
	 
	Select * Into PABackup.dbo.tReport FROM tReport  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tReport', @t output
	
	Print 'tReportGroup'
	if exists (select * from PABackup.dbo.sysobjects where name='tReportGroup')
	drop table PABackup.dbo.tReportGroup
	 
	Select * Into PABackup.dbo.tReportGroup FROM tReportGroup  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tReportGroup', @t output
	
	Print 'tReportUser'
	if exists (select * from PABackup.dbo.sysobjects where name='tReportUser')
	drop table PABackup.dbo.tReportUser
	 
	Select tReportUser.* Into PABackup.dbo.tReportUser 
	FROM tReportUser (nolock), tReport b (nolock) 
	where tReportUser.ReportKey = b.ReportKey 
	and b.CompanyKey = @CompanyKey

	exec spTime 'tReportUser', @t output
	
	Print 'tRequest'
	if exists (select * from PABackup.dbo.sysobjects where name='tRequest')
	drop table PABackup.dbo.tRequest
	 
	Select * Into PABackup.dbo.tRequest FROM tRequest  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tRequest', @t output

	Print 'tRequestDef'
	if exists (select * from PABackup.dbo.sysobjects where name='tRequestDef')
	drop table PABackup.dbo.tRequestDef
	 
	Select * Into PABackup.dbo.tRequestDef FROM tRequestDef  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tRequestDef', @t output
	
	Print 'tRequestDefSpec'
	if exists (select * from PABackup.dbo.sysobjects where name='tRequestDefSpec')
	drop table PABackup.dbo.tRequestDefSpec
	 
	Select tRequestDefSpec.* Into PABackup.dbo.tRequestDefSpec 
	FROM tRequestDefSpec  (nolock), tRequestDef rd  (nolock) 
	where tRequestDefSpec.RequestDefKey = rd.RequestDefKey 
	and rd.CompanyKey = @CompanyKey

	exec spTime 'tRequestDefSpec', @t output
	
	Print 'tRetainer'
	if exists (select * from PABackup.dbo.sysobjects where name='tRetainer')
	drop table PABackup.dbo.tRetainer
	 
	Select * Into PABackup.dbo.tRetainer FROM tRetainer (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tRetainer', @t output
	
	Print 'tRetainerItems'
	if exists (select * from PABackup.dbo.sysobjects where name='tRetainerItems')
	drop table PABackup.dbo.tRetainerItems
	 
	Select tRetainerItems.* Into PABackup.dbo.tRetainerItems 
	FROM tRetainerItems (nolock), tRetainer (nolock)
	WHERE tRetainerItems.RetainerKey = tRetainer.RetainerKey 
	And tRetainer.CompanyKey = @CompanyKey
	
	exec spTime 'tRetainerItems', @t output
	
	Print 'tReviewComment'
	if exists (select * from PABackup.dbo.sysobjects where name='tReviewComment')
	drop table PABackup.dbo.tReviewComment
	
	Select tReviewComment.* Into PABackup.dbo.tReviewComment 
	FROM tReviewComment  (nolock), tReviewRound  (nolock), tReviewDeliverable  (nolock), tProject (nolock)
	WHERE tReviewDeliverable.ProjectKey = tProject.ProjectKey 
	And tProject.CompanyKey = @CompanyKey
	and tReviewRound.ReviewDeliverableKey = tReviewDeliverable.ReviewDeliverableKey
	and tReviewRound.ReviewRoundKey = tReviewComment.ReviewRoundKey

	exec spTime 'tReviewComment', @t output
	
	Print 'tReviewCommentMarkup'
	if exists (select * from PABackup.dbo.sysobjects where name='tReviewCommentMarkup')
	drop table PABackup.dbo.tReviewCommentMarkup
	
	Select tReviewCommentMarkup.* Into PABackup.dbo.tReviewCommentMarkup 
	FROM tReviewCommentMarkup (nolock), tReviewComment (nolock), tReviewRound (nolock)
		, tReviewDeliverable (nolock), tProject (nolock)
	WHERE tReviewDeliverable.ProjectKey = tProject.ProjectKey 
	And tProject.CompanyKey = @CompanyKey
	and tReviewRound.ReviewDeliverableKey = tReviewDeliverable.ReviewDeliverableKey
	and tReviewRound.ReviewRoundKey = tReviewComment.ReviewRoundKey
	and tReviewCommentMarkup.ReviewCommentKey = tReviewComment.ReviewCommentKey 

	exec spTime 'tReviewCommentMarkup', @t output
	
	Print 'tReviewDeliverable'
	if exists (select * from PABackup.dbo.sysobjects where name='tReviewDeliverable')
	drop table PABackup.dbo.tReviewDeliverable
	
	Select tReviewDeliverable.* Into PABackup.dbo.tReviewDeliverable 
	FROM tReviewDeliverable  (nolock), tProject  (nolock)
	WHERE tReviewDeliverable.ProjectKey = tProject.ProjectKey 
	And tProject.CompanyKey = @CompanyKey
	
	exec spTime 'tReviewDeliverable', @t output
	
	Print 'tReviewLog'
	if exists (select * from PABackup.dbo.sysobjects where name='tReviewLog')
	drop table PABackup.dbo.tReviewLog
	
	Select tReviewLog.* Into PABackup.dbo.tReviewLog 
	FROM tReviewLog  (nolock), tReviewDeliverable  (nolock), tProject  (nolock)
	WHERE tReviewDeliverable.ProjectKey = tProject.ProjectKey 
	And tProject.CompanyKey = @CompanyKey
	and tReviewLog.ReviewDeliverableKey = tReviewDeliverable.ReviewDeliverableKey 

	exec spTime 'tReviewLog', @t output
	
	Print 'tReviewRound'
	if exists (select * from PABackup.dbo.sysobjects where name='tReviewRound')
	drop table PABackup.dbo.tReviewRound
	
	Select tReviewRound.* Into PABackup.dbo.tReviewRound 
	FROM tReviewRound  (nolock), tReviewDeliverable  (nolock), tProject  (nolock)
	WHERE tReviewDeliverable.ProjectKey = tProject.ProjectKey 
	And tProject.CompanyKey = @CompanyKey
	and tReviewRound.ReviewDeliverableKey = tReviewDeliverable.ReviewDeliverableKey 

	exec spTime 'tReviewRound', @t output
	
	Print 'tReviewRoundFile'
	if exists (select * from PABackup.dbo.sysobjects where name='tReviewRoundFile')
	drop table PABackup.dbo.tReviewRoundFile
	
	Select tReviewRoundFile.* Into PABackup.dbo.tReviewRoundFile 
	FROM tReviewRoundFile  (nolock), tReviewRound  (nolock), tReviewDeliverable  (nolock), tProject  (nolock)
	WHERE tReviewDeliverable.ProjectKey = tProject.ProjectKey 
	And tProject.CompanyKey = @CompanyKey
	and tReviewRound.ReviewDeliverableKey = tReviewDeliverable.ReviewDeliverableKey 
	and tReviewRoundFile.ReviewRoundKey = tReviewRound.ReviewRoundKey

	exec spTime 'tReviewRoundFile', @t output
	
	Print 'tRight'
	if exists (select * from PABackup.dbo.sysobjects where name='tRight')
	drop table PABackup.dbo.tRight
	 
	Select * Into PABackup.dbo.tRight FROM tRight  (nolock)
	
	exec spTime 'tRight', @t output
	
	Print 'tRightAssigned'
	if exists (select * from PABackup.dbo.sysobjects where name='tRightAssigned')
	drop table PABackup.dbo.tRightAssigned
	 
	Select tRightAssigned.* Into PABackup.dbo.tRightAssigned 
	FROM tRightAssigned  (nolock), tSecurityGroup  (nolock) 
	Where tRightAssigned.EntityKey = tSecurityGroup.SecurityGroupKey 
	and	tSecurityGroup.CompanyKey = @CompanyKey 
	and tRightAssigned.EntityType = 'Security Group'
	
	exec spTime 'tRightAssigned', @t output
	
	Print 'tRightLevel'
	if exists (select * from PABackup.dbo.sysobjects where name='tRightLevel')
	drop table PABackup.dbo.tRightLevel
	 
	Select tRightLevel.* Into PABackup.dbo.tRightLevel 
	FROM tRightLevel (nolock), tCompany (nolock) 
	Where tRightLevel.CompanyKey = tCompany.CompanyKey 
	and isnull(tCompany.OwnerCompanyKey,tCompany.CompanyKey) = @CompanyKey 
	
	exec spTime 'tRightLevel', @t output
	
	Print 'tRptSecurityGroup'
	if exists (select * from PABackup.dbo.sysobjects where name='tRptSecurityGroup')
	drop table PABackup.dbo.tRptSecurityGroup
	 
	Select tRptSecurityGroup.* Into PABackup.dbo.tRptSecurityGroup 
	FROM tRptSecurityGroup  (nolock), tSecurityGroup  (nolock)
	Where tRptSecurityGroup.SecurityGroupKey = tSecurityGroup.SecurityGroupKey and
	tSecurityGroup.CompanyKey = @CompanyKey
	
	exec spTime 'tRptSecurityGroup', @t output
	
	Print 'tSalesTax'
	if exists (select * from PABackup.dbo.sysobjects where name='tSalesTax')
	drop table PABackup.dbo.tSalesTax
	 
	Select * Into PABackup.dbo.tSalesTax FROM tSalesTax  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tSalesTax', @t output
	
	Print 'tSecurityGroup'
	if exists (select * from PABackup.dbo.sysobjects where name='tSecurityGroup')
	drop table PABackup.dbo.tSecurityGroup
	 
	Select * Into PABackup.dbo.tSecurityGroup FROM tSecurityGroup  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tSecurityGroup', @t output
	
	Print 'tSecurityAccess'
	if exists (select * from PABackup.dbo.sysobjects where name='tSecurityAccess')
	drop table PABackup.dbo.tSecurityAccess
	 
	Select * Into PABackup.dbo.tSecurityAccess FROM tSecurityAccess  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tSecurityAccess', @t output
	
	Print 'tService'
	if exists (select * from PABackup.dbo.sysobjects where name='tService')
	drop table PABackup.dbo.tService
	 
	Select * Into PABackup.dbo.tService FROM tService  (nolock) WHERE CompanyKey = @CompanyKey
	 
	exec spTime 'tService', @t output
	
	Print 'tSession'
	if exists (select * from PABackup.dbo.sysobjects where name='tSession')
	drop table PABackup.dbo.tSession
	 
	exec spTime 'tSession', @t output
	
	Print 'tSession:User + userDashboard'
	Select tSession.* Into PABackup.dbo.tSession 
	FROM tSession  (nolock), tUser u  (nolock)
	where	tSession.Entity in ( 'user', 'userDashboard', 'strings', 'StandardReports', 'DynamicReports', 'rights', 'recentTran', 'Listings')
	and		tSession.EntityKey = u.UserKey
	and		ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
	
	exec spTime 'tSession:User + userDashboard', @t output
	
	Print 'tSession:report style'
	Insert PABackup.dbo.tSession 
	Select *
	FROM    tSession  (nolock)
	where	tSession.Entity in ( 'report', 'style', 'CompanyMetrics')
	and		tSession.EntityKey = @CompanyKey

	exec spTime 'tSession:report style', @t output
	
	Print 'tSkill'
	if exists (select * from PABackup.dbo.sysobjects where name='tSkill')
	drop table PABackup.dbo.tSkill
	 
	Select * Into PABackup.dbo.tSkill FROM tSkill  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tSkill', @t output
	
	Print 'tSkillSpecialty'
	if exists (select * from PABackup.dbo.sysobjects where name='tSkillSpecialty')
		drop table PABackup.dbo.tSkillSpecialty
	 
	Select tSkillSpecialty.* Into PABackup.dbo.tSkillSpecialty 
	FROM tSkillSpecialty  (nolock), tSkill  (nolock)
	Where tSkillSpecialty.SkillKey = tSkill.SkillKey 
	and tSkill.CompanyKey = @CompanyKey

	exec spTime 'tSkillSpecialty', @t output
	
	Print 'tSource'
	if exists (select * from PABackup.dbo.sysobjects where name='tSource')
	drop table PABackup.dbo.tSource
	 
	Select * Into PABackup.dbo.tSource FROM tSource  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tSource', @t output
	
	Print 'tSpecSheet'
	if exists (select * from PABackup.dbo.sysobjects where name='tSpecSheet')
	drop table PABackup.dbo.tSpecSheet
	 
	Select	sp.* Into PABackup.dbo.tSpecSheet 
	FROM	
	(Select tSpecSheet.*
		from tSpecSheet  (nolock), tProject p  (nolock)
		where	tSpecSheet.Entity = 'Project'
		and		tSpecSheet.EntityKey = p.ProjectKey
		and		p.CompanyKey = @CompanyKey
		
	UNION ALL
	
	Select tSpecSheet.*
		from tSpecSheet  (nolock), tRequest r  (nolock)
		where	tSpecSheet.Entity = 'ProjectRequest'
		and		tSpecSheet.EntityKey = r.RequestKey
		and		r.CompanyKey = @CompanyKey
		
	UNION ALL
	
	Select tSpecSheet.*
		from tSpecSheet  (nolock), tLead l  (nolock)
		where	tSpecSheet.Entity = 'Lead'
		and		tSpecSheet.EntityKey = l.LeadKey
		and		l.CompanyKey = @CompanyKey ) as sp
	
	exec spTime 'tSpecSheet', @t output
	
	Print 'tSpecSheetLink'
	if exists (select * from PABackup.dbo.sysobjects where name='tSpecSheetLink')
	drop table PABackup.dbo.tSpecSheetLink
	 
	Select * Into PABackup.dbo.tSpecSheetLink FROM tSpecSheetLink  (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tSpecSheetLink', @t output
	
	Print 'tStandardActivity'
	if exists (select * from PABackup.dbo.sysobjects where name='tStandardActivity')
	drop table PABackup.dbo.tStandardActivity
	 
	Select * Into PABackup.dbo.tStandardActivity FROM tStandardActivity  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tStandardActivity', @t output
	
	Print 'tStandardText'
	if exists (select * from PABackup.dbo.sysobjects where name='tStandardText')
	drop table PABackup.dbo.tStandardText
	 
	Select * Into PABackup.dbo.tStandardText FROM tStandardText  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tStandardText', @t output
	
	Print 'tString'
	if exists (select * from PABackup.dbo.sysobjects where name='tString')
	drop table PABackup.dbo.tString
	 
	Select * Into PABackup.dbo.tString FROM tString

	 
	exec spTime 'tString', @t output
	
	Print 'tStringCompany'
	if exists (select * from PABackup.dbo.sysobjects where name='tStringCompany')
	drop table PABackup.dbo.tStringCompany
	 
	Select * Into PABackup.dbo.tStringCompany FROM tStringCompany  (nolock) WHERE CompanyKey = @CompanyKey
	 
	exec spTime 'tStringCompany', @t output
	
	Print 'tStringGroup'
	if exists (select * from PABackup.dbo.sysobjects where name='tStringGroup')
	drop table PABackup.dbo.tStringGroup
	Select * Into PABackup.dbo.tStringGroup FROM tStringGroup  (nolock)
		 
	exec spTime 'tStringGroup', @t output
	
	Print 'tSyncActivity'
	if exists (select * from PABackup.dbo.sysobjects where name='tSyncActivity')
	drop table PABackup.dbo.tSyncActivity

	Select tSyncActivity.* Into PABackup.dbo.tSyncActivity 
	FROM   tSyncActivity (nolock), tCompany c (nolock)
	where  tSyncActivity.CompanyKey = c.CompanyKey
	and    isnull(c.OwnerCompanyKey, c.CompanyKey) = @CompanyKey	 

	exec spTime 'tSyncActivity', @t output
	
	Print 'tSyncFolder'
	if exists (select * from PABackup.dbo.sysobjects where name='tSyncFolder')
	drop table PABackup.dbo.tSyncFolder

	Select tSyncFolder.* Into PABackup.dbo.tSyncFolder 
	FROM   tSyncFolder (nolock), tCompany c (nolock)
	where  tSyncFolder.CompanyKey = c.CompanyKey
	and    isnull(c.OwnerCompanyKey, c.CompanyKey) = @CompanyKey	 

	exec spTime 'tSyncFolder', @t output
	
	Print 'tSyncItem'
	if exists (select * from PABackup.dbo.sysobjects where name='tSyncItem')
	drop table PABackup.dbo.tSyncItem

	Select tSyncItem.* Into PABackup.dbo.tSyncItem 
	FROM   tSyncItem (nolock), tCompany c (nolock)
	where  tSyncItem.CompanyKey = c.CompanyKey
	and    isnull(c.OwnerCompanyKey, c.CompanyKey) = @CompanyKey	 
	
	exec spTime 'tSyncItem', @t output
	
	Print 'tSyncCalendar'
	if exists (select * from PABackup.dbo.sysobjects where name='tSyncCalendar')
	drop table PABackup.dbo.tSyncCalendar

	Select tSyncCalendar.* Into PABackup.dbo.tSyncCalendar 
	FROM   tSyncCalendar (nolock), tCalendar c (nolock)
	where  tSyncCalendar.CalendarKey = c.CalendarKey
	and    c.CompanyKey = @CompanyKey	 

	exec spTime 'tSyncCalendar', @t output
	
	Print 'tSyncCalendarAttendee'
	if exists (select * from PABackup.dbo.sysobjects where name='tSyncCalendarAttendee')
	drop table PABackup.dbo.tSyncCalendarAttendee

	Select tSyncCalendarAttendee.* Into PABackup.dbo.tSyncCalendarAttendee 
	FROM   tSyncCalendarAttendee (nolock), tCalendar c (nolock)
	where  tSyncCalendarAttendee.CalendarKey = c.CalendarKey
	and    c.CompanyKey = @CompanyKey	 

	exec spTime 'tSyncCalendarAttendee', @t output
	
	Print 'tSystemMessage'
	if exists (select * from PABackup.dbo.sysobjects where name='tSystemMessage')
	drop table PABackup.dbo.tSystemMessage
		 
	select * into PABackup.dbo.tSystemMessage from tSystemMessage  (nolock)

	exec spTime 'tSystemMessage', @t output
	
	Print 'tSystemMessageUser'
	if exists (select * from PABackup.dbo.sysobjects where name='tSystemMessageUser')
	drop table PABackup.dbo.tSystemMessageUser
		 
	select tSystemMessageUser.* into PABackup.dbo.tSystemMessageUser 
	from tSystemMessageUser (nolock), tUser (nolock)
	where tSystemMessageUser.UserKey = tUser.UserKey
	and  isnull(tUser.OwnerCompanyKey, tUser.CompanyKey) = @CompanyKey


	exec spTime 'tSystemMessageUser', @t output
	
	Print 'tTask'
	if exists (select * from PABackup.dbo.sysobjects where name='tTask')
	drop table PABackup.dbo.tTask
	 
	Select tTask.* Into PABackup.dbo.tTask 
	FROM tTask (nolock) , tProject (nolock) 
	Where tTask.ProjectKey = tProject.ProjectKey 
	and tProject.CompanyKey = @CompanyKey

	exec spTime 'tTask', @t output
	
	Print 'tTaskAssignmentType'
	if exists (select * from PABackup.dbo.sysobjects where name='tTaskAssignmentType')
	drop table PABackup.dbo.tTaskAssignmentType
	 
	Select * Into PABackup.dbo.tTaskAssignmentType FROM tTaskAssignmentType  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tTaskAssignmentType', @t output
	
	Print 'tTaskAssignmentTypeService'
	if exists (select * from PABackup.dbo.sysobjects where name='tTaskAssignmentTypeService')
	drop table PABackup.dbo.tTaskAssignmentTypeService
	 
	Select tTaskAssignmentTypeService.* Into PABackup.dbo.tTaskAssignmentTypeService 
	FROM tTaskAssignmentTypeService (NOLOCK), tTaskAssignmentType (NOLOCK) 
	Where tTaskAssignmentTypeService.TaskAssignmentTypeKey = tTaskAssignmentType.TaskAssignmentTypeKey 
	and tTaskAssignmentType.CompanyKey = @CompanyKey
	 
	exec spTime 'tTaskAssignmentTypeService', @t output
	
	Print 'tTaskPredecessor'
	if exists (select * from PABackup.dbo.sysobjects where name='tTaskPredecessor')
	drop table PABackup.dbo.tTaskPredecessor
	 
	Select tTaskPredecessor.* Into PABackup.dbo.tTaskPredecessor 
	FROM tTaskPredecessor (nolock) , tTask (nolock) , tProject  (nolock) 
	Where tTaskPredecessor.TaskKey = tTask.TaskKey 
	and tTask.ProjectKey = tProject.ProjectKey 
	and tProject.CompanyKey = @CompanyKey
	
	exec spTime 'tTaskPredecessor', @t output
	
	Print 'tTaskUser'
	if exists (select * from PABackup.dbo.sysobjects where name='tTaskUser')
	drop table PABackup.dbo.tTaskUser
	 
	SELECT	tu.* INTO PABackup.dbo.tTaskUser 
	FROM tTaskUser tu (nolock) 
	LEFT JOIN tUser u  (nolock) ON tu.UserKey = u.UserKey
	LEFT JOIN tService s  (nolock) ON tu.ServiceKey = s.ServiceKey
	WHERE	(isnull(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey 
		OR	s.CompanyKey = @CompanyKey)
	
	exec spTime 'tTaskUser', @t output
	
	Print 'tTime'
	if exists (select * from PABackup.dbo.sysobjects where name='tTime')
	drop table PABackup.dbo.tTime
	 
    /*
	Select tTime.* Into PABackup.dbo.tTime 
	FROM tTime (nolock), tUser (nolock) 
	Where tTime.UserKey = tUser.UserKey 
	and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey)
	*/

	Select tTime.* Into PABackup.dbo.tTime 
	FROM tTime with (index=IX_tTime_1, nolock) 
		inner join tUser (nolock) on tTime.UserKey = tUser.UserKey 
	Where isnull(tUser.OwnerCompanyKey, tUser.CompanyKey) = @CompanyKey

	exec spTime 'tTime', @t output
	
	Print 'tTime_DELETED'
	if exists (select * from PABackup.dbo.sysobjects where name='tTime_DELETED')
	drop table PABackup.dbo.tTime_DELETED
	 
	Select tTime_DELETED.* Into PABackup.dbo.tTime_DELETED 
	FROM tTime (nolock), tTime_DELETED (nolock), tUser (nolock) 
	Where tTime.UserKey = tUser.UserKey 
	and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey)
	and  tTime_DELETED.TimeKey = tTime.TimeKey 
	
	exec spTime 'tTime_DELETED', @t output
	
	Print 'tTimelineSegment'
	if exists (select * from PABackup.dbo.sysobjects where name='tTimelineSegment')
	drop table PABackup.dbo.tTimelineSegment
	 
	Select * Into PABackup.dbo.tTimelineSegment FROM tTimelineSegment (nolock) WHERE CompanyKey = @CompanyKey
	  
	exec spTime 'tTimelineSegment', @t output
	
	Print 'tTimeOption'
	if exists (select * from PABackup.dbo.sysobjects where name='tTimeOption')
	drop table PABackup.dbo.tTimeOption
	 
	Select * Into PABackup.dbo.tTimeOption FROM tTimeOption  (nolock) WHERE CompanyKey = @CompanyKey
	 
	exec spTime 'tTimeOption', @t output
	
	Print 'tTimeRateSheet'
	if exists (select * from PABackup.dbo.sysobjects where name='tTimeRateSheet')
	drop table PABackup.dbo.tTimeRateSheet
	 
	Select * Into PABackup.dbo.tTimeRateSheet FROM tTimeRateSheet  (nolock) WHERE CompanyKey = @CompanyKey
	 
	exec spTime 'tTimeRateSheet', @t output
	
	Print 'tTimeRateSheetDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tTimeRateSheetDetail')
	drop table PABackup.dbo.tTimeRateSheetDetail
	 
	Select tTimeRateSheetDetail.* Into PABackup.dbo.tTimeRateSheetDetail 
	FROM tTimeRateSheetDetail (nolock), tTimeRateSheet (nolock)
	Where tTimeRateSheetDetail.TimeRateSheetKey = tTimeRateSheet.TimeRateSheetKey 
	and tTimeRateSheet.CompanyKey = @CompanyKey
 
	exec spTime 'tTimeRateSheetDetail', @t output
	
	Print 'tTimeSheet'
	if exists (select * from PABackup.dbo.sysobjects where name='tTimeSheet')
	drop table PABackup.dbo.tTimeSheet
	 
	Select * Into PABackup.dbo.tTimeSheet FROM tTimeSheet (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tTimeSheet', @t output
	
	Print 'tTeam'
	if exists (select * from PABackup.dbo.sysobjects where name='tTeam')
	drop table PABackup.dbo.tTeam
	 
	Select * Into PABackup.dbo.tTeam FROM tTeam (NOLOCK) WHERE CompanyKey = @CompanyKey

	exec spTime 'tTeam', @t output
	
	Print 'tTeamUser'
	if exists (select * from PABackup.dbo.sysobjects where name='tTeamUser')
	drop table PABackup.dbo.tTeamUser
	 
	Select tTeamUser.* Into PABackup.dbo.tTeamUser 
	FROM tTeamUser (NOLOCK)
	     ,tTeam b (NOLOCK) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tTeamUser.TeamKey = b.TeamKey
	 
	exec spTime 'tTeamUser', @t output
	
	Print 'tTransaction'
	if exists (select * from PABackup.dbo.sysobjects where name='tTransaction')
	drop table PABackup.dbo.tTransaction
	 
	Select * Into PABackup.dbo.tTransaction FROM tTransaction (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tTransaction', @t output
	
	Print 'tTransactionUnpost'
	if exists (select * from PABackup.dbo.sysobjects where name='tTransactionUnpost')
	drop table PABackup.dbo.tTransactionUnpost
	 
	Select * Into PABackup.dbo.tTransactionUnpost FROM tTransactionUnpost (nolock)  WHERE CompanyKey = @CompanyKey

	exec spTime 'tTransactionUnpost', @t output
	
	Print 'tTransactionUnpostLog'
	if exists (select * from PABackup.dbo.sysobjects where name='tTransactionUnpostLog')
	drop table PABackup.dbo.tTransactionUnpostLog
	 
	Select * Into PABackup.dbo.tTransactionUnpostLog FROM tTransactionUnpostLog (nolock)  WHERE CompanyKey = @CompanyKey

	exec spTime 'tTransactionUnpostLog', @t output
	
	Print 'tTransactionOrderAccrual'
	if exists (select * from PABackup.dbo.sysobjects where name='tTransactionOrderAccrual')
	drop table PABackup.dbo.tTransactionOrderAccrual
	 
	Select * Into PABackup.dbo.tTransactionOrderAccrual FROM tTransactionOrderAccrual (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tTransactionOrderAccrual', @t output
	
	Print 'tTitle'
	if exists (select * from PABackup.dbo.sysobjects where name='tTitle')
	drop table PABackup.dbo.tTitle
	 
	Select * Into PABackup.dbo.tTitle FROM tTitle (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tTitle', @t output
	
	Print 'tTitleRateSheet'
	if exists (select * from PABackup.dbo.sysobjects where name='tTitleRateSheet')
	drop table PABackup.dbo.tTitleRateSheet
	 
	Select * Into PABackup.dbo.tTitleRateSheet FROM tTitleRateSheet (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tTitleRateSheet', @t output
	
	Print 'tTitleRateSheetDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tTitleRateSheetDetail')
	drop table PABackup.dbo.tTitleRateSheetDetail
	 
	Select tTitleRateSheetDetail.* Into PABackup.dbo.tTitleRateSheetDetail 
	FROM tTitleRateSheetDetail (nolock), tTitleRateSheet b (nolock) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tTitleRateSheetDetail.TitleRateSheetKey = b.TitleRateSheetKey

	exec spTime 'tTitleRateSheetDetail', @t output
	
	Print 'tTitleService'
	if exists (select * from PABackup.dbo.sysobjects where name='tTitleService')
	drop table PABackup.dbo.tTitleService
	 
	Select tTitleService.* Into PABackup.dbo.tTitleService 
	FROM tTitleService (nolock), tTitle b (nolock) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tTitleService.TitleKey = b.TitleKey

	exec spTime 'tTitleService', @t output
	
	Print 'tUser'
	if exists (select * from PABackup.dbo.sysobjects where name='tUser')
	drop table PABackup.dbo.tUser
	 
	Select * Into PABackup.dbo.tUser 
	from tUser (nolock) 
	Where CompanyKey = @CompanyKey 
	or CompanyKey in (Select CompanyKey from tCompany  (nolock) where OwnerCompanyKey = @CompanyKey)
		 
	exec spTime 'tUser', @t output
	
	Print 'tUserGroup'
	if exists (select * from PABackup.dbo.sysobjects where name='tUserGroup')
	drop table PABackup.dbo.tUserGroup
	 
	Select * Into PABackup.dbo.tUserGroup FROM tUserGroup  (nolock) WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tUserGroup', @t output
	
	Print 'tUserGLCompanyAccess'
	if exists (select * from PABackup.dbo.sysobjects where name='tUserGLCompanyAccess')
	drop table PABackup.dbo.tUserGLCompanyAccess
	 
	Select tUserGLCompanyAccess.* Into PABackup.dbo.tUserGLCompanyAccess 
	FROM tUserGLCompanyAccess  (nolock), tUser u  (nolock)
	where tUserGLCompanyAccess.UserKey = u.UserKey 
	and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
	
	exec spTime 'tUserGLCompanyAccess', @t output
	
	Print 'tUserLead'
	if exists (select * from PABackup.dbo.sysobjects where name='tUserLead')
	drop table PABackup.dbo.tUserLead
	 
	Select * Into PABackup.dbo.tUserLead FROM tUserLead  (nolock) WHERE CompanyKey = @CompanyKey
	 
	exec spTime 'tUserLead', @t output
	
	Print 'tUserRole'
	if exists (select * from PABackup.dbo.sysobjects where name='tUserRole')
	drop table PABackup.dbo.tUserRole
	 
	Select * Into PABackup.dbo.tUserRole FROM tUserRole  (nolock) WHERE CompanyKey = @CompanyKey
	
	 
	exec spTime 'tUserRole', @t output
	
	Print 'tUserNotification'
	if exists (select * from PABackup.dbo.sysobjects where name='tUserNotification')
	drop table PABackup.dbo.tUserNotification
	 
	Select tUserNotification.* Into PABackup.dbo.tUserNotification 
	FROM tUserNotification  (nolock), tUser u  (nolock)
	where tUserNotification.UserKey = u.UserKey 
	and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
	 
	exec spTime 'tUserNotification', @t output
	
	Print 'tUserPassword'
	if exists (select * from PABackup.dbo.sysobjects where name='tUserPassword')
	drop table PABackup.dbo.tUserPassword
	 
	Select tUserPassword.* Into PABackup.dbo.tUserPassword 
	FROM tUserPassword  (nolock), tUser u  (nolock)
	where tUserPassword.UserKey = u.UserKey 
	and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
	
	exec spTime 'tUserPassword', @t output
	
	Print 'tUserLoginLog'
	if exists (select * from PABackup.dbo.sysobjects where name='tUserLoginLog')
	drop table PABackup.dbo.tUserLoginLog
	 
	Select tUserLoginLog.* Into PABackup.dbo.tUserLoginLog 
	FROM tUserLoginLog  (nolock), tUser u (nolock) 
	where tUserLoginLog.UserKey = u.UserKey 
	and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey

	exec spTime 'tUserLoginLog', @t output
	
	Print 'tUserMapping'
	if exists (select * from PABackup.dbo.sysobjects where name='tUserMapping')
	drop table PABackup.dbo.tUserMapping
	 
	Select tUserMapping.* Into PABackup.dbo.tUserMapping 
	FROM tUserMapping  (nolock), tUser u (nolock) 
	where tUserMapping.UserKey = u.UserKey 
	and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey

	exec spTime 'tUserMapping', @t output
	
	Print 'tUserPreference'
	if exists (select * from PABackup.dbo.sysobjects where name='tUserPreference')
	drop table PABackup.dbo.tUserPreference
	 
	Select tUserPreference.* Into PABackup.dbo.tUserPreference 
	FROM tUserPreference  (nolock), tUser u  (nolock) 
	where tUserPreference.UserKey = u.UserKey 
	and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
	 
	exec spTime '', @t output
	
	Print 'tUserService'
	if exists (select * from PABackup.dbo.sysobjects where name='tUserService')
	drop table PABackup.dbo.tUserService
	 
	Select tUserService.* Into PABackup.dbo.tUserService 
	FROM tUserService  (nolock), tUser u  (nolock)
	where tUserService.UserKey = u.UserKey 
	and ISNULL(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey
 
	exec spTime 'tUserService', @t output
	
	Print 'tUserSkill'
	if exists (select * from PABackup.dbo.sysobjects where name='tUserSkill')
	drop table PABackup.dbo.tUserSkill
	 
	Select tUserSkill.* Into PABackup.dbo.tUserSkill 
	FROM tUserSkill  (nolock), tUser  (nolock)
	Where tUserSkill.UserKey = tUser.UserKey 
	and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey)
	 
	exec spTime 'tUserSkill', @t output
	
	Print 'tUserSkillSpecialty'
	if exists (select * from PABackup.dbo.sysobjects where name='tUserSkillSpecialty')
	drop table PABackup.dbo.tUserSkillSpecialty
	 
	Select tUserSkillSpecialty.* Into PABackup.dbo.tUserSkillSpecialty 
	FROM tUserSkillSpecialty  (nolock), tUser  (nolock) 
	Where tUserSkillSpecialty.UserKey = tUser.UserKey 
	and (tUser.CompanyKey = @CompanyKey or tUser.OwnerCompanyKey = @CompanyKey) 

	exec spTime 'tUserSkillSpecialty', @t output
	
	Print 'tViewSecurityGroup'
	if exists (select * from PABackup.dbo.sysobjects where name='tViewSecurityGroup')
	drop table PABackup.dbo.tViewSecurityGroup

	Select tViewSecurityGroup.* Into PABackup.dbo.tViewSecurityGroup 
	From   tViewSecurityGroup  (nolock), tSecurityGroup sg  (nolock)
	Where  tViewSecurityGroup.SecurityGroupKey = sg.SecurityGroupKey
	and	   sg.CompanyKey = @CompanyKey

	exec spTime 'tViewSecurityGroup', @t output
	
	Print 'tVoucher'
	if exists (select * from PABackup.dbo.sysobjects where name='tVoucher')
	drop table PABackup.dbo.tVoucher
	 
	Select * Into PABackup.dbo.tVoucher FROM tVoucher  (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tVoucher', @t output
	
	Print 'tVoucherCC'
	if exists (select * from PABackup.dbo.sysobjects where name='tVoucherCC')
	drop table PABackup.dbo.tVoucherCC
	 
	Select tVoucherCC.* Into PABackup.dbo.tVoucherCC 
	FROM tVoucherCC (nolock), tVoucher (nolock)
	WHERE tVoucherCC.VoucherKey = tVoucher.VoucherKey
	and tVoucher.CompanyKey = @CompanyKey

	exec spTime 'tVoucherCC', @t output
	
	Print 'tVoucherCCDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tVoucherCCDetail')
	drop table PABackup.dbo.tVoucherCCDetail
	 
	Select tVoucherCCDetail.* Into PABackup.dbo.tVoucherCCDetail 
	FROM tVoucherCCDetail  (nolock), tVoucher (nolock)
	WHERE tVoucherCCDetail.VoucherKey = tVoucher.VoucherKey
	and tVoucher.CompanyKey = @CompanyKey


	exec spTime 'tVoucherCCDetail', @t output
	
	Print 'tVoucherCredit'
	if exists (select * from PABackup.dbo.sysobjects where name='tVoucherCredit')
	drop table PABackup.dbo.tVoucherCredit
	 
	Select tVoucherCredit.* Into PABackup.dbo.tVoucherCredit 
	FROM tVoucherCredit (nolock), tVoucher (nolock)
	WHERE tVoucherCredit.VoucherKey = tVoucher.VoucherKey
	and tVoucher.CompanyKey = @CompanyKey

	exec spTime 'tVoucherCredit', @t output
	
	Print 'tVoucherTax'
	if exists (select * from PABackup.dbo.sysobjects where name='tVoucherTax')
	drop table PABackup.dbo.tVoucherTax
	 
	Select tVoucherTax.* Into PABackup.dbo.tVoucherTax 
	FROM tVoucherTax (nolock), tVoucher (nolock)
	WHERE tVoucherTax.VoucherKey = tVoucher.VoucherKey
	and tVoucher.CompanyKey = @CompanyKey
	
	exec spTime 'tVoucherTax', @t output
	
	Print 'tVoucherDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tVoucherDetail')
	drop table PABackup.dbo.tVoucherDetail
	 
	Select tVoucherDetail.* Into PABackup.dbo.tVoucherDetail 
	FROM tVoucherDetail (nolock) , tVoucher (nolock) 
	WHERE tVoucherDetail.VoucherKey = tVoucher.VoucherKey
	and tVoucher.CompanyKey = @CompanyKey

	exec spTime 'tVoucherDetail', @t output
	
	Print 'tVoucherDetailTax'
	if exists (select * from PABackup.dbo.sysobjects where name='tVoucherDetailTax')
	drop table PABackup.dbo.tVoucherDetailTax
	 
	Select	tVoucherDetailTax.* Into PABackup.dbo.tVoucherDetailTax 
	FROM	tVoucherDetailTax (NOLOCK), tVoucherDetail (NOLOCK), tVoucher (NOLOCK) 
	Where	tVoucherDetailTax.VoucherDetailKey = tVoucherDetail.VoucherDetailKey
	and     tVoucherDetail.VoucherKey = tVoucher.VoucherKey 
	and		tVoucher.CompanyKey = @CompanyKey
	
	exec spTime 'tVoucherDetailTax', @t output
	
	Print 'tWIPPosting'
	if exists (select * from PABackup.dbo.sysobjects where name='tWIPPosting')
	drop table PABackup.dbo.tWIPPosting
	 
	Select * Into PABackup.dbo.tWIPPosting FROM tWIPPosting (nolock)  WHERE CompanyKey = @CompanyKey
	
	exec spTime 'tWIPPosting', @t output
	
	Print 'tWIPPostingDetail'
	if exists (select * from PABackup.dbo.sysobjects where name='tWIPPostingDetail')
	drop table PABackup.dbo.tWIPPostingDetail
	 
	Select tWIPPostingDetail.* Into PABackup.dbo.tWIPPostingDetail 
	FROM tWIPPostingDetail (nolock) , tWIPPosting (nolock)
	WHERE tWIPPostingDetail.WIPPostingKey = tWIPPosting.WIPPostingKey
	and tWIPPosting.CompanyKey = @CompanyKey
	
	exec spTime 'tWIPPostingDetail', @t output
	
	Print 'tWidget'
	if exists (select * from PABackup.dbo.sysobjects where name='tWidget')
	drop table PABackup.dbo.tWidget
	 
	Select * Into PABackup.dbo.tWidget FROM tWidget (nolock) WHERE CompanyKey = @CompanyKey
	Or CompanyKey IS NULL
	
	exec spTime '', @t output
	
	Print 'tWidgetCompany'
	if exists (select * from PABackup.dbo.sysobjects where name='tWidgetCompany')
	drop table PABackup.dbo.tWidgetCompany
	 
	Select * Into PABackup.dbo.tWidgetCompany FROM tWidgetCompany (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tWidgetCompany', @t output
	
	Print 'tWidgetSecurity'
	if exists (select * from PABackup.dbo.sysobjects where name='tWidgetSecurity')
	drop table PABackup.dbo.tWidgetSecurity
	 
	Select tWidgetSecurity.* Into PABackup.dbo.tWidgetSecurity 
	FROM tWidgetSecurity (nolock), tSecurityGroup (nolock)
	WHERE tWidgetSecurity.SecurityGroupKey = tSecurityGroup.SecurityGroupKey
	and tSecurityGroup.CompanyKey = @CompanyKey
	
	exec spTime 'tWidgetSecurity', @t output
	
	Print 'tWorkType'
	if exists (select * from PABackup.dbo.sysobjects where name='tWorkType')
	drop table PABackup.dbo.tWorkType
	 
	Select * Into PABackup.dbo.tWorkType FROM tWorkType  (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tWorkType', @t output
	
	Print 'tWorkTypeCustom'
	if exists (select * from PABackup.dbo.sysobjects where name='tWorkTypeCustom')
	drop table PABackup.dbo.tWorkTypeCustom
	 
	Select tWorkTypeCustom.* Into PABackup.dbo.tWorkTypeCustom 
	FROM tWorkType (nolock), tWorkTypeCustom  (nolock)
	WHERE tWorkType.CompanyKey = @CompanyKey
	AND   tWorkType.WorkTypeKey = tWorkTypeCustom.WorkTypeKey

	exec spTime 'tWorkTypeCustom', @t output
	
	Print 'tWriteOffReason'
	if exists (select * from PABackup.dbo.sysobjects where name='tWriteOffReason')
	drop table PABackup.dbo.tWriteOffReason
	 
	Select * Into PABackup.dbo.tWriteOffReason FROM tWriteOffReason (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tWriteOffReason', @t output
	
	Print 'tWebDavServer'
	if exists (select * from PABackup.dbo.sysobjects where name='tWebDavServer')
	drop table PABackup.dbo.tWebDavServer
	 
	Select * Into PABackup.dbo.tWebDavServer FROM tWebDavServer (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime '', @t output
	
	Print 'tWebDavFile'
	if exists (select * from PABackup.dbo.sysobjects where name='tWebDavFile')
	drop table PABackup.dbo.tWebDavFile
	 
	Select * Into PABackup.dbo.tWebDavFile FROM tWebDavFile (nolock) WHERE CompanyKey = @CompanyKey

	exec spTime 'tWebDavFile', @t output
	
	Print 'tWebDavFileHistory'
	if exists (select * from PABackup.dbo.sysobjects where name='tWebDavFileHistory')
	drop table PABackup.dbo.tWebDavFileHistory
	 
	Select tWebDavFileHistory.* Into PABackup.dbo.tWebDavFileHistory 
	FROM tWebDavFileHistory (nolock), tWebDavFile b (nolock) 
	WHERE b.CompanyKey = @CompanyKey
	AND   tWebDavFileHistory.FileKey = b.FileKey

	exec spTime 'tWebDavFileHistory', @t output
	
	Print 'tWebDavLog'
	if exists (select * from PABackup.dbo.sysobjects where name='tWebDavLog')
	drop table PABackup.dbo.tWebDavLog
	 
	Select tWebDavLog.* Into PABackup.dbo.tWebDavLog 
	FROM tWebDavLog (nolock)
	WHERE tWebDavLog.CompanyKey = @CompanyKey
	
	exec spTime 'tWebDavLog', @t output
	
	Print 'tWebDavSecurity'
	if exists (select * from PABackup.dbo.sysobjects where name='tWebDavSecurity')
	drop table PABackup.dbo.tWebDavSecurity
	 
	Select tWebDavSecurity.* Into PABackup.dbo.tWebDavSecurity 
	FROM tWebDavSecurity (nolock)
	WHERE tWebDavSecurity.CompanyKey = @CompanyKey

	exec spTime 'tWebDavSecurity', @t output
	
	Print 'tVPaymentLog'
	if exists (select * from PABackup.dbo.sysobjects where name='tVPaymentLog')
	drop table PABackup.dbo.tVPaymentLog

	Select tVPaymentLog.* Into PABackup.dbo.tVPaymentLog 
	FROM tVPaymentLog (nolock)
	WHERE tVPaymentLog.CompanyKey = @CompanyKey

	exec spTime 'tVPaymentLog', @t output

	IF @BackupPath IS NOT NULL
	BEGIN

		-- Password created WJ + company key 
		DECLARE @Pwd varchar(25)
		DECLARE @filename varchar(1000) 
		SELECT @Pwd = 'WJ', @filename = cast(YEAR(GETDATE()) as varchar)


		if MONTH(GETDATE()) < 10
			Select @Pwd = @Pwd + '0', @filename = @filename + '0' 

		Select @Pwd = @Pwd + convert(varchar(2),MONTH(GETDATE())), @filename = @filename + convert(varchar(2),MONTH(GETDATE()))

		if DAY(GETDATE()) < 10
			Select @Pwd = @Pwd + '0', @filename = @filename + '0' 

		Select @Pwd = @Pwd + convert(varchar(2),DAY(GETDATE())), @filename = @filename + convert(varchar(2),DAY(GETDATE()))

		Select @Pwd = @Pwd +  convert(varchar(25),@CompanyKey), @filename = convert(varchar(25),@CompanyKey) + '_' +  @filename


		-- Backup Database using CompanyKey as name of file
		--SELECT @DataBackup = @BackupPath + CAST(@CompanyKey AS varchar) + '.bak'
		SELECT @DataBackup = @BackupPath + @filename + '.bak'

-- SECTION TO DELETE A FILE (NEEDED BECAUSE OF THE PASSWORDS)
		/*

		Not needed anymore because we are using a unique name per day

		-- To allow advanced options to be changed.
		EXEC sp_configure 'show advanced options', 1

		-- To update the currently configured value for advanced options.
		RECONFIGURE

		-- To enable the feature.
		EXEC sp_configure 'xp_cmdshell', 1

		-- To update the feature.
		RECONFIGURE

		--EXEC xp_cmdshell 'del c:\backup\100.bak'
		declare @cmdDelete varchar(100)
		select @cmdDelete = 'del ' + @DataBackup
		EXEC xp_cmdshell @cmdDelete

		 -- To disable the feature.
		EXEC sp_configure 'xp_cmdshell', 0

		-- To update the feature.
		RECONFIGURE

		-- To disallow advanced options to be changed.
		EXEC sp_configure 'show advanced options', 0

		-- To update the currently configured value for advanced options.
		RECONFIGURE
		*/

-- END SECTION TO DELETE A FILE (NEEDED BECAUSE OF THE PASSWORDS)


		-- Create the backup device for the full backup.
		EXEC sp_addumpdevice 'disk', 'PABackup_dat', @DataBackup

		-- Back up the full database.
		-- If you get an ACCESS DENIED error, make sure that you have folder rights for NETWORK SERVICE
		-- Usually it will be c:\backup 

		IF @WithPassword = 0
			BACKUP DATABASE PABackup TO PABackup_dat With INIT
		ELSE
			BACKUP DATABASE PABackup TO PABackup_dat With INIT, MEDIAPASSWORD = @Pwd

		EXEC sp_dropdevice 'PABackup_dat'

		/* To restore, use the following command

		RESTORE DATABASE PARestore 
		FROM DISK = 'c:\temp\100.bak'
		WITH MEDIAPASSWORD = 'WJ0813100'
		,MOVE 'PABackup' to 'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\PARestore.mdf'
		,MOVE 'PABackup_log' to 'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\PARestore_log.ldf'
		,REPLACE

		*/


		IF @WithPassword = 1 
		BEGIN
			print ''
			print 'To restore database, type the following command:'
			print ''

			print 'RESTORE DATABASE PARestore' 
			--print 'FROM DISK = ''c:\temp\100.bak'''
			--print 'WITH MEDIAPASSWORD = ''WJ100'''
			print 'FROM DISK = ''c:\temp\' + @filename + '.bak'''
			print 'WITH MEDIAPASSWORD = ''' + @Pwd + ''''
			print ',MOVE ''PABackup'' to ''C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\PARestore.mdf'''
			print ',MOVE ''PABackup_log'' to ''C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\PARestore_log.ldf'''
			print ',REPLACE'
		END

	END
GO
