USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUpdateStatus2]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUpdateStatus2]
 @ProjectKey int,
 @ProjectStatusKey int,
 @ProjectBillingStatusKey int,
 @ProjectTypeKey int,
 @StatusNotes varchar(100),
 @DetailedNotes varchar(4000),
 @ClientNotes varchar(4000),
 @AccountManager int = null,
 @BillingManagerKey int = null,
 @KeyPeople1 int = null,
 @KeyPeople2 int = null,
 @KeyPeople3 int = null,
 @KeyPeople4 int = null,
 @KeyPeople5 int = null,
 @KeyPeople6 int = null,
 @ProjectColor varchar(10) = null,
 @UpdateProjectStatus tinyint = 0,
 @EditLocked tinyint = 1,
 @Closed int = 0
AS --Encrypt

/*
|| When     Who Rel      What
|| 04/16/08 GHL WMJ10    (25169) Restored backwards compatibility with CMP85, made new parameters optional
|| 06/11/08 CRG 10.0.0.2 (28393) Added logic to ensure that the user can change the status
|| 01/29/09 MFT 10.0.1.8 (45415) Added RETURN -2 to trap for missing ProjectStatusKey record; Removed ineffective @ReturnValue
|| 08/25/11 GHL 10.4.5.7 (119571) Added ProjectTypeKey param
|| 07/26/12 RLB 10.5.5.8 (137086) Added Close Project and all the checks and CloseProjectDate code
|| 03/04/13 GHL 10.5.6.5 (170420) Make sure that the account manager is part of the team
|| 10/27/14 WDF 10.5.8.5 (226197) Added KeyPeople 1 thru 6
|| 11/06/14 WDF 10.5.8.6 (233679) Added BillingManagerKey
*/

	Declare @Active tinyint,
			@AllowTime tinyint,
			@AllowExpense tinyint,
			@Locked tinyint,
			@CurClosed tinyint,
			@OldProjectStatusKey int,
			@ProjectCloseDate smalldatetime
	
	SELECT	@Active = IsActive,
			@AllowTime = TimeActive,
			@AllowExpense = ExpenseActive
	FROM	tProjectStatus (NOLOCK) 
	WHERE	ProjectStatusKey = @ProjectStatusKey
	
	IF @Active IS NULL RETURN -2 --ProjectStatusKey record does not exist
	
	--If the ProjectStatus is being updated, make sure that the user can update it
	SELECT	@CurClosed = Closed,
			@OldProjectStatusKey = ProjectStatusKey,
			@ProjectCloseDate = ProjectCloseDate
	FROM	tProject (NOLOCK)
	WHERE	ProjectKey = @ProjectKey
		

	IF @UpdateProjectStatus = 1
	BEGIN
		SELECT	@Locked = Locked
		FROM	tProjectStatus (NOLOCK)
		WHERE	ProjectStatusKey = @OldProjectStatusKey


		IF @CurClosed = 1 OR (@Locked = 1 AND @EditLocked = 0)
			RETURN -1
	END
	
	IF @Closed = 1 and @Active = 1 
		return -3

	if @Closed = 1 and @Active = 0 and (@AllowTime = 1 OR @AllowExpense = 1)
		return -9
	
	if @Closed = 1 and @CurClosed = 0
	BEGIN
		If Exists(Select 1 from tTime (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey is null and WriteOff = 0)
			return -301
		If Exists(Select 1 from tExpenseReceipt (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey is null and WriteOff = 0 and VoucherDetailKey is null)
			return -302
		If Exists(Select 1 from tMiscCost (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey is null and WriteOff = 0)
			return -303
		If Exists(Select 1 from tVoucherDetail (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey is null and WriteOff = 0)
			return -304
		If Exists(Select 1 from tPurchaseOrderDetail (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey is null and Closed = 0)
			return -305
	END

	if @Closed = 1 and @CurClosed = 0
	
		Select @ProjectCloseDate = GETUTCDATE()
	
	if @Closed = 0 and @CurClosed = 1
		Select @ProjectCloseDate = NULL


	UPDATE
	 tProject
	SET
	 ProjectStatusKey = @ProjectStatusKey,
	ProjectBillingStatusKey = @ProjectBillingStatusKey,
	ProjectTypeKey = @ProjectTypeKey,
	StatusNotes = @StatusNotes,
	DetailedNotes = @DetailedNotes,
	ClientNotes = @ClientNotes,
	Active = @Active,
	AccountManager = ISNULL(@AccountManager, AccountManager),
	BillingManagerKey = ISNULL(@BillingManagerKey, BillingManagerKey),
	KeyPeople1 = ISNULL(@KeyPeople1, KeyPeople1),
	KeyPeople2 = ISNULL(@KeyPeople2, KeyPeople2),
	KeyPeople3 = ISNULL(@KeyPeople3, KeyPeople3),
	KeyPeople4 = ISNULL(@KeyPeople4, KeyPeople4),
	KeyPeople5 = ISNULL(@KeyPeople5, KeyPeople5),
	KeyPeople6 = ISNULL(@KeyPeople6, KeyPeople6),
	ProjectColor = ISNULL(@ProjectColor, ProjectColor),
	Closed = @Closed,
	ProjectCloseDate = @ProjectCloseDate
	WHERE
	 ProjectKey = @ProjectKey 
	

	if isnull(@AccountManager, 0) > 0 and not exists (select 1 from tAssignment (nolock) where ProjectKey = @ProjectKey and UserKey = @AccountManager)
	INSERT tAssignment (ProjectKey, UserKey, HourlyRate, SubscribeDiary, SubscribeToDo, DeliverableReviewer, DeliverableNotify)
	SELECT @ProjectKey  
			 ,UserKey
			 ,HourlyRate
			 ,isnull(SubscribeDiary, 0)
			 ,isnull(SubscribeToDo, 0)
			 ,isnull(DeliverableReviewer, 0)
			 ,isnull(DeliverableNotify, 0)
	FROM   tUser (NOLOCK)
	WHERE  UserKey = @AccountManager



	RETURN 1
GO
