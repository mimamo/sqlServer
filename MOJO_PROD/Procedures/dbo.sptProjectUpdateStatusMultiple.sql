USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUpdateStatusMultiple]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUpdateStatusMultiple]
	(
		@ProjectKey int,
		@ProjectStatusKey int,
		@ProjectBillingStatusKey int,
		@AccountManager int,
		@ProjectColor varchar(10),
		@EditLocked tinyint
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/12/07  CRG 8.4.3.8  (14378) Added logic to change the Active flag when the Project Status is changed.
|| 01/28/09  MFT 10.0.1.8 (45415) Added RETURN -1 to trap for missing ProjectStatusKey record
|| 03/04/13  GHL 10.5.6.5 (170420) Make sure that the account manager is part of the team
*/

Declare @CurrentStatus int, 
		@Locked tinyint,
		@Active tinyint,
		@CurrentActive tinyint

Select @ProjectStatusKey = ISNULL(@ProjectStatusKey, ProjectStatusKey),
		@CurrentStatus = ProjectStatusKey,
		@ProjectBillingStatusKey = ISNULL(@ProjectBillingStatusKey, ProjectBillingStatusKey),
		@AccountManager = ISNULL(@AccountManager, AccountManager),
		@ProjectColor = ISNULL(@ProjectColor, ProjectColor),
		@CurrentActive = Active
From tProject (nolock) Where ProjectKey = @ProjectKey

SELECT	@Active = @CurrentActive

if @ProjectStatusKey <> @CurrentStatus
BEGIN
	Select	@Locked = ISNULL(Locked, 0)
	from	tProjectStatus (nolock) 
	Where	ProjectStatusKey = @CurrentStatus

	Select	@Active = IsActive
	from	tProjectStatus (nolock) 
	Where	ProjectStatusKey = @ProjectStatusKey
	
	IF @Active IS NULL RETURN -1
END
ELSE
	Select @Locked = 0

if @Locked = 1 and @EditLocked = 0
	Select	@ProjectStatusKey = @CurrentStatus,
			@Active = @CurrentActive
	
Update	tProject 
Set		ProjectStatusKey = @ProjectStatusKey,
		ProjectBillingStatusKey = @ProjectBillingStatusKey,
		AccountManager = @AccountManager,
		ProjectColor = @ProjectColor,
		Active = @Active
Where	ProjectKey = @ProjectKey

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
GO
