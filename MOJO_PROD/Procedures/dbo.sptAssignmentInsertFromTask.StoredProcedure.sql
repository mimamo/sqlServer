USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentInsertFromTask]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAssignmentInsertFromTask]
 @ProjectKey int,
 @UserKey int
 
AS --Encrypt

  /*
  || When     Who Rel    What
  || 01/12/07 GHL 8.4    Added protection against null ProjectKey (we are getting error emails)   
  || 12/13/10 RLB 10.539 (94833) when adding a user to project just bring in Default service if there is one            
  || 12/15/11 GWG 10.5.5.1 Added handling of defaults for subscribing and deliverable review and notify      
  */

IF @ProjectKey IS NULL OR @UserKey IS NULL
	RETURN 1
	
Declare @HourlyRate money
Declare @SubscribeDiary tinyint, @SubscribeToDo tinyint, @DeliverableReviewer tinyint, @DeliverableNotify tinyint

IF Not Exists(Select 1 from tAssignment (nolock) Where UserKey = @UserKey and ProjectKey = @ProjectKey)
BEGIN

	SELECT @HourlyRate = ISNULL(tUser.HourlyRate, 0),
		@SubscribeDiary = ISNULL(SubscribeDiary, 0),
		@SubscribeToDo = ISNULL(SubscribeToDo, 0),
		@DeliverableReviewer = ISNULL(DeliverableReviewer, 0),
		@DeliverableNotify = ISNULL(DeliverableNotify, 0) 
	FROM tUser (nolock) WHERE UserKey = @UserKey
	
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
	 
	Insert tProjectUserServices (ProjectKey, UserKey, ServiceKey)
	Select @ProjectKey, @UserKey, DefaultServiceKey
	from tUser (nolock) Where UserKey = @UserKey and DefaultServiceKey IS NOT NULL
	
END
 
RETURN 1
GO
