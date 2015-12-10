USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactGetEvents]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sptContactGetEvents]

	(
		@ContactCompanyKey int,
		@ContactKey int,
		@StartDate smalldatetime,
		@History int
	)

AS --Encrypt

if @ContactKey = 0
	if @History = 0
		Select 
			ca.*,
			ca.EventStart as StartDate, 	
			convert(char(8), ca.EventStart, 108) as StartTime,
			convert(char(8), ca.EventEnd, 108) as EndTime
		from
			tCalendar ca (nolock)
		Where
			EventStart >= @StartDate and
			ContactCompanyKey = @ContactCompanyKey
		Order By 
			EventStart DESC
	else
		Select 
			ca.*,
			ca.EventStart as StartDate, 	
			convert(char(8), ca.EventStart, 108) as StartTime,
			convert(char(8), ca.EventEnd, 108) as EndTime

			
		from
			tCalendar ca (nolock)
		Where
			EventStart < @StartDate and
			ContactCompanyKey = @ContactCompanyKey
		Order By 
				EventStart DESC
else
	if @History = 0
		Select 
			ca.*,
			ca.EventStart as StartDate, 	
			convert(char(8), ca.EventStart, 108) as StartTime,
			convert(char(8), ca.EventEnd, 108) as EndTime

		from
			tCalendar ca (nolock)
		Where
			EventStart >= @StartDate and
			ContactCompanyKey = @ContactCompanyKey and
			ContactUserKey = @ContactKey
		Order By 
				EventStart DESC
	else
		Select 
			ca.*,
			ca.EventStart as StartDate, 	
			convert(char(8), ca.EventStart, 108) as StartTime,
			convert(char(8), ca.EventEnd, 108) as EndTime

		from
			tCalendar ca (nolock)
		Where
			EventStart < @StartDate and
			ContactCompanyKey = @ContactCompanyKey and
			ContactUserKey = @ContactKey
		Order By 
				EventStart DESC
GO
