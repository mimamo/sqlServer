USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportCalendarEvent]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportCalendarEvent]
	@Subject varchar(100),
	@Location varchar(100),
	@Description varchar(4000),
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@StartTime smalldatetime,
	@EndTime smalldatetime,
	@CompanyKey int,
	@UserKey int,
	@Recurring tinyint,
	@RecurringInterval smallint,
	@RecurringNumber int,
	@AuthorID varchar(100),
	@ReminderTime int,
	@ReminderSent tinyint
AS --Encrypt
	
	
	Declare @RecurringSettings varchar(500)
		,@RecurringEndType varchar(50)
		,@RecurringCount int
		,@OriginalStart smalldatetime		
		,@Pattern int
		,@RecurCount int
		,@ParentKey int
		,@AllDayEvent int
		,@RecurringEndDate  smalldatetime

		
	Select @RecurringSettings = ''
	       ,@RecurringEndType = ''
	       ,@RecurringEndDate = '12/12/2050'
	       ,@OriginalStart = @StartTime
	       ,@ParentKey = 0
	       ,@Pattern  = 1
	       ,@RecurCount=0
	       ,@AllDayEvent = 0
		
		
	Select @ParentKey = 0 	
	
	Declare @ProjectKey int, @Type smallint, @oIdentity int, @AuthorKey int
	
	if @AuthorID is not null
	BEGIN
		Select @AuthorKey = UserKey from tUser (nolock) Where SystemID = @AuthorID and @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey)
		if @AuthorKey is null
		Return -1
	END
	ELSE
		Select @AuthorKey = @UserKey
	
	       
	
	IF @Recurring = 1
		
			IF @RecurringInterval = 1
				Select @RecurringSettings = '<settings DayPattern="DayNumber" Day="1"></settings>'
				      ,@RecurringEndType = 'Occurence'
				      ,@RecurringEndDate = '12/12/2050'
				      ,@OriginalStart = @StartTime
				      ,@ParentKey = 0
				      ,@Pattern  = 1
				       


			ELSE IF @RecurringInterval = 2
				      Select @RecurringSettings = '<settings MonthPattern="Day" Days="' + DateName(d,@StartTime) + '"></settings>'
				      ,@RecurringEndType = 'Occurence'
				      ,@RecurringEndDate = '12/12/2050'
				      ,@OriginalStart = @StartTime
				      ,@ParentKey = 0
				      ,@Pattern  = 2

	

			ELSE IF @RecurringInterval = 3
				        Select @RecurringSettings = '<settings MonthPattern="Day" Days="' + DateName(d,@StartTime) + '"></settings>'
				      ,@RecurringEndType = 'Occurence'
				      ,@RecurringEndDate = '12/12/2050'
				      ,@OriginalStart = @StartTime
				      ,@ParentKey = 0
				      ,@Pattern  = 3



				     
			ELSE IF @RecurringInterval = 4
				
				  Select @RecurringSettings = '<settings MonthPattern="Day" Days="' + DateName(d,@StartTime) + '"></settings>'
				      ,@RecurringEndType = 'Occurence'
				      ,@RecurringEndDate = '12/12/2050'
				      ,@OriginalStart = @StartTime
				      ,@ParentKey = 0
				      ,@Pattern  = 4

			     
	
		







	INSERT tCalendar

	(
		EventLevel,
		Subject,
		Description,
		Location,
		EventStart,
		EventEnd,
		ProjectKey,
		CompanyKey,
		ShowTimeAs,
		Visibility,
		Recurring,
		ReminderTime,
		ParentKey,
		OriginalStart,
		Deleted,
		AllDayEvent,  	 	
		ReminderSent,
		RecurringSettings,
		Pattern,
		RecurringCount,
		RecurringEndDate,
		RecurringEndType,
		DateUpdated
		)

	VALUES
		(
		1,
		@Subject,
		@Description,
		@Location,
		@StartTime,
		@EndTime,
		@ProjectKey,
		@CompanyKey,
		3,
		@ReminderTime,
		0,
		@Recurring,
		0,
		@OriginalStart,
		0,
		@AllDayEvent,
		0,
		@RecurringSettings,
		@Pattern,
		@RecurringNumber,
		@RecurringEndDate,
		@RecurringEndType,
		GETUTCDATE()
		)	
	SELECT @oIdentity = @@IDENTITY

			     
	Insert into tCalendarAttendee 
	(CalendarKey,Entity,EntityKey,Status)
	Values
	(@oIdentity,'Organizer',@AuthorKey,2)		

				
		
	
	RETURN 1
GO
