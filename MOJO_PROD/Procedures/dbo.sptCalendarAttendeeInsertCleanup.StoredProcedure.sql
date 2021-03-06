USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarAttendeeInsertCleanup]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarAttendeeInsertCleanup]
	(
		@CalendarKey INT
		,@Entity VARCHAR(50)
		,@EntityKeys VARCHAR(8000)
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	-- We need to this because during Inserts we try not to burn existing CalendarAttendeeKeys	
	-- so there is a cleanup operation needed after inserts
	-- Should be done in order: 1 group, 2 attendees and resources 
	
	DECLARE @MyStatement VARCHAR(8000)
	
	IF @Entity = 'Group'
	BEGIN
	
		SELECT @MyStatement = 'DELETE tCalendarAttendeeGroup WHERE CalendarKey = ' + CAST(@CalendarKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' AND DistributionGroupKey NOT IN ( '
		SELECT @MyStatement = @MyStatement + @EntityKeys
		SELECT @MyStatement = @MyStatement + ' ) '
		
		EXEC ( @MyStatement )	
		
		SELECT @MyStatement = 'DELETE tCalendarAttendee WHERE CalendarKey = ' + CAST(@CalendarKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' AND Entity =''Group'' '
		SELECT @MyStatement = @MyStatement + ' AND EntityKey NOT IN ( '
		SELECT @MyStatement = @MyStatement + @EntityKeys
		SELECT @MyStatement = @MyStatement + ' ) '
		
		EXEC ( @MyStatement )	

		SELECT @MyStatement = 'DELETE tCalendarAttendee WHERE CalendarKey = ' + CAST(@CalendarKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' AND Entity =''Attendee'' '
		SELECT @MyStatement = @MyStatement + ' AND IsDistributionGroup = 1 ' -- Attendeed belonging to groups		
		SELECT @MyStatement = @MyStatement + ' AND EntityKey NOT IN ( SELECT UserKey FROM tDistributionGroupUser (NOLOCK) '
		SELECT @MyStatement = @MyStatement + '                        WHERE  DistributionGroupKey IN ( '
		SELECT @MyStatement = @MyStatement +                                                        @EntityKeys
		SELECT @MyStatement = @MyStatement + '														 ) '
		SELECT @MyStatement = @MyStatement + '                       ) '

		EXEC ( @MyStatement )	

	END
		
		
	IF @Entity = 'Attendee'
	BEGIN
		
		SELECT @MyStatement = 'DELETE tCalendarAttendee WHERE CalendarKey = ' + CAST(@CalendarKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' AND Entity =''Attendee'' '
		SELECT @MyStatement = @MyStatement + ' AND IsDistributionGroup = 0 ' -- Attendeed not belonging to groups		
		SELECT @MyStatement = @MyStatement + ' AND EntityKey NOT IN ( '
		SELECT @MyStatement = @MyStatement + @EntityKeys
		SELECT @MyStatement = @MyStatement + ' ) '
		
		EXEC ( @MyStatement )	
	
	END
	
	
	IF @Entity = 'Resource'
	BEGIN
		
		SELECT @MyStatement = 'DELETE tCalendarAttendee WHERE CalendarKey = ' + CAST(@CalendarKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' AND Entity =''Resource'' '
		SELECT @MyStatement = @MyStatement + ' AND EntityKey NOT IN ( '
		SELECT @MyStatement = @MyStatement + @EntityKeys
		SELECT @MyStatement = @MyStatement + ' ) '
		
		EXEC ( @MyStatement )	
	
	END
	
		
	RETURN 1
GO
