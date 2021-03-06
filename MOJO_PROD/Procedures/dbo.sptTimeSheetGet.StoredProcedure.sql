USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetGet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeSheetGet]
 @TimeSheetKey int
AS --Encrypt

/*
|| When      Who Rel		What
|| 10/15/09  GWG 10.5.1.2	Modified the check for billed to be only for entries on an actual invoice
|| 10/25/11  GWG 10.5.4.9   Added a flag in tPreference so that registered user check can be bypassed for system setup
|| 10/22/12  KMC 10.5.6.1   Added the BackupApproverKey so the Edit Timesheet screen can enable/disable the Approve/Reject button
|| 09/27/13  GHL 10.5.7.2   Added tBilling.CompanyKey = @CompanyKey to increase performance 
*/

Declare @WipPost tinyint, @Billed tinyint, @Registered tinyint, @UserKey int, @BillingDetail tinyint, @CompanyKey int, @DisableValidation tinyint

Select @UserKey = UserKey, @CompanyKey = CompanyKey from tTimeSheet (NOLOCK) Where TimeSheetKey = @TimeSheetKey

if exists(Select 1 from tTime (NOLOCK) Where TimeSheetKey = @TimeSheetKey and (WIPPostingInKey > 0 or WIPPostingOutKey > 0))
	Select @WipPost = 1
else
	Select @WipPost = 0
	
if exists(Select 1 from tBillingDetail bd (nolock)
					inner join tTime t (nolock) on bd.EntityGuid = t.TimeKey
					inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey  
				Where t.TimeSheetKey = @TimeSheetKey
				And   bd.Entity = 'tTime'
				And   b.Status < 5
				And   b.CompanyKey = @CompanyKey
				)
	Select @BillingDetail = 1
else
	Select @BillingDetail = 0
	
if exists(Select 1 from tTime (NOLOCK) Where TimeSheetKey = @TimeSheetKey and InvoiceLineKey > 0)  -- was (InvoiceLineKey is null or WriteOff = 1)
	Select @Billed = 1
else
	Select @Billed = 0
	
if exists(Select 1 From tUser (nolock) Where UserKey = @UserKey and	Len(UserID) > 0 and	Active = 1 and ClientVendorLogin = 0)
	Select @Registered = 1
else
	Select @Registered = 0

if @Registered = 0
	Select @Registered = ISNULL(DisableValidation, 0) from tPreference (nolock) Where CompanyKey = @CompanyKey
	
  SELECT ts.*,
	u.FirstName + ' ' + u.LastName as UserName,
	u.Email as UserEmail,
	u.TimeApprover as ApproverKey,
	u.RateLevel,
	app.FirstName + ' ' + app.LastName as ApproverName,
	app.Email as ApproverEmail,
	app.BackupApprover as BackupApproverKey,
	@Billed as Billed,
	@WipPost as WipPost,
	@BillingDetail as BillingDetail,
	@Registered as RegisteredUser
  FROM tTimeSheet ts (nolock)
	inner join tUser u (nolock) on ts.UserKey = u.UserKey
	left outer join tUser app (nolock) on u.TimeApprover = app.UserKey
  WHERE
   TimeSheetKey = @TimeSheetKey
 RETURN 1
GO
