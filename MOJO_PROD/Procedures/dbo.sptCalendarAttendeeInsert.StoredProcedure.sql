USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarAttendeeInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarAttendeeInsert]
	@CalendarKey int,
	@EntityKey int,
	@Entity varchar(50),
	@Status int	 
 
AS --Encrypt

/*
|| When      Who Rel      What
|| 8/28/08   CRG 10.5.0.0 Modified for 10.5
|| 10/24/12  CRG 10.5.6.1 (157643) Fixed the resource section so that it updates existing resources on a meeting.
*/

-- Assume that we will do it in this order
-- 1 Organizer, 2 Groups, 3 Attendees and Resources

DECLARE @UserKey INT
		,@CalendarAttendeeKey INT
		,@OrganizerKey INT

IF @Entity = 'Organizer'
BEGIN
	Delete tCalendarAttendeeGroup
	From   tCalendarAttendee ca (NOLOCK)
	Where  ca.CalendarKey = @CalendarKey
	and    tCalendarAttendeeGroup.CalendarKey = @CalendarKey
	and    ca.CalendarAttendeeKey = tCalendarAttendeeGroup.CalendarAttendeeKey 
	and    ca.Entity = 'Attendee' 
	and    ca.EntityKey = @EntityKey
	
	Delete tCalendarAttendee Where CalendarKey = @CalendarKey and Entity = 'Attendee' and EntityKey = @EntityKey
		
	if exists(Select 1 From tCalendarAttendee (nolock) 
				where CalendarKey = @CalendarKey and Entity = 'Organizer')
	BEGIN
		Update	tCalendarAttendee 
		Set		EntityKey = @EntityKey,
				IsDistributionGroup = 0,
				Status = @Status
		Where	CalendarKey = @CalendarKey 
		and		Entity = 'Organizer'
	END
	else
	BEGIN
		INSERT tCalendarAttendee (CalendarKey, EntityKey, Entity, Status, IsDistributionGroup)
		VALUES (@CalendarKey, @EntityKey, @Entity, @Status, 0)
	END
END

-- Groups will be processed before users, so insert users with IsDistributionGroup flags set to 1  
					
IF @Entity = 'Group'
BEGIN
	-- Make sure that the group is valid since on the same UI, the user can delete a group
	IF NOT EXISTS (SELECT 1
					FROM  tDistributionGroup (NOLOCK)
					WHERE DistributionGroupKey = @EntityKey
					)
		RETURN 1
	
	-- Get the organizer, it should have been inserted first		
	SELECT @OrganizerKey = EntityKey
	FROM   tCalendarAttendee (NOLOCK)
	WHERE  CalendarKey = @CalendarKey
	AND    Entity = 'Organizer'
				
	SELECT @OrganizerKey = ISNULL(@OrganizerKey, 0)

	-- Make sure that these records are deleted to insert safely
	-- No need to save them and reuse like tCalendarAttendee records
	DELETE tCalendarAttendeeGroup WHERE CalendarKey = @CalendarKey AND DistributionGroupKey = @EntityKey
	
	-- First insert the group
	IF NOT EXISTS (SELECT 1 FROM tCalendarAttendee (NOLOCK)
					WHERE CalendarKey = @CalendarKey 
					AND   Entity = @Entity
					AND   EntityKey = @EntityKey)
	INSERT tCalendarAttendee (CalendarKey, Entity, EntityKey, Status, IsDistributionGroup)
	VALUES (@CalendarKey, @Entity, @EntityKey, @Status, 0)
	
	-- Then insert all the users in group EXCEPT the organizer
	SELECT @UserKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @UserKey = MIN(UserKey)
		FROM   tDistributionGroupUser (NOLOCK)
		WHERE  UserKey > @UserKey AND UserKey <> @OrganizerKey 
		AND    DistributionGroupKey = @EntityKey
	
		IF @UserKey IS NULL
			BREAK
			
		-- Check whether the user is already an attendee
		-- If he is do not insert again but update the IsDistributionGroup flag
		-- (If the user is 'inserted' again as an regular attendee, it will be reset)
		-- If the user is not, insert it			

		SELECT @CalendarAttendeeKey = NULL
		
		SELECT @CalendarAttendeeKey = CalendarAttendeeKey
		FROM   tCalendarAttendee (NOLOCK)
		WHERE  CalendarKey = @CalendarKey
		AND    Entity = 'Attendee'
		AND    EntityKey = @UserKey		
		
		IF @CalendarAttendeeKey IS NOT NULL
			UPDATE	tCalendarAttendee
			SET		IsDistributionGroup = 1
			WHERE	CalendarKey = @CalendarKey
			AND		Entity = 'Attendee'
			AND		EntityKey = @UserKey
			AND		Status = @Status
		ELSE
		BEGIN
			INSERT tCalendarAttendee (CalendarKey, Entity, EntityKey, Status, IsDistributionGroup)
			VALUES (@CalendarKey, 'Attendee', @UserKey, @Status, 1)

			SELECT @CalendarAttendeeKey = @@IDENTITY		
		END	
		
		INSERT tCalendarAttendeeGroup (CalendarKey, CalendarAttendeeKey, DistributionGroupKey) 
		VALUES (@CalendarKey, @CalendarAttendeeKey, @EntityKey)
		
	END
