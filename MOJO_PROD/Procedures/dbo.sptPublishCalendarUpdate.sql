USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPublishCalendarUpdate]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPublishCalendarUpdate]
	@PublishCalendarKey int,
	@CompanyKey int,
	@PublishCalendarName varchar(500),
	@Criteria text
AS

/*
|| When      Who Rel      What
|| 6/7/12    CRG 10.5.5.6 Created
*/

	IF @PublishCalendarKey = 0
	BEGIN
		INSERT	tPublishCalendar
				(CompanyKey,
				PublishCalendarName,
				Criteria)
		VALUES	(@CompanyKey,
				@PublishCalendarName,
				@Criteria)

		RETURN	@@IDENTITY
	END
	ELSE
		UPDATE	tPublishCalendar
		SET		PublishCalendarName = @PublishCalendarName,
				Criteria = @Criteria
		WHERE	PublishCalendarKey = @PublishCalendarKey

	RETURN @PublishCalendarKey
GO
