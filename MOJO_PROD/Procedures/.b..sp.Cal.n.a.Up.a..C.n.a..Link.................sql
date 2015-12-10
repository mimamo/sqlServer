USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarUpdateContactLink]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sptCalendarUpdateContactLink]
	@CalendarKey int,
	@ContactCompanyKey int,
	@UserKey int,
	@Application varchar(50)

AS --Encrypt

	DECLARE @Parms varchar(500)
	SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @CalendarKey) + ', @ContactCompanyKey=' + Convert(varchar(7), @ContactCompanyKey)
	
	EXEC sptCalendarUpdateLogInsert @CalendarKey, @UserKey, 'U', 'sptCalendarUpdateContactLink', @Parms, @Application	 
	
	IF @ContactCompanyKey IS NULL				
		UPDATE
			tCalendar
		SET
			ContactCompanyKey = 0,
			ContactUserKey = 0,
			ContactLeadKey = 0
		WHERE
			CalendarKey = @CalendarKey 
			
	ELSE
		UPDATE
			tCalendar
		SET
			ContactCompanyKey = @ContactCompanyKey
		WHERE
			CalendarKey = @CalendarKey 
	
	RETURN 1
GO
