USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLabHdr_GetDetailComments]    Script Date: 12/21/2015 14:06:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLabHdr_GetDetailComments]  
		    @Guid As UNIQUEIDENTIFIER,
		    @DocNbr as varchar(10),
		    @Employee as varchar(10),
		    @EndDate as smalldatetime,
		    @StartDate as smalldatetime
as
BEGIN
	SET NOCOUNT ON

	DECLARE @PJLabHdr_cursor cursor
	DECLARE @seq int
	DECLARE @LineNbr smallint
	DECLARE @Project varchar(16)
	DECLARE @Task varchar(32)
	DECLARE @ProjectDesc varchar(30)
	DECLARE @TaskDesc varchar(30)
	DECLARE @Day1CommentKV varchar(64)
	DECLARE @Day2CommentKV varchar(64)
	DECLARE @Day3CommentKV varchar(64)
	DECLARE @Day4CommentKV varchar(64)
	DECLARE @Day5CommentKV varchar(64)
	DECLARE @Day6CommentKV varchar(64)
	DECLARE @Day7CommentKV varchar(64)
	DECLARE @WKCommentKV varchar(64)
	DECLARE @Day1HasComment bit
	DECLARE @Day2HasComment bit
	DECLARE @Day3HasComment bit
	DECLARE @Day4HasComment bit
	DECLARE @Day5HasComment bit
	DECLARE @Day6HasComment bit
	DECLARE @Day7HasComment bit
	DECLARE @WKHasComment bit
	
	DECLARE @cDate smalldatetime
	DECLARE @DayOfWeek int
	DECLARE @Body varchar(8000)
	declare @FirstDayOfWeek varchar(3)
	DECLARE	@iFirstDayOfWeek integer
    	DECLARE @CommentOption char(1)


	SET @Day1HasComment = 0
	SET @Day2HasComment = 0
	SET @Day3HasComment = 0
	SET @Day4HasComment = 0
	SET @Day5HasComment = 0
	SET @Day6HasComment = 0
	SET @Day7HasComment = 0
	SET @WKHasComment = 0

	SET @ProjectDesc = ''
	SET @TaskDesc = ''
	SET @Day1CommentKV = ''
	SET @Day2CommentKV = ''
	SET @Day3CommentKV = ''
	SET @Day4CommentKV = ''
	SET @Day5CommentKV = ''
	SET @Day6CommentKV = ''
	SET @Day7CommentKV = ''
	SET @WKCommentKV = ''

	SET @seq = 0
	SET @FirstDayOfWeek = ''


	--Get the first day of the week configured
	SELECT @FirstDayOfWeek = SUBString(control_data,221,3) from PJCONTRL where control_code = 'SETUP' and control_type = 'TM'
	SELECT @iFirstDayOfWeek = 
	      CASE @FirstDayOfWeek
	         WHEN '' THEN 7
	         WHEN 'Sun' THEN 7
	         WHEN 'Mon' THEN 1
	         WHEN 'Tue' THEN 2
	         WHEN 'Wed' THEN 3
	         WHEN 'Thu' THEN 4
	         WHEN 'Fri' THEN 5
	         WHEN 'Sat' THEN 6
	         ELSE 7
	      END
	--Set the first day of the week
	SET DATEFIRST @iFirstDayOfWeek


	--Check if daily or weekly comment is enabled and hold the option in @CommentOption
	if not exists (select 1 from PJCONTRL where control_code = 'SETUP1' and control_type = 'TM')
		SET @CommentOption = 'W'
	else
		BEGIN
		SELECT @CommentOption = substring(control_data,3,1) from PJCONTRL where control_code = 'SETUP1' and control_type = 'TM'
		if @CommentOption <> 'W'
			SET @CommentOption = 'D'
		END



	SET @PJLabHdr_cursor = CURSOR FOR
	select t.linenbr, t.project, t.pjt_entity, 
	"project_desc" = 
	      CASE
		WHEN p.project_desc IS NULL THEN 'None'
		ELSE p.project_desc
	      END,
	"pjt_entity_desc" = 
	      CASE
		WHEN pp.pjt_entity_desc IS NULL THEN 'None'
		ELSE pp.pjt_entity_desc
	      END
	from PJLabDet as t
	left outer join PJProj as p on t.project = p.project
	left outer join PJPent as pp on t.project = pp.project and t.pjt_entity = pp.pjt_entity
	where docnbr = @DocNbr

	OPEN @PJLabHdr_cursor

	--Loop through each timecard line item and retrieve the Comment Key value
	-- and determine if comments exists or not
	FETCH NEXT FROM @PJLabHdr_cursor INTO @LineNbr, @Project, @Task, @ProjectDesc, @TaskDesc
	WHILE @@FETCH_STATUS = 0
		BEGIN
		
		--If weekly comment is enabled, return the week ending key value
		--and an indicator if a comment exists or not
		if @CommentOption = 'W'
			BEGIN			
			--Build the comment key value for cDate
			SELECT @WKCommentKV = RTRIM(@Project) + ' ' + RTRIM(@Task) + ' ' + @Employee + ' ' + CONVERT(varchar(8),@EndDate,112)
			--Check if a comment exists for this day
			Exec PJNotes_DoesCommentExist @WKCommentKV, 'TCIC', @WKHasComment output
			
			SELECT @Body = '<TimeDetail><LNbr>'+CAST(@LineNbr as varchar)+'</LNbr><WeekKV>'+RTRIM(@WKCommentKV)+'</WeekKV><WeekHC>'+CAST(@WKHasComment as varchar)+'</WeekHC><ProjectDesc>'+dbo.XMLEncode(RTRIM(@ProjectDesc))+'</ProjectDesc><TaskDesc>'+dbo.XMLEncode(RTRIM(@TaskDesc))+'</TaskDesc><CommentOption><Value>'+@CommentOption+'</Value></CommentOption></TimeDetail>'
			INSERT INTO StoredProcedureResultSet (ID, SequenceNumber, Body)
			VALUES (@Guid, @seq, @Body)			

			END
		--else daily comment is enabled, return all the daily comment key values
		--and indicators to show if a comment exists or not
		else			
			BEGIN
			SELECT @cDate = @StartDate
			WHILE(@cDate < DATEADD(day,1,@EndDate))
				BEGIN
		
				SELECT @DayOfWeek = Datepart(dw,@cDate)

				
				if (@DayOfWeek = 1)
					BEGIN
					--Build the comment key value for cDate
					SELECT @Day1CommentKV = RTRIM(@Project) + ' ' + RTRIM(@Task) + ' ' + @Employee + ' ' + CONVERT(varchar(8),@cDate,112)
					--Check if a comment exists for this day
					Exec PJNotes_DoesCommentExist @Day1CommentKV, 'TCIC', @Day1HasComment output
					END

				if (@DayOfWeek = 2)
					BEGIN
					--Build the comment key value for cDate
					SELECT @Day2CommentKV = RTRIM(@Project) + ' ' + RTRIM(@Task) + ' ' + @Employee + ' ' + CONVERT(varchar(8),@cDate,112)
					--Check if a comment exists for this day
					Exec PJNotes_DoesCommentExist @Day2CommentKV, 'TCIC', @Day2HasComment output
					END

				if (@DayOfWeek = 3)
					BEGIN
					--Build the comment key value for cDate
					SELECT @Day3CommentKV = RTRIM(@Project) + ' ' + RTRIM(@Task) + ' ' + @Employee + ' ' + CONVERT(varchar(8),@cDate,112)
					--Check if a comment exists for this day
					Exec PJNotes_DoesCommentExist @Day3CommentKV, 'TCIC', @Day3HasComment output
					END

				if (@DayOfWeek = 4)
					BEGIN
					--Build the comment key value for cDate
					SELECT @Day4CommentKV = RTRIM(@Project) + ' ' + RTRIM(@Task) + ' ' + @Employee + ' ' + CONVERT(varchar(8),@cDate,112)
					--Check if a comment exists for this day
					Exec PJNotes_DoesCommentExist @Day4CommentKV, 'TCIC', @Day4HasComment output
					END

				if (@DayOfWeek = 5)
					BEGIN
					--Build the comment key value for cDate
					SELECT @Day5CommentKV = RTRIM(@Project) + ' ' + RTRIM(@Task) + ' ' + @Employee + ' ' + CONVERT(varchar(8),@cDate,112)
					--Check if a comment exists for this day
					Exec PJNotes_DoesCommentExist @Day5CommentKV, 'TCIC', @Day5HasComment output
					END

				if (@DayOfWeek = 6)
					BEGIN
					--Build the comment key value for cDate
					SELECT @Day6CommentKV = RTRIM(@Project) + ' ' + RTRIM(@Task) + ' ' + @Employee + ' ' + CONVERT(varchar(8),@cDate,112)
					--Check if a comment exists for this day
					Exec PJNotes_DoesCommentExist @Day6CommentKV, 'TCIC', @Day6HasComment output
					END

				if (@DayOfWeek = 7)
					BEGIN
					--Build the comment key value for cDate
					SELECT @Day7CommentKV = RTRIM(@Project) + ' ' + RTRIM(@Task) + ' ' + @Employee + ' ' + CONVERT(varchar(8),@cDate,112)
					--Check if a comment exists for this day
					Exec PJNotes_DoesCommentExist @Day7CommentKV, 'TCIC', @Day7HasComment output
					END

				SELECT @cDate = DATEADD(day,1,@cDate)
				END

			SELECT @Body = '<TimeDetail><LNbr>'+CAST(@LineNbr as varchar)+'</LNbr><Day1KV>'+RTRIM(@Day1CommentKV)+'</Day1KV><Day1HC>'+cast(@Day1HasComment as varchar)+'</Day1HC>'
			print @Body
			SELECT @Body = @Body+'<Day2KV>'+RTRIM(@Day2CommentKV)+'</Day2KV><Day2HC>'+cast(@Day2HasComment as varchar)+'</Day2HC>'
			print @Body
			SELECT @Body = @Body+'<Day3KV>'+RTRIM(@Day3CommentKV)+'</Day3KV><Day3HC>'+cast(@Day3HasComment as varchar)+'</Day3HC>'
			print @Body
			SELECT @Body = @Body+'<Day4KV>'+RTRIM(@Day4CommentKV)+'</Day4KV><Day4HC>'+cast(@Day4HasComment as varchar)+'</Day4HC>'
			print @Body
			SELECT @Body = @Body+'<Day5KV>'+RTRIM(@Day5CommentKV)+'</Day5KV><Day5HC>'+cast(@Day5HasComment as varchar)+'</Day5HC>'
			print @Body
			SELECT @Body = @Body+'<Day6KV>'+RTRIM(@Day6CommentKV)+'</Day6KV><Day6HC>'+cast(@Day6HasComment as varchar)+'</Day6HC>'
			print @Body
			SELECT @Body = @Body+'<Day7KV>'+RTRIM(@Day7CommentKV)+'</Day7KV><Day7HC>'+cast(@Day7HasComment as varchar)+'</Day7HC>'
			print @Body
			SELECT @Body = @Body+'<ProjectDesc>'+dbo.XMLEncode(RTRIM(@ProjectDesc))+'</ProjectDesc><TaskDesc>'+dbo.XMLEncode(RTRIM(@TaskDesc))+'</TaskDesc><CommentOption><Value>'+@CommentOption+'</Value></CommentOption></TimeDetail>'
			print @Body

			INSERT INTO StoredProcedureResultSet (ID, SequenceNumber, Body)
			VALUES (@Guid, @seq, @Body)			

			END	

		SET @seq = @seq + 1
		FETCH NEXT FROM @PJLabHdr_cursor INTO @LineNbr, @Project, @Task, @ProjectDesc, @TaskDesc
		END	


	CLOSE @PJLabHdr_cursor
	DEALLOCATE @PJLabHdr_cursor
	
END
GO
