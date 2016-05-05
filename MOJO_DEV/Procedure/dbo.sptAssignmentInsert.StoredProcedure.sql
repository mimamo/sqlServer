USE [MOJo_dev]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentInsert]    Script Date: 04/29/2016 16:35:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[sptAssignmentInsert]
 @ProjectKey int,
 @UserKey int,
 @HourlyRate money
 --@oIdentity INT OUTPUT
AS --Encrypt

 /*
  || When     Who Rel    What
  || 12/29/10 GHL 10.539 Added checking of DefaultServiceKey not null before inserting in tProjectUserServices
  ||                     because this table does not accept null ServiceKey 
  || 12/15/11 GWG 10.5.5.1 Added handling of defaults for subscribing and deliverable review and notify
  */

Declare @SubscribeDiary tinyint, @SubscribeToDo tinyint, @DeliverableReviewer tinyint, @DeliverableNotify tinyint

IF Exists(Select 1 from tAssignment (nolock) Where UserKey = @UserKey and ProjectKey = @ProjectKey)
	return 1

If not Exists(Select 1 from tUser (nolock) Where UserKey = @UserKey)
	return 1

IF @HourlyRate IS NULL
	SELECT @HourlyRate = ISNULL(tUser.HourlyRate, 0) 
	
FROM tUser (nolock) WHERE UserKey = @UserKey

Select	@SubscribeDiary = SubscribeDiary,
		@SubscribeToDo = SubscribeToDo,
		@DeliverableReviewer = DeliverableReviewer,
		@DeliverableNotify = DeliverableNotify
From tUser (nolock) Where UserKey = @UserKey


 INSERT tAssignment
  (
	ProjectKey,
	UserKey,
	HourlyRate,
	SubscribeDiary,
	SubscribeToDo,
	DeliverableReviewer,
	DeliverableNotify
  )
 VALUES
  (
	@ProjectKey,
	@UserKey,
	@HourlyRate,
	@SubscribeDiary,
	@SubscribeToDo,
	@DeliverableReviewer,
	@DeliverableNotify
  )
  
 Delete tProjectUserServices Where ProjectKey = @ProjectKey and UserKey = @UserKey
 
 Declare @DefaultServiceKey int
 Select @DefaultServiceKey = DefaultServiceKey from tUser (nolock) where UserKey = @UserKey

 If isnull(@DefaultServiceKey, 0) > 0
	 Insert tProjectUserServices (ProjectKey, UserKey, ServiceKey)
	 Values ( @ProjectKey, @UserKey, @DefaultServiceKey)

 --SELECT @oIdentity = @@IDENTITY
 RETURN 1
 