END

IF @Entity = 'Attendee'
BEGIN
	-- Original code but still OK to be careful here
	-- If user is organizer, leave him this way
	if exists(Select 1 from tCalendarAttendee (nolock) 
		Where CalendarKey = @CalendarKey and Entity = 'Organizer' and EntityKey = @EntityKey)
	BEGIN
		Delete tCalendarAttendeeGroup
		From   tCalendarAttendee ca (NOLOCK)
		Where  ca.CalendarKey = @CalendarKey
		and   tCalendarAttendeeGroup.CalendarKey = @CalendarKey
		and    ca.CalendarAttendeeKey = tCalendarAttendeeGroup.CalendarAttendeeKey 
		and    ca.Entity = 'Attendee' 
		and    ca.EntityKey = @EntityKey

		Delete tCalendarAttendee Where CalendarKey = @CalendarKey and Entity = 'Attendee' and EntityKey = @EntityKey
	END
	ELSE
	BEGIN
		SELECT @CalendarAttendeeKey = NULL
		
		SELECT @CalendarAttendeeKey = CalendarAttendeeKey
		FROM   tCalendarAttendee (NOLOCK)
		WHERE  CalendarKey = @CalendarKey
		AND    Entity = 'Attendee' 
		AND    EntityKey = @EntityKey
		
		IF @CalendarAttendeeKey IS NULL
			INSERT tCalendarAttendee (CalendarKey, EntityKey, Entity, Status, IsDistributionGroup)
			VALUES (@CalendarKey, @EntityKey, @Entity, @Status, 0)
		ELSE
		BEGIN 
			-- Make sure that we reset this flag to make it visible in the DD list
			UPDATE	tCalendarAttendee
			SET		IsDistributionGroup = 0,
					Status = @Status
			WHERE	CalendarKey = @CalendarKey -- to help with indexes???
			AND		CalendarAttendeeKey = @CalendarAttendeeKey		
			 
			-- Remove user from all groups 
			DELETE tCalendarAttendeeGroup
			WHERE  CalendarKey = @CalendarKey
			AND    CalendarAttendeeKey = @CalendarAttendeeKey		
		END	
	END
END


IF @Entity = 'Resource'
BEGIN
	if not exists(Select 1 From tCalendarAttendee (nolock) where CalendarKey = @CalendarKey and Entity = 'Resource' and EntityKey = @EntityKey)
		INSERT tCalendarAttendee (CalendarKey, EntityKey, Entity, Status, IsDistributionGroup)
		VALUES (@CalendarKey, @EntityKey, @Entity, @Status, 0)
	ELSE
	BEGIN
		SELECT @CalendarAttendeeKey = NULL
		
		SELECT @CalendarAttendeeKey = CalendarAttendeeKey
		FROM   tCalendarAttendee (NOLOCK)
		WHERE  CalendarKey = @CalendarKey
		AND    Entity = 'Resource' 
		AND    EntityKey = @EntityKey
		
		UPDATE	tCalendarAttendee
		SET		Status = @Status
		WHERE	CalendarKey = @CalendarKey -- to help with indexes???
		AND		CalendarAttendeeKey = @CalendarAttendeeKey		
	END
END


RETURN 1
GO
